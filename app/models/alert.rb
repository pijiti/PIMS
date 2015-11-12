class Alert < ActiveRecord::Base
  belongs_to :store
  belongs_to :user
  belongs_to :inventory_batch

end
