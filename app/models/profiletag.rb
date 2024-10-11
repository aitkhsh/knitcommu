class Profiletag < ApplicationRecord
  belongs_to :tag
  belongs_to :profile

  validates :tag_id, uniqueness: { scope: :profile_id }
end