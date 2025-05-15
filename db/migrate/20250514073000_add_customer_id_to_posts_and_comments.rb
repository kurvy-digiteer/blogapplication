class AddCustomerIdToPostsAndComments < ActiveRecord::Migration[8.0]
  def change
    # Add customer_id to posts
    add_column :posts, :customer_id, :integer
    add_index :posts, :customer_id
    add_foreign_key :posts, :customers

    # Add customer_id to comments
    add_column :comments, :customer_id, :integer
    add_index :comments, :customer_id
    add_foreign_key :comments, :customers

    # Make user_id nullable in both tables
    change_column_null :posts, :user_id, true
    change_column_null :comments, :user_id, true

    # Add a check constraint to ensure only one of user_id or customer_id is present
    execute <<-SQL
      ALTER TABLE posts
      ADD CONSTRAINT check_user_or_customer_present
      CHECK (
        (user_id IS NOT NULL AND customer_id IS NULL) OR
        (user_id IS NULL AND customer_id IS NOT NULL)
      );

      ALTER TABLE comments
      ADD CONSTRAINT check_user_or_customer_present_comments
      CHECK (
        (user_id IS NOT NULL AND customer_id IS NULL) OR
        (user_id IS NULL AND customer_id IS NOT NULL)
      );
    SQL
  end
end
