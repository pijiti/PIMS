class ReturnCollationBatch < ActiveRecord::Base
  belongs_to :return_prescription_batch
  belongs_to :collation_batch
  belongs_to :inventory_batch
end
