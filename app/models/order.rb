class Order < ActiveRecord::Base
  has_many :service_requests , :dependent => :destroy
end
