class AddSiteToComments < ActiveRecord::Migration[8.0]
  def up
    # 1. Add site_id as nullable
    add_reference :comments, :site, null: true

    # 2. Use the default site (created earlier or fallback)
    site = Site.first || Site.create!(name: 'Default Site', slug: 'default-site')

    # 3. Backfill all comments with the default site
    Comment.reset_column_information
    Comment.where(site_id: nil).update_all(site_id: site.id)

    # 4. Set NOT NULL and add foreign key
    change_column_null :comments, :site_id, false
    add_foreign_key :comments, :sites
  end

  def down
    remove_foreign_key :comments, :sites
    remove_reference :comments, :site
  end
end
