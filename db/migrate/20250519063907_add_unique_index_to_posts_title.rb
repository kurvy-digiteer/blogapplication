class AddUniqueIndexToPostsTitle < ActiveRecord::Migration[8.0]
  def change
    add_index :posts, 'LOWER(title)', unique: true, name: 'index_posts_on_lower_title'
  end
end
