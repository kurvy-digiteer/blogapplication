class Post < ApplicationRecord
    validates :title, presence: true, uniqueness: true, length: { minimum: 5, maximum: 255 }
    validates :body, presence: true, length: { minimum: 10, maximum: 1500 }
    belongs_to :user

    has_many :comments, dependent: :destroy

    has_rich_text :body


    def self.ransackable_attributes(auth_object = nil)
        [ "title", "body", "created_at", "updated_at", "user_id", "views" ]
    end

    def self.ransackable_associations(auth_object = nil)
        [ "user", "comments" ]
    end
end
