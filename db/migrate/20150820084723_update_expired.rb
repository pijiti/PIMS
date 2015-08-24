class UpdateExpired < ActiveRecord::Migration
  def change
    InventoryBatch.all.each do |i|
      if i.batch.expiry_date < Time.now
        i.update(:expired => true)
      end
    end
  end
end
