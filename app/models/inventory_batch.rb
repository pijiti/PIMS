class InventoryBatch < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :batch

  attr_accessor :allot , :store_id , :pharm_item_id

  def allotment(store_id , sq_id = nil)
    response = nil
    if !allot.blank? and allot.to_i <= self.units

      i = Inventory.where(:store => store_id , :brand_id => batch.brand_id).first
      if i
        #reduce from request_store
        self.update(:units => self.units.to_i - allot.to_i)

        #increment in from store
        #irs =  i.inventory_batches.where(:batch_id => self.batch_id)
        #if irs.blank?
        #  irs = InventoryBatch.create(:inventory_id => i.id , :batch_id => self.batch_id , :units => allot)
        #else
        #  irs.first.update(:units => irs.first.units + allot.to_i)
        #end

        #receiving store will get the drugs post confirmation of receipt
        Receipt.create(:inventory => i , :from_store_id => self.inventory.store_id , :qty => allot , :batch_id => self.batch_id , :to_store_id => store_id , :service_request_id => sq_id)

        store = Store.find_by_id(store_id)
        response = "Successfully allocated the drugs to #{store.try(:name)}"
      else
        response = "Inventory not found for the store"
      end

    #else
      #response = "Unable to allocate drugs. Please check if sufficient stock is available to service the request"
    end

    response
  end




end
