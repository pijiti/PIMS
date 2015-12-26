class RemoveOrphanReceipts < ActiveRecord::Migration
  def change
    LostDrug.all.each do |l|
      l.destroy if l.receipt.blank?
    end
  end
end
