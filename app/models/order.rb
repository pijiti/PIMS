class Order < ActiveRecord::Base
  #status => ORDER_INCOMPLETE , ORDER_COMPLETE , SERVICE_COMPLETE , DELIVERY_COMPLETE

  belongs_to :from_store , :class_name => "Store"
  belongs_to :ordered_by , :class_name => "User"
  has_many :service_requests , :dependent => :destroy
  validates_uniqueness_of :number
  validates_presence_of :from_store_id

  before_create :set_configs

  has_many :receipts , :dependent => :destroy
  accepts_nested_attributes_for :receipts, allow_destroy: true


  def set_configs
    self.organization_name = PimsConfig.find_by_property_name("organization_name").property_value
    self.organization_email = PimsConfig.find_by_property_name("organization_email").property_value
    self.organization_address = PimsConfig.find_by_property_name("organization_address").property_value
    self.organization_contact_person = PimsConfig.find_by_property_name("organization_contact_person").property_value
    self.organization_registration_number = PimsConfig.find_by_property_name("organization_registration_number").property_value
  end
end
