class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.text :body, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
