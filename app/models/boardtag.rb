class Boardtag < ApplicationRecord
  belongs_to :tag
  belongs_to :board

  validates :tag_id, uniqueness: { scope: :board_id }
end
