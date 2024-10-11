class CreateProfiletags < ActiveRecord::Migration[7.2]
  def change
    create_table :profiletags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
    add_index :profiletags, [:tag_id, :profile_id], unique: true
  end
end
