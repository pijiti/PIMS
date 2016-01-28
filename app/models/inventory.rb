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

  def self.to_csv(store = nil, generic = nil, brand = nil)

    logger.debug "=======TO CSV============"

    i = Inventory.includes(:store, :brand, :batches, :inventory_batches, :pharm_item, pharm_item: [:brands], inventory_batches: [:batch], store: [:parent], batches: [:brand]).order("pharm_items.name ASC").all
    i = i.where(:store_id => store) if !store.blank?
    i = i.where(:pharm_item_id => generic) if !generic.blank?
    i = i.where(:brand_id => brand) if !brand.blank?

    logger.debug "=========@@@@@@@@@@@========>#{i.count}"

    CSV.generate({}) do |csv|
      csv << ["","State Specialist Hospital,Ondo."]
      csv << ["","Pharmacy Department"]
      csv << ["" ,"Inventory Balance"]
      csv << ["Store Name: #{store.try(:name)}" , "" ,"" , "Date & Time: #{Time.now.strftime('%d-%m-%Y  at %I:%M%p')}"]
      csv << []
      # column_names = ["Generic Drug", "Brand", "Store", "Rate per unit", "Batch number", "Mfd date", "Expiry date" , "Units"]
      column_names = ["SNo", "Generic Drug", "Brand", "Batch No", "Qty" , "Rate" , "SubTotal" ]
      csv << column_names
      sno = 0
      total = 0
      i.each do |inventory|
        inventory.inventory_batches.where(:expired => nil).each do |ib|
          sno += 1
          total +=  (ib.units*inventory.rate_per_unit)
          csv << [sno , inventory.pharm_item.name, inventory.brand.name , ib.batch.batch_number ,  ib.units, inventory.rate_per_unit , (ib.units*inventory.rate_per_unit)]
        end
      end
      csv << ["" , "" , "", "","", "Total" , total]
      csv << []
      csv << []
      csv << []
      csv << []
      csv << ["In Charge Name" , "" , "" ,"" ,"" , "Receiver Name"]
      csv << []
      csv << []
      csv << []
      csv << ["In Charge Signature & Date " , "" , "" ,"" ,"" , "Receiver Signature & Date"]
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
