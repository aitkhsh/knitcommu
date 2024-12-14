class Tag < ApplicationRecord
  has_many :boardtags, dependent: :destroy
  has_many :boards, through: :boardtags

  validates :name, presence: true, uniqueness: true

  scope :popular, -> { where(id: Boardtag.group(:tag_id).order("count_tag_id desc").limit(20).count(:tag_id).keys) }
end
