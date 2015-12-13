class Receipt < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :from_store, :class_name => "Store"
  belongs_to :to_store, :class_name => "Store"
  belongs_to :batch
  belongs_to :service_request
  belongs_to :order
  has_one :lost_drug

  attr_accessor :pharm_item_id

  validates_presence_of :qty
  validate :lost_reason_if_drugs_lost
  validate :check_received_qty


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
      i.update(:rate_per_unit => Inventory.where(:brand => i.brand).where.not(:rate_per_unit => nil).try(:last).try(:rate_per_unit))
    end

    self.service_request.update(:status => "COMPLETED") if !service_request.blank?

  end


  def lost_reason_if_drugs_lost
    if !received_qty.blank? and received_qty.to_i < qty.to_i
      puts "=====DRUGS HAVE BEEN LOST======"
      if self.lost_reason.blank? or self.lost_reason == "None"
        errors.add(:lost_reason, "is not valid. Please enter a valid reason")
      end
      if self.comments.blank?
        errors.add(:comments, "is mandatory when drugs have been lost.")
      end
    end
  end


  def check_received_qty
    if !self.confirm_receipt.blank?
      if self.received_qty.blank?
        self.order.errors.add(:received_qty, "cannot be blank")
      elsif self.received_qty > self.qty
        self.order.errors.add(:received_qty, "cannot be more than requested quantity")
      end
    end
  end

end
