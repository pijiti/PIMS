class ReturnPrescriptionBatch < ActiveRecord::Base
  belongs_to :pharm_item
  belongs_to :brand
  belongs_to :prescription
  belongs_to :prescription_batch
  belongs_to :return
  has_many :return_collation_batches
  accepts_nested_attributes_for :return_collation_batches
end
