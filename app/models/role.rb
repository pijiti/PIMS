class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  NAMES = ["Pharmacist" , "Pharmacy Technician"  , "Store Keeper" , "Store Manager" , "Auditor" ]

  def self.store_roles
    NAMES
  end

end
