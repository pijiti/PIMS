class Store < ActiveRecord::Base
  resourcify

   has_many   :substores, class_name: "Store",  foreign_key: "parent_id"
	 belongs_to  :parent, class_name: "Store"
	 belongs_to :store_type
	 has_many :batches
	 #has_many :vendors
	 has_many :supplies , :dependent => :destroy
   has_many :inventories , :dependent => :destroy
	 belongs_to :store_operation

   validates_presence_of :close_time, :open_time , :store_roles
   validates_uniqueness_of :name


  default_scope{order(name: :asc)}

	validates :name, presence: true, uniqueness: true, length: {in:2..20}
	validates :store_type, presence: true
	validates :store_operation, presence: true


	before_save :modify_attr
	before_validation :name_unique

  #permissible roles within this array
  serialize :store_roles

  attr_accessor :active_store

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

  def self.get_user_roles
    roles = Role.all.pluck(:name).uniq.compact
    role_count_hash,role_store_hash = {},{}
    roles.each do |role|
      role_count_hash[role] = 0
      role_store_hash[role] = []
    end
    Store.all.each do |store|
      store_roles = store.roles.pluck(:name)
      store_roles.each do |store_role|
        role_count_hash[store_role] += 1
        role_store_hash[store_role] << store.name
      end
    end
    [role_count_hash,role_store_hash]
  end

end
