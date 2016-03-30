class ReportsController < ApplicationController
  before_action :authenticate_user!


  def filter_by_month
    date = DateTime.now
    @start_time = Time.new(params[:year], params[:month], 01)
    @end_time = @start_time.end_of_month
    requisition_filter
  end


  def requisition
    date = DateTime.now
    @start_time = Time.new(date.year, date.month, 01)
    @end_time = Time.now.end_of_month

    requisition_filter
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


  def requisition_filter
    receipts = Receipt.where(:confirm_receipt => "COMPLETED", :to_store_id => current_store.try(:id))
                   .where("updated_at > ? and updated_at < ?", @start_time, @end_time)
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
