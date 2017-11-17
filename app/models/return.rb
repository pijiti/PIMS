class Return < ActiveRecord::Base
  belongs_to :prescription
  has_many :return_prescription_batches , :dependent => :destroy
end
