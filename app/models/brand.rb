class Brand < ActiveRecord::Base

  belongs_to :pharm_item
  belongs_to :marketer
  belongs_to :unit_dose
  belongs_to :item_concentration_unit
  has_many :batches , :dependent => :destroy
  has_many :inventories , :dependent => :destroy

  validates_presence_of :item_concentration_unit, :concentration, :unit_dose, :min_dispensable, :marketer, :min_dispensable, :pack_size

  before_create :modify_attrs
  validate :check_strength_unit
  after_create :initialise_inventory

  def check_strength_unit
    if item_concentration_unit and (item_concentration_unit.name.split('/').count > 1 or item_concentration_unit.name.split('+').count > 1)
       if item_concentration_unit.name.split('/').count > 1
         errors.add(:concentration , "Strength Unit and strength format do not match") if  item_concentration_unit.name.split('/').count != concentration.try(:split , '/').try(:count)
       else
         errors.add(:concentration , "Strength Unit and strength format do not match") if  item_concentration_unit.name.split('+').count != concentration.try(:split , '+').try(:count)
       end
    end
  end

  def initialise_inventory
    Store.all.each do |s|
      Inventory.create(:brand_id => self.id, :store_id => s.id, :pharm_item_id => self.pharm_item.id)
    end
  end


  def detailed_info
    "#{name} " + "(" + " #{pharm_item.try(:name)}" + " | " + " #{strength_display(try(:concentration) , item_concentration_unit.try(:name)) } "  + " #{unit_dose.try(:name)}" + " | " + " #{marketer.try(:name)} " + " )"
  end

  #used in prescription page
  def drug_prescription_info
    "#{pharm_item.try(:name)} " + "(" + " #{name}" + " | " + " #{strength_display(try(:concentration) , item_concentration_unit.try(:name)) } " + " #{unit_dose.try(:name)}" + " | " + " #{marketer.try(:name)} " + " )"
  end

  def mini_info
    "#{name} " + "(" + " #{ strength_display(try(:concentration), item_concentration_unit.try(:name))} #{unit_dose.try(:name)}" + " | " + " #{marketer.try(:name)} " + " )"
  end

  def modify_attrs
    self.name = name.try(:titleize)
  end

  private

  #mg/ml => 50mg/50ml  or mg+mg => 50mg+50mg
  def strength_display(val, name)

    if !name.blank?
      result = []
      tokens = []
      values = []
      c = ""
      if (name.include? "/") or (name.include? "+")
        if (name.include? "/")

          tokens = name.split('/')
          values = val.split("/")
          c = "/"
        else
          tokens = name.split('+')
          values = val.split("+")
          c = "+"
        end
        values.each_with_index do |val, index|
          result << "#{val}#{tokens[index]}"
        end

        return result.join(c)
      else
        return "#{val}#{name}"
      end
    end
  end


end
