class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title, index:true
      t.string :body
      t.string :username, index:true

      t.timestamps null: false
    end
  end
end
