class CollationBatch < ActiveRecord::Base
  belongs_to :inventory_batch
  belongs_to :prescription_batch

  validates_presence_of :inventory_batch_id,:prescription_batch_id
  #validates_uniqueness_of :inventory_batch_id , :scope => :prescription_batch_id


end
