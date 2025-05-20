class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :post, null: false, foreign_key: true
      t.references :liker, polymorphic: true, null: false

      t.timestamps
    end

    add_index :likes, [ :post_id, :liker_id, :liker_type ], unique: true
  end
end
