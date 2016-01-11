class ReceiptsController < ApplicationController
  before_action :authenticate_user!, :except => [:generate_pdf, :order_receipt]
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]


  def filter
    from_store = params[:receipt][:from_store_id]
    to_store = params[:receipt][:to_store_id]
    pharm_item = params[:receipt][:pharm_item_id]
    requests_from = params[:receipt][:created_at]
    status = params[:receipt][:confirm_receipt]
    @orders = []
    if can? :manage, :all
      @orders = Order.includes(:service_requests, :receipts).where(:status => ["SERVICE_COMPLETE", "DELIVERY_COMPLETE"]).order("id DESC")
    else
      @orders = Order.includes(:service_requests, :receipts).where(:status => ["SERVICE_COMPLETE", "DELIVERY_COMPLETE"]).order("id DESC")
    end

    @orders = @orders.includes(:service_requests, :receipts).where(:id => Receipt.where(:from_store_id => from_store).pluck(:order_id)) if !from_store.blank?
    @orders = @orders.includes(:service_requests, :receipts).where(:id => Receipt.where(:to_store_id => to_store).pluck(:order_id)) if !to_store.blank?
    @orders = @orders.includes(:service_requests, :receipts).where("updated_at > ?", Time.strptime(requests_from, "%d/%m/%Y")) if !requests_from.blank?
    @orders = @orders.includes(:service_requests, :receipts).where(:id => Receipt.where(:confirm_receipt => status).pluck(:order_id)) if !status.blank? and status != "ALL"

  end

  def confirm
    @order = Order.find_by_id(params[:order][:id])
    @order.attributes = order_params
    #@receipt = Receipt.find_by_id(params[:receipt][:id])
    #if params[:receipt][:received_qty] and params[:receipt][:received_qty].to_i <= @receipt.qty and params[:receipt][:received_qty].to_i > -1
    if @order.save
      #if @receipt.update(:received_qty => params[:receipt][:received_qty], :lost_reason => params[:receipt][:lost_reason], :comments => params[:receipt][:comments])

      @order.receipts.each do |r|

        if r.received_qty.blank?
          redirect_to(receipts_path, :notice => "Received quantity can't be blank") and return
        elsif r.received_qty > r.qty
          redirect_to(receipts_path, :notice => "Received quantity can't be more than requested quantity") and return
        end

        #lost some drugs in transit
        if r.qty.to_i > r.received_qty.to_i
          LostDrug.create(:receipt => r, :lost_qty => r.qty.to_i - r.received_qty.to_i)
        end
        r.post_confirm_receipt(r.received_qty)
      end

      #check if order is completed
      if @order and @order.service_requests.where.not(:status => "COMPLETED").blank?
        @order.update(:status => "DELIVERY_COMPLETE")
        User.with_any_role({:name => "Pharmacy Technician", :resource => @order.receipts.last.to_store}, {:name => "Admin"}).each do |u|
          #create alerts
          Alert.create(:store => @order.service_requests.last.try(:from_store), :user => u, :status => "UNREAD", :order => @order, :alert_type => "SERVICED", :message => "Order #{@order.try(:number)} has been serviced")
        end
      end

      flash[:notice] = "Order #{@order.number} has been received."

    else
      @error = @order.errors.full_messages
      flash[:error] = "#{@error.to_sentence}"
    end
    redirect_to receipts_path
  end

  #
  def lost_drugs
    @lost_drugs = LostDrug.includes(:receipt, receipt: [:from_store, :to_store, batch: [:brand]]).all
  end

  # GET /receipts
  # GET /receipts.json
  def index
    #if can? :manage, :all
    #  @receipts = Receipt.includes(:inventory, :from_store, :batch).all.order('updated_at DESC')
    #else
    #  @receipts = Receipt.includes(:inventory, :from_store, :batch).where(:to_store_id => current_store.id).all.order('updated_at DESC')
    #end

    if can? :manage, :all
      @orders = Order.includes(:receipts).where(:status => ["SERVICE_COMPLETE", "DELIVERY_COMPLETE"]).order("id DESC")
    else
      @to_store = current_store
      @orders = Order.includes(:receipts).where(:status => ["SERVICE_COMPLETE", "DELIVERY_COMPLETE"]).order('id DESC')
    end
    @filter = Receipt.new(:confirm_receipt => " ALL ")
    @stores = Store.all
    @pharm_items = PharmItem.all
  end

  # GET /receipts/1
  # GET /receipts/1.json
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  # POST /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to @receipt, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1
  # PATCH/PUT /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to @receipt, notice: 'Receipt was successfully updated.' }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1
  # DELETE /receipts/1.json
  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to receipts_url, notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # using webkit
  def generate_pdf
    @order = Order.find_by_id(params[:order])
    #check if file exists
    file_path = "#{$pdf_files_location}/#{@order.number}.pdf"
    if File.file?(file_path)
      logger.debug "=====found the file==="
    else
      if Rails.env == "development"
        kit = PDFKit.new("http://localhost:4050/receipts/order_receipt?id=#{params[:order]}")
      else
        kit = PDFKit.new("http://192.168.1.4:3000/receipts/order_receipt?id=#{params[:order]}")
      end
      kit.to_file("#{$pdf_files_location}/#{@order.number}.pdf")
    end


    #redirect_to invoices_path
    send_file file_path, :type => 'application/pdf', :disposition => 'inline'
  end


  # using prawn
  def print_pdf
    @order = Order.find_by_id(params[:order])
    #check if file exists
    file_path = "#{$pdf_files_location}/#{@order.number}.pdf"


    # kit = Prawn::Document.new
    # kit.text "Help! I am trapped in a PDF factory!"
    # kit.autoprint
    # kit.render_file(file_path)

    counter = 0
    Prawn::Document.generate(file_path) do |pdf|
      pdf.text "<strong><font size='22'>State Specialist Hospital, Ondo Pharmacy Department</font></strong>", :inline_format => true , :align => :center
      pdf.text "<font size='18'>Store Requisition and Issue Voucher (SRV)</font>", :inline_format => true , :align => :center
      pdf.text "Order No: #{@order.number}", :inline_format => true , :align => :left
      pdf.text "Date printed: #{Time.now.strftime("%d/%m/%Y")}", :inline_format => true , :align => :left
      table_data = []
      table_data << [Prawn::Table::Cell::Text.new(pdf, [0, 0], :content => "SNo" , :inline_format => true),"Generic",  "Brand" , "Batch No", "Qty Requested" ,"Qty Issued"]
      @order.service_requests.each do |s|
        counter += 1
        s.receipts.each do |r|
          table_data << [Prawn::Table::Cell::Text.new(pdf, [0, 0], :content => "#{counter}", :inline_format => true), s.pharm_item.try(:name) , r.batch.try(:brand).try(:name) , r.batch.try(:batch_number) , r.qty , r.received_qty ]
        end
      end
      pdf.table(table_data, :width => 500)
      pdf.autoprint
    end

    #redirect_to invoices_path
    send_file file_path, :type => 'application/pdf', :disposition => 'inline'
  end


  # def generate_pdf
  #   @order = Order.find_by_id(params[:order])
  #   #check if file exists
  #   file_path =  "#{$pdf_files_location}/#{@order.number}.pdf"
  #   if File.file?(file_path) and false
  #     logger.debug "=====found the file==="
  #   else
  #     if Rails.env == "development"
  #       kit = PDFKit.new("http://localhost:4050/receipts/order_receipt?id=#{params[:order]}")
  #       kit = Prawn::Document.new
  #       kit.text "Help! I am trapped in a PDF factory!"
  #       kit.autoprint
  #
  #     else
  #       kit = PDFKit.new("http://192.168.1.4:3000/receipts/order_receipt?id=#{params[:order]}")
  #     end
  #     # kit.to_file("#{$pdf_files_location}/#{@order.number}.pdf")
  #     kit.render_file("#{$pdf_files_location}/#{@order.number}.pdf")
  #   end
  #
  #
  #   #redirect_to invoices_path
  #   send_file file_path, :type => 'application/pdf', :disposition => 'inline'
  # end


  def order_receipt
    @order = Order.find_by_id(params[:id])
    render "vouchers/order_receipt", :layout => false
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def receipt_params
    params.require(:receipt).permit(:batch_id, :inventory_id, :from_store_id, :qty, :confirm_receipt, :received_qty)
  end

  def order_params
    params.require(:order).permit(:id, receipts_attributes: [:batch_id, :inventory_id, :from_store_id, :qty, :confirm_receipt, :received_qty, :lost_reason, :comments, :id])
  end
end
