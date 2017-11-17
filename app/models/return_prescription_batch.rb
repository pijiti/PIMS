class ReturnPrescriptionBatch < ActiveRecord::Base
  belongs_to :pharm_item
  belongs_to :brand
  belongs_to :prescription
  belongs_to :return
end
