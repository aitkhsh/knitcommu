class Item < ApplicationRecord
  has_many :user_items
  has_many :users, through: :user_items

  # 画像の属性
  validates :image, presence: true
end
