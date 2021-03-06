class InventoryBatch < ActiveRecord::Base
  belongs_to :inventory
  belongs_to :batch
  has_many :collation_batches , :dependent => :destroy
  has_many :alerts , :dependent => :destroy


  attr_accessor :allot , :store_id , :pharm_item_id , :batch_number

  after_update :generate_expiry_notification

  def generate_expiry_notification
    if self.expired_changed? and expired == true
      store = self.inventory.try(:store)
      User.with_any_role({:name => "Admin"},{:name => "Store Manager", :resource => store}, {:name => "Store Keeper", :resource => store}).each do |u|
        if u.alerts.where(:inventory_batch=> self).blank?
          self.alerts << Alert.create(:store => store , :user => u, :status => "UNREAD" , :alert_type => "EXPIRY" ,:message => "The batch #{self.batch.batch_number} of the drug #{self.batch.brand.name} has expired")
        end
      end
    end
  end

  #run this every day
  def self.expiry_date_check
    puts "Running expiry check===================="
    InventoryBatch.where(:expired => nil).each do |i|
      if i.batch.expiry_date < Time.now
        i.update(:expired => true)
      end
    end

    #enqueue next job
    self.delay(:run_at => Time.now + 1.day).expiry_date_check
  end

  #allotment from service requests page and transfer batches page
  def allotment(store_id , sq_id = nil)
    response = nil
    if !allot.blank? and allot.to_i <= self.units

      i = Inventory.where(:store => store_id , :brand_id => batch.brand_id).first
      if i
        #reduce from request_store
        self.update(:units => self.units.to_i - allot.to_i)

        #receiving store will get the drugs post confirmation of receipt

        if sq_id.blank?
          #allotment from transfer batches
          order = Order.create(:status => "SERVICE_COMPLETE" , :number => "#{PimsConfig.find_by_property_name('transfer_batches_prefix').property_value}-#{Sequence.last.number}")
        else
          #allotment from service requests page
          order = ServiceRequest.find_by_id(sq_id).order
        end
        Receipt.create(:inventory => i ,
                       :from_store_id => self.inventory.store_id ,
                       :qty => allot ,
                       :batch_id => self.batch_id ,
                       :to_store_id => store_id ,
                       :service_request_id => sq_id,
                       :order_id => order.id
        )

        store = Store.find_by_id(store_id)
        response = "Successfully allocated the drugs to #{store.try(:name)}"
      else
        response = "Inventory not found for the store"
      end

    #else
      #response = "Unable to allocate drugs. Please check if sufficient stock is available to service the request"
    end

    response
  end




end
