class RemoveZombieCollation < ActiveRecord::Migration
  def change
    CollationBatch.all.each do |c|
      c.destroy if c.inventory_batch.blank?
    end
  end
end
