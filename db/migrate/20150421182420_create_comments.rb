class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.text :text
      t.integer :response_to_id
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :comments, :users
  end
end
