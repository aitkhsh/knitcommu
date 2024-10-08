class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 70 }

  belongs_to :user
  belongs_to :profile
end
