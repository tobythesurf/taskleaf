class Task < ApplicationRecord
  enum status: { not_started_yet: 0, start: 1, completion: 2}

  def self.human_attribute_enum_value(attr_name, value)
    human_attribute_name("#{attr_name}.#{value}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_value(attr_name, self[attr_name])
  end  

  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  
  belongs_to :user
  
  scope :recent, -> { order(created_at: :desc) }
  
  private
  
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
  