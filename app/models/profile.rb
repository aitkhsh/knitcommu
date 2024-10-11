class Profile < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  belongs_to :user
  mount_uploader :profile_image, ProfileImageUploader
  has_many :comments, dependent: :destroy

  has_many :profiletags, dependent: :destroy
  has_many :tags, through: :profiletags

  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  scope :name_contain, ->(word) { where('name LIKE ?', "%#{word}%") }
  scope :body_contain, ->(word) { where('profiles.body LIKE ?', "%#{word}%") }
  scope :username_contain, ->(word) { joins(user: :profile).where('profiles.name LIKE ?', "%#{word}%") }
  scope :tag_contain, ->(word) { joins(:tags).where('tags.name LIKE ?', "%#{word}%")}


  def save_with_tags(tag_names:)
    ActiveRecord::Base.transaction do
      self.tags = tag_names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
      save!
    end
    true
  rescue StandardError
    false
  end

  def tag_names
    # NOTE: pluckだと新規作成失敗時に値が残らない(返り値がnilになる)
    tags.map(&:name).join(',')
  end
end
