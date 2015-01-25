class RequestItem < ActiveRecord::Base
  belongs_to :pharm_item
  belongs_to :request
  has_many :batches

  accepts_nested_attributes_for :batches
end
