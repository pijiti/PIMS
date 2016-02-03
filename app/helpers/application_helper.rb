module ApplicationHelper

  def stores_based_on_current_time
    if can? :manage, :all
      return Store.all
    end
    #@stores = Store.where("open_time <  ? and close_time >  ? ", Time.now , Time.now)
    current_time = Time.zone.now
    logger.debug "===========Current time[#{current_time}]============"
    current_year = current_time.year
    current_month = current_time.month
    current_day = current_time.day
    ids = []
    if current_user.has_role? "Admin"
      all_stores = Store.all
    else
      all_stores = Store.where(:id => current_user.roles.where(:resource_type => "Store").pluck(:resource_id))
    end
    Store.all.each do |store|
      next if store.open_time.blank? or store.close_time.blank? or !all_stores.include? store
      open_time = Time.zone.local(current_year, current_month, current_day, store.open_time.hour, store.open_time.min)
      close_time = Time.zone.local(current_year, current_month, current_day, store.close_time.hour, store.close_time.min)
      logger.debug "===========Open time[#{open_time}]============"
      logger.debug "===========Close time[#{close_time}]============"
      if close_time < open_time and current_time > open_time
        ids << store.id
      elsif current_time.between?(open_time,close_time)
        logger.debug("YES!!!!#{store.id}")
        ids << store.id
      end
    end

    Store.where(:id => ids)
  end

  def me
    current_user
  end

  def flash_class(level)
    case level
      when 'notice' then
        "alert alert-info"
      when 'success' then
        "alert alert-success"
      when 'error' then
        "alert alert-danger"
      when 'alert' then
        "alert alert-warning"
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  ######Supply helpers start##########

  def invoice_date_display(supply)
    if supply and supply.invoice_date
      supply.invoice_date.strftime("%d/%m/%Y")
    end
  end

  def mfd_date_display(batch)
    if batch and batch.mfd_date
      batch.mfd_date.strftime("%d/%m/%Y")
    end
  end

  def expiry_date_display(batch)
    if batch and batch.expiry_date
      batch.expiry_date.strftime("%d/%m/%Y")
    end
  end

  #highlight batch row if expiry date is > 6 months of date of supply
  def highlight_batch(batch)
    begin
      "red" if batch.supply and batch.expiry_date < (batch.supply.invoice_date + 6.months)
    rescue => e
      logger.error "ERROR========!!!!!!!!!!!!!!!!"
      logger.debug e.message
      ""
    end
  end


  def calculate_units_in_pack(batch)
    if batch.qty and batch.brand and batch.loose_units.blank?
      (batch.qty.to_f * batch.brand.pack_size.to_f).to_i
    elsif batch.qty and batch.brand
      (batch.qty.to_f * batch.brand.pack_size.to_f).to_i + batch.loose_units.to_i
    else
      0
    end
  end

  def calculate_pack_number(batch)
    if batch.loose_units.blank?
      (batch.qty.to_i)
    else
      "#{batch.qty.to_i} packs and #{batch.loose_units.to_i} loose units"
    end
    #"%.2f" % (batch.qty + (batch.try(:loose_units) || 0) / batch.brand.pack_size.to_f)
  end

  def pack_and_units(qty, pack_size)
    if qty.to_i % pack_size.to_i == 0
      qty.to_i / pack_size.to_i
    else
      "#{qty.to_i / pack_size.to_i} packs and #{qty.to_i % pack_size.to_i } loose units"
    end

  end


  def rate_per_unit(batch)
    begin
      ("%.2f" % (batch.rate / calculate_units_in_pack(batch))).to_f
    rescue
      0
    end
  end


  #calculate total money lost in expired drugs from expired batches
  def total_money_lost_in_expired_drugs(ibatches)
    amount = 0
    ibatches.each do |ib|
      next if ib.units == 0 or ib.expired.blank?
      amount += rate_per_unit(ib.batch) * ib.units
    end
    "%.2f" % amount
  end

  def vendors_from_inventories(pharm_item)
    #Vendor.where(:id => Supply.where(:id => Inventory.generic_batches(pharm_item)).pluck(:vendor_id))
    Vendor.all
  end

  #drug count for a store
  def generic_drug_count(pharm_item, store)
    inventories = Inventory.includes(:inventory_batches).where(:pharm_item => pharm_item, :store => store)
    units_counter = 0
    inventories.each do |inventory|
      units_counter += inventory.inventory_batches.where(:expired => nil).sum(:units)
    end
    units_counter
  end

  def order_more_btn(i, s)
    units_counter = generic_drug_count(i.pharm_item, s)
    if units_counter == 0
      "btn-danger"
    elsif (s.parent.blank? and !units_counter.blank? and units_counter > i.pharm_item.try(:main_restock_level)) or (!units_counter.blank? and units_counter > i.pharm_item.try(:dispensary_restock_level))
      "btn-success"
    else
      "btn-warning"
    end
  end

  ######Supply helpers end##########

  def prescription_date_display(pb)
    if pb and pb.prescription_date
      pb.prescription_date.strftime("%d/%m/%Y")
    end
  end


  def stock_level_indicator(units, brand, store)

    if store.parent.blank?
      if units < brand.main_restock_level
        "Low"
      elsif units > brand.main_restock_level.to_i and units < 5 *brand.main_restock_level.to_i
        "Medium"
      else
        "High"
      end
    else
      if units < brand.dispensary_restock_level
        "Low"
      elsif units > brand.dispensary_restock_level.to_i and units < 5 * brand.dispensary_restock_level.to_i
        "Medium"
      else
        "High"
      end
    end

  end

  def days_ago(t1,t2)
    ((t1 - t2)/(24*60*60)).round
  end

  def incomplete_orders
    return [] if current_store.blank?
    eligible_users = User.with_any_role({:name => "Pharmacist", :resource => current_store}, {:name => "Pharmacy Technician", :resource => current_store}, {:name => "Admin"})
    if eligible_users.include? current_user
      orders = Order.includes(:from_store).where(:from_store => current_store , :status => "ORDER_INCOMPLETE")
    else
      orders = []
    end
    logger.debug orders.to_json
    orders
  end

  def get_store_list
    Store.all.pluck(:name,:id).sort
  end

  def get_user_roles
    role_array = []
    roles = Role.all.pluck(:name).uniq
    roles.each do |role|
      role_array << [false,role]
    end
    role_array
  end

end
