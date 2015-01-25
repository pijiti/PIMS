class Request < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  has_many :request_items

  before_create :generate_code

  accepts_nested_attributes_for :request_items

  def generate_code
  	self.request_code = SecureRandom.hex(4)
  end

end
