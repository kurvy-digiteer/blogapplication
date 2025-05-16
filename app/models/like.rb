class Like < ApplicationRecord
  belongs_to :post
  belongs_to :liker, polymorphic: true

  validates :post_id, uniqueness: { scope: [ :liker_id, :liker_type ] }
end
