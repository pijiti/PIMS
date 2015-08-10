module ApplicationHelper

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
      "red" if batch.expiry_date < (batch.supply.invoice_date + 6.months)
    rescue => e
      logger.error "ERROR========!!!!!!!!!!!!!!!!"
      logger.debug e.message
      ""
    end
  end

  def calculate_units_in_pack(batch)
    if batch.qty and batch.brand
      batch.qty.to_f * batch.brand.pack_size.to_f
    else
      0
    end
  end

  def vendors_from_inventories(pharm_item)
    Vendor.where(:id => Supply.where(:id => Inventory.generic_batches(pharm_item)).pluck(:vendor_id))
  end


  def order_more_btn(i, s)
    if i.units == 0
      "btn-danger"
    elsif (s.store_type.name.downcase.include? "central" and i.units > i.pharm_item.try(:main_restock_level)) or  (i.units > i.pharm_item.try(:dispensary_restock_level))
       "btn-success"
    else
       "btn-warning"
    end
  end
  ######Supply helpers end##########

end
