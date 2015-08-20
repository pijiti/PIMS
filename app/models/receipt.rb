class Receipt < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :from_store, :class_name => "Store"
  belongs_to :to_store, :class_name => "Store"
  belongs_to :batch
  belongs_to :service_request

  attr_accessor :pharm_item_id

  def post_confirm_receipt(q)
    #increment in from store
    irs = self.inventory.inventory_batches.where(:batch_id => self.batch_id)
    if irs.blank?
      irs = InventoryBatch.create(:inventory => self.inventory, :batch_id => self.batch_id, :units => q)
    else
      irs.first.update(:units => irs.first.units + q.to_i)
    end
    self.update(:confirm_receipt => "COMPLETED")
    self.service_request.update(:status => "COMPLETED") if !service_request.blank?
  end

end
