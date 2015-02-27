class PharmItemSubClass < ActiveRecord::Base
  belongs_to :pharm_item
  belongs_to :sub_class
end
