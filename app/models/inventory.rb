class Inventory < ActiveRecord::Base
  belongs_to :brand
  belongs_to :store
  belongs_to :pharm_item

  has_many :inventory_batches, :dependent => :destroy
  has_many :batches, :through => :inventory_batches
  has_many :receipts, :dependent => :destroy

  attr_accessor :generic_drug

  #get all supply id from inventory and pharm item id
  def self.generic_batches(p)
    ids = []
    Inventory.where(:pharm_item_id => p).each do |i|
      ids << i.batches.pluck(:id)
    end
    Batch.where(:id => ids.flatten.uniq).pluck(:supply_id)
  end

  def self.to_csv(options = {})

    logger.debug "=======TO CSV============"


    CSV.generate(options) do |csv|
      column_names = ["Generic Drug", "Brand", "Store", "Rate per unit", "Batch number", "Mfd date", "Expiry date" , "Units"]
      csv << column_names
      self.includes(:store, :brand, :batches, :inventory_batches, :pharm_item, pharm_item: [:brands], inventory_batches: [:batch], store: [:parent], batches: [:brand]).order("pharm_items.name ASC").all.each do |inventory|
        inventory.inventory_batches.where(:expired => nil).each do |ib|
          csv << [inventory.pharm_item.name, inventory.brand.name , inventory.store.name , inventory.rate_per_unit , ib.batch.batch_number , ib.batch.mfd_date , ib.batch.expiry_date , ib.units]
        end
        #  csv << inventory.attributes.values_at(["pharm_item_id" , "brand_id" , "store_id"])
      end
    end
  end

  #bulk upload
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      logger.debug "=========#{row}============"
      i = Inventory.where(:brand_id => row["brand_id"], :store_id => row["store_id"]).first
      i.update(:units => i.units.to_f + (row["units"]).to_f, :qty_last_added => row["units"]) if i
    end
  end
end
