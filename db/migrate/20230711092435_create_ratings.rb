class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table "ratings", force: :cascade do |t|
      t.bigint "user_id", null: false
      t.bigint "profile_id", null: false
      t.integer "score", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id", "profile_id"], name: "index_ratings_on_user_id_and_profile_id", unique: true
    end
  end
end
