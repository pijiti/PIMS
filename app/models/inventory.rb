class Inventory < ActiveRecord::Base
  belongs_to :brand
  belongs_to :store

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
      i.update(:units => i.units.to_f + (row["units"]).to_f) if i
    end
  end
end
