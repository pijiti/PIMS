class Marketer < ActiveRecord::Base

  has_many :brands

  default_scope { order(name: :asc) }

  validates :name, presence: true, uniqueness: true , length: {in: 2..255}
  validates_presence_of :contact_name , :contact_email , :contact_mobile
  validates :description, presence: false
  validates :foreign, inclusion: {in: [true, false]}

  before_save :modify_attr
  before_validation :name_unique

  def modify_attr
    self.name = name.capitalize.strip
    self.description = description.capitalize.strip
  end

  def name_unique
    self.name = name.capitalize.strip
  end

end
