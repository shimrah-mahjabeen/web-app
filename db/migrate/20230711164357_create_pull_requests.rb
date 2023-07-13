class CreatePullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :pull_requests do |t|
      t.string :username
      t.string :repo
      t.string :title
      t.string :head
      t.string :base
      t.text :body

      t.timestamps
    end
  end
end
