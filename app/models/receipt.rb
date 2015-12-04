class Receipt < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :from_store, :class_name => "Store"
  belongs_to :to_store, :class_name => "Store"
  belongs_to :batch
  belongs_to :service_request
  has_one :lost_drug

  attr_accessor :pharm_item_id

  validates_presence_of :qty
  validate :lost_reason_if_drugs_lost


  def post_confirm_receipt(q)
    #increment in from store
    irs = self.inventory.inventory_batches.where(:batch_id => self.batch_id)
    if irs.blank?
      irs = InventoryBatch.create(:inventory => self.inventory, :batch_id => self.batch_id, :units => q)
    else
      irs.first.update(:units => irs.first.units + q.to_i)
    end
    self.update(:confirm_receipt => "COMPLETED")

    #update rate per unit
    if self.inventory.rate_per_unit.blank?
      i = self.inventory
      i.update(:rate_per_unit =>  Inventory.where(:brand => i.brand).where.not(:rate_per_unit => nil).try(:last).try(:rate_per_unit))
    end

    self.service_request.update(:status => "COMPLETED") if !service_request.blank?

    User.with_any_role( {:name => "Pharmacy Technician", :resource => self.service_request.from_store} , {:name => "Admin"}).each do |u|
      #create alerts
      Alert.create(:store => self.service_request.from_store, :user => u, :status => "UNREAD", :service_request => self.service_request, :alert_type => "SERVICED", :message => "Order #{self.service_request.order.try(:number)} has been serviced")
    end

  end


  def lost_reason_if_drugs_lost
    if !received_qty.blank? and received_qty.to_i < qty.to_i
      puts "=====DRUGS HAVE BEEN LOST======"
      if self.lost_reason.blank? or self.lost_reason == "None"
        errors.add(:lost_reason , "is not valid. Please enter a valid reason")
      end
      if self.comments.blank?
        errors.add(:comments, "is mandatory when drugs have been lost.")
      end
    end
  end

end
