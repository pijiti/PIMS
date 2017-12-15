class ReportsController < ApplicationController
  before_action :authenticate_user!

  # download sales pdf
  def download_sales_pdf
    # date          = DateTime.now
    @start_time   = Date.strptime(params[:date] , "%d/%m/%Y")
    @end_time     = @start_time + 24.hours
    manage_report = can? :manage, "Report"

    daily_filter

    file_name   = "#{current_store.try(:name).split(' ').join('_')}_Sales.pdf"
    file_path   = "#{$pdf_files_location}/#{file_name}"
    sales_pdf   = Sales.new(file_path,current_user,current_store,@receipts,@total_value,manage_report,@total_returns,@total_return_amount)
    file_pdf    = sales_pdf.generate()

    @file        = reports_url+"/download?file=#{file_name}"
    render template: "reports/download"
  end

  # download action for POST methods
  def download
    send_file("#{$pdf_files_location}/#{params[:file]}")
  end


  def filter_by_month
    @start_time = Time.new(params[:year], params[:month], 01)
    @end_time = @start_time.end_of_month
    requisition_filter
  end


  def sales_filter_by_month
    @start_time = Time.new(params[:year], params[:month], 01)
    @end_time = @start_time.end_of_month
    sales_filter
  end


  # for daily reports page
  def sales_filter_by_date
    date = DateTime.now
    @start_time = Time.new(date.year, date.month, params[:date].split('/')[0])
    @start_time=DateTime.strptime(params[:date], "%d/%m/%Y")
    @end_time = @start_time + 24.hours
    daily_filter
  end

  def supplies_filter_by_month
    @start_time = Time.new(params[:year], params[:month], 01)
    @marketer = params[:marketer]
    @marketer = Marketer.all.pluck(:id) if @marketer.blank?
    @end_time = @start_time.end_of_month
    supply_filter
  end


  def supplies
    date = DateTime.now
    @start_time = Time.new(date.year, date.month, 01)
    @end_time = Time.now.end_of_month

    supply_filter
  end

  # daily reports
  def daily
    date = DateTime.now
    @start_time = Time.new(date.year, date.month, date.day)
    @end_time = @start_time + 24.hours

    daily_filter
  end


  # requistion made for every month
  def requisition
    date = DateTime.now
    @start_time = Time.new(date.year, date.month, 01)
    @end_time = Time.now.end_of_month

    requisition_filter
  end

  # sales per month
  def sales
    date = DateTime.now
    @start_time = Time.new(date.year, date.month, 01)
    @end_time = Time.now.end_of_month

    sales_filter
  end


  def drugs
    @item_classes = ItemClass.includes(:sub_classes).all
    @chart_data = []
    @item_classes.each do |item|
      @chart_data << {:item => item.sub_classes.pluck(:name).map { |x| x.gsub("'", "") }, :y => item.sub_classes.try(:count), :name => item.name.gsub("'", "")}
    end

    @pharm_items = PharmItem.includes(:brands).all

    @brand_data = []
    @pharm_items.each do |p|
      @brand_data << {:item => p.brands.pluck(:name).map { |x| x.gsub("'", "") }, :y => p.brands.try(:count), :name => p.name.gsub("'", "")}
    end
  end


  def stores
    @role_store_count, @role_store_names = Store.get_user_roles(current_store)
  end


  private

  def supply_filter
    @receipts = {}

    current_date = @start_time.beginning_of_month.to_date
    current_month = @end_time.month

    @weekly_receipts = []
    weekly_total = 0
    weeks = 0
    31.times do |i|
      break if current_date.month != current_month

      # all_receipts = receipts.where("date(updated_at) = ?", current_date)
      all_receipts = Supply.where(:marketer_id => @marketer, :approval_status => "APPROVED", :store => current_store).where("date(updated_at) = ?", current_date)

      total_value = all_receipts.sum(:invoice_value)

      @receipts[current_date] = total_value.round(2)
      weekly_total += total_value.round(2)
      # weekly
      if (i+1) % 7 == 0
        @weekly_receipts << weekly_total.round(2)
        # resetting
        weekly_total = 0
        weeks += 1
      end


      current_date = current_date.next
    end

    @weekly_receipts << weekly_total
  end

  def sales_filter
    p = PrescriptionBatch.where(:store_id => current_store.try(:id)).pluck(:prescription_id)    
    @receipts = {}

    current_date = @start_time.beginning_of_month.to_date
    current_month = @end_time.month

    @weekly_receipts = []
    weekly_total = 0
    weekly_return = 0
    weeks = 0
    31.times do |i|
      break if current_date.month != current_month

      # all_receipts = receipts.where("date(updated_at) = ?", current_date)
      all_receipts = Prescription.where(:status => "DISPENSED", :id => p).where("date(updated_at) = ?", current_date)
      return_amount = Return.where(store_id: current_store.try(:id)).where("return_date = '#{current_date}'").sum(:total)

      total_value = 0
      all_receipts.each do |r|
        total_value += r.subtotal.to_f.round(2) rescue 0
      end

      @receipts[current_date] = [total_value.round(2), return_amount]
      weekly_total += total_value.round(2)
      weekly_return += return_amount.round(2)
      # weekly
      if (i+1) % 7 == 0
        @weekly_receipts << [weekly_total.round(2), weekly_return.round(2)]
        # resetting
        weekly_total = 0
        weekly_return = 0
        weeks += 1
      end


      current_date = current_date.next
    end

    @weekly_receipts << [weekly_total, weekly_return]
  end


  def daily_filter
    p = PrescriptionBatch.where(:store_id => current_store.try(:id)).pluck(:prescription_id)
    @receipts = {}

    current_date = @start_time.to_date

    # all_receipts = receipts.where("date(updated_at) = ?", current_date)
    @receipts = Prescription.where(:status => "DISPENSED", :id => p).where("date(updated_at) = ?", current_date)

    @total_value = 0
    logger.info "=====#{@receipts}===="
    logger.info "=====#{current_date}===="
    @receipts.each do |r|
      # if can? :manage, "Report"
        @total_value += r.total.to_f.round(2) rescue 0
      # else
      #   @total_value += r.subtotal.to_f.round(2) rescue 0
      # end

    end
    @total_returns = Return.where(store_id: current_store.try(:id)).where("return_date = '#{@start_time}'")
    @total_return_amount = @total_returns.sum(:total)
  end

  def requisition_filter
    @receipts = {}

    current_date = @start_time.beginning_of_month.to_date
    current_month = @end_time.month

    @weekly_receipts = []
    weekly_total = 0
    weeks = 0
    31.times do |i|
      break if current_date.month != current_month

      # all_receipts = receipts.where("date(updated_at) = ?", current_date)
      all_receipts = Receipt.where(:confirm_receipt => "COMPLETED", :to_store_id => current_store.try(:id)).where("date(updated_at) = ?", current_date)

      logger.info "Count of receipts for #{current_date} #{all_receipts.count}"

      total_value = 0
      all_receipts.each do |r|
        logger.info "#{r.id}"
        total_value += r.inventory.try(:rate_per_unit) * r.received_qty
      end

      weekly_total += total_value
      # weekly
      if (i+1) % 7 == 0
        @weekly_receipts << weekly_total
        # resetting
        weekly_total = 0
        weeks += 1
      end

      @receipts[current_date] = total_value
      current_date = current_date.next
    end

    @weekly_receipts << weekly_total
  end

end
