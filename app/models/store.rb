class Store < ActiveRecord::Base
  resourcify

   has_many   :substores, class_name: "Store",  foreign_key: "parent_id"
	 belongs_to  :parent, class_name: "Store"
	 belongs_to :store_type
	 has_many :batches
	 #has_many :vendors
	 #has_many :supplies
	 belongs_to :store_operation



  default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :store_type, presence: true
	validates :store_operation, presence: true


	before_save :modify_attr
	before_validation :name_unique

  #permissible roles within this array
  serialize :store_roles

	def modify_attr
		self.name = name.titleize.strip
	end

	def name_unique
		self.name = name.titleize.strip
	end


  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end

end
