class InventoryBatch < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :batch
end
