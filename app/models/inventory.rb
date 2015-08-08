class Inventory < ActiveRecord::Base
  belongs_to :brand
  belongs_to :store
  belongs_to :pharm_item

  has_many :inventory_batches  , :dependent => :destroy
  has_many :batches , :through => :inventory_batches

  attr_accessor :generic_drug

  #get all supply id from inventory and pharm item id
  def self.generic_batches(p)
    ids = []
    Inventory.where(:pharm_item_id => p).each do |i|
      ids << i.batches.pluck(:id)
    end
    Batch.where( :id => ids.flatten.uniq ).pluck(:supply_id)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      column_names = ["brand_id" , "store_id" , "units"]
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end

  #bulk upload
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      logger.debug "=========#{row}============"
      i = Inventory.where(:brand_id => row["brand_id"] , :store_id => row["store_id"]).first
      i.update(:units => i.units.to_f + (row["units"]).to_f , :qty_last_added => row["units"]) if i
    end
  end
end
