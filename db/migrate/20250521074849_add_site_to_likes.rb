class AddSiteToLikes < ActiveRecord::Migration[8.0]
  def up
    # 1. Add site_id as nullable
    add_reference :likes, :site, null: true

    # 2. Use the default site (created earlier or fallback)
    site = Site.first || Site.create!(name: 'Default Site', slug: 'default-site')

    # 3. Backfill all likes with the default site
    Like.reset_column_information
    Like.where(site_id: nil).update_all(site_id: site.id)

    # 4. Set NOT NULL and add foreign key
    change_column_null :likes, :site_id, false
    add_foreign_key :likes, :sites
  end

  def down
    remove_foreign_key :likes, :sites
    remove_reference :likes, :site
  end
end
