class Supply < ActiveRecord::Base

  #include Supply::WorkflowConcern

  belongs_to :vendor
  belongs_to :user, foreign_key: "signed_off_by"
  has_many :batches, dependent: :destroy
  belongs_to :store

  before_create :set_approval_status, :workflow_initial_state

  validates :vendor, presence: true
  validates :invoice_value, presence: true
  validates :invoice_reference, presence: true
  validates :invoice_date, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :batches, allow_destroy: true, reject_if: :all_blank

  scope :submitted, -> { where(workflow_state: "submitted") }

  #before_create :set_date
  #before_update :set_date
  #
  #def set_date
  #  logger.debug "=======>before save#{self.invoice_date}"
  #  self.invoice_date = Date.strptime(self.invoice_date, '%m/%d/%Y')
  #  logger.debug "=======>after save#{self.invoice_date}"
  #end

  def set_approval_status
    self.approval_status = "NOT SENT"
  end

  def submit
    update! approval_status: "AWAITING",
            approval_sent: Time.now
    save!
  end

  def assign_pharmitem_id
    batches.collect { |batch| [batch.giver_store = 0, batch.prescription_id = 0,
                               batch.pharm_item_id = batch.try(:brand).try(:pharm_item).try(:id)] }
  end

  def assign_recipient_store
    batches.collect { |batch| [batch.recipient_store = self.store_id.to_i] }
  end

  def amount_check?
    invoice_value == batches.try(:collect) { |batch| batch.qty.to_f * batch.rate.to_f }.sum
  end

  def workflow_initial_state
    self.workflow_state = "created"
  end

  def assign_retail_price
    batches.collect { |batch| batch.update(:retail_price => batch.retail_price) }
  end

  def assign_dispensable_qty
    batches.collect { |batch| batch.update(:dispensable_qty => batch.dispensable_qty) }
  end

  def approval_attr(user)
    update :approved => Time.now,
           :approved_by => user
  end

  def save_and_approve(user)
    assign_retail_price
    assign_dispensable_qty
    approval_attr(user)
  end

  def disapprove
    self.disapprove_count ||= 0
    update! :disapprove_count => self.disapprove_count += 1,
            :last_disapproved => Time.now
  end
end
