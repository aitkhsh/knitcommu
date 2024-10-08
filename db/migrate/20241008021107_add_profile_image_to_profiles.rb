class AddProfileImageToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :profile_image, :string
  end
end
