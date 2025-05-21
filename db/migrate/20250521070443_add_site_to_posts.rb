class AddSiteToPosts < ActiveRecord::Migration[8.0]
  def up
    # 1. Add site_id as nullable
    add_reference :posts, :site, null: true

    # 2. Create a default site if none exists
    site = Site.first || Site.create!(name: 'Default Site', slug: 'default-site')

    # 3. Backfill all posts with the default site
    Post.reset_column_information
    Post.where(site_id: nil).update_all(site_id: site.id)

    # 4. Set NOT NULL and add foreign key
    change_column_null :posts, :site_id, false
    add_foreign_key :posts, :sites
  end

  def down
    remove_foreign_key :posts, :sites
    remove_reference :posts, :site
  end
end
