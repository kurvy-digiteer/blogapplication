class RemoveActionTextAndAddBodyToPostsAndComments < ActiveRecord::Migration[7.0]
  def change
    # Add body columns if they do not exist
    add_column :posts, :body, :text unless column_exists?(:posts, :body)
    add_column :comments, :body, :text unless column_exists?(:comments, :body)

    # Drop ActionText table if it exists
    if table_exists?(:action_text_rich_texts)
      drop_table :action_text_rich_texts
    end
  end
end
