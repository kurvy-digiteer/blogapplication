json.extract! post, :id, :title, :body, :created_at, :updated_at, :feature, :active
json.url admin_post_url(post, format: :json)
