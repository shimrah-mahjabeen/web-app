class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :location
      t.string :phone_number
      t.references :user, null: false, foreign_key: true
      t.string :github_username
      t.string :skills, array: true, default: []

      t.timestamps
    end
  end
end
