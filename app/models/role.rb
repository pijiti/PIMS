class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  NAMES = ["Pharmacist" , "Pharmacy Technician"  , "Store Keeper" , "Store Manager" , "Auditor" ]

  def self.store_roles
    res = {}
    NAMES.each do |r|
       res[r] = Role.find_by_name(r).id
    end
    res
  end
end
