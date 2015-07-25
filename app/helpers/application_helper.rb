module ApplicationHelper

  def me
  	current_user
  end

 def flash_class(level)
      case level
       when 'notice' then "alert alert-info"
       when 'success' then "alert alert-success"
       when 'error' then "alert alert-danger"
       when 'alert' then "alert alert-warning"
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

end
