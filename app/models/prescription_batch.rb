class PrescriptionBatch < ActiveRecord::Base
  belongs_to :prescription
  belongs_to :pharm_item
  belongs_to :brand
end
