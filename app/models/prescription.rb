class Prescription < ActiveRecord::Base

  #include PgSearch
  #pg_search_scope :search_by_main_attributes, against: [:prescription_code],using: [:tsearch, :dmetaphone, :trigrams],
  #ignoring: :accents

  before_create :unique_code

  belongs_to :user
  belongs_to :hospital_unit
  belongs_to :patient
  belongs_to :doctor, class_name: "User"
  has_many :prescription_batches, :dependent => :destroy

  validates_presence_of :prescription_date, :subtotal, :total, :patient, :doctor
  # validates :hospital_unit, presence: { message: "Clinic is required" }
  validate :hospital_unit_presence
  before_create :unique_code
  before_create :total_calculation
  before_update :total_calculation

  accepts_nested_attributes_for :prescription_batches, allow_destroy: true
  attr_accessor :clinic


  def hospital_unit_presence
    if self.hospital_unit.blank?
      errors.add(:clinic, " can't be blank")
    end
  end

  #PIMS1000
  #PIMS1001
  #PIMS1002
  def unique_code
    counter = Prescription.all.count + 1000
    self.code = "#{PimsConfig.find_by_property_name("prescription_prefix").property_value}-#{counter}"
  end

  #def status
  #  self.prescription_batches.each do |p|
  #    return "WAITING FOR COLLATION" if p.batches.blank?
  #  end
  #  "COLLATION COMPLETED"
  #end

  def total_calculation
    logger.debug "======TOTAL CALCULATION========="
    subtotal = 0
    surcharges = 0

    #begin
    #subtotal
    self.prescription_batches.each do |p|
      subtotal += (p.qty.to_i) * ("%.2f" % p.rate).to_f   if p.rate != "NA"
    end
    logger.debug "======SUBTOTAL CALCULATION=========#{subtotal}"
    #surcharge calculation
    @surcharge = Surcharge.where(:active => true).first
    if @surcharge
      total_surcharge = 0
      @surcharge.surcharge_items.each do |i|
        total_surcharge += i.value.to_f
      end
      if @surcharge.charge_type == "Fixed"
        surcharges = total_surcharge
      else
        surcharges = subtotal * total_surcharge * 0.01
      end
    end
    self.subtotal = "%.2f" % subtotal
    self.surcharges = "%.2f" % surcharges
    self.total = (self.surcharges.to_f + self.subtotal.to_f).ceil
    if self.total%5 != 0
      self.total = self.total + (5 - self.total%5)
    end

    self.total
    #self.save
    #rescue => e
    #  logger.error e.message
    #end
  end

end
