class Task < ApplicationRecord
  enum status: { not_started_yet: 0, start: 1, completion: 2}
  enum priority: { low: 0, middle: 1, high: 2}

  acts_as_taggable

  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  
  belongs_to :user
  
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at deadline status priority]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  private
  
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
  