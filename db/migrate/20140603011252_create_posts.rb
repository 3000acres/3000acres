class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :subject
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
