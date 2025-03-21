class Board < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
  belongs_to :user

  # CarrierWave の設定
  mount_uploader :board_image, BoardImageUploader
  mount_uploader :ogp, OgpUploader

  has_many :comments, dependent: :destroy
  has_many :boardtags, dependent: :destroy
  has_many :tags, through: :boardtags

  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  scope :title_contain, ->(word) { where("boards.title LIKE ?", "%#{word}%") }
  scope :body_contain, ->(word) { where("boards.body LIKE ?", "%#{word}%") }
  scope :name_contain, ->(word) { joins(:user).where("users.name LIKE ?", "%#{word}%") }
  scope :tag_contain, ->(word) { joins(:tags).where("tags.name LIKE ?", "%#{word}%") }
  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month) }

  def image_path
    if self.board_image.present?
      Rails.env.production? ? self.board_image.url : self.board_image.path
    else
      nil
    end
  end

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
    tags.map(&:name).join("、")
  end

  # ユーザーの月投稿数をカウント
  def self.this_month_boards_count(user)
    this_month.where(user: user).count
  end
end
