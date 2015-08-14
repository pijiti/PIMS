class InventoryBatch < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :batch

  attr_accessor :allot

  def allotment(store_id)
    response = ""
    if !allot.blank? and allot.to_i <= self.units

      i = Inventory.where(:store => store_id , :brand_id => batch.brand_id).first
      if i
        #reduce from request_store
        self.update(:units => self.units.to_i - allot.to_i)

        #increment in from store
        irs =  i.inventory_batches
        if irs.blank?
          irs = InventoryBatch.create(:inventory_id => i.id , :batch_id => self.batch_id , :units => allot)
        else
          irs.first.update(:units => irs.first.units + allot.to_i)
        end
        store = Store.find_by_id(store_id)
        response = "successfully allocated the drugs to #{store.try(:name)}"
      else
        response = "inventory not found for the store"
      end

    else
      response = "Unable to allocate drugs. Please check if sufficient stock is available to service the request"
    end

    response
  end


end
