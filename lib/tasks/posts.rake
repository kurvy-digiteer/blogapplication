namespace :posts do
  desc "Update existing posts with permalinks"
  task update_permalinks: :environment do
    Post.find_each do |post|
      if post.permalink.blank?
        post.permalink = post.title.to_s.parameterize
        if post.save
          puts "Updated post #{post.id} (#{post.title}) with permalink: #{post.permalink}"
        else
          puts "Failed to update post #{post.id} (#{post.title}): #{post.errors.full_messages.join(', ')}"
        end
      end
    end
  end
end
