class Tag < ApplicationRecord
  has_many :profiletags, dependent: :destroy
  has_many :profiles, through: :profiletags

  validates :name, presence: true, uniqueness: true
  
  scope :popular, -> { where(id: Profiletag.group(:tag_id).order('count_tag_id desc').limit(20).count(:tag_id).keys) }
end
