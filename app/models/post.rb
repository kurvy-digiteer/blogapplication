class Post < ApplicationRecord
    validates :title, presence: true, uniqueness: true, length: { minimum: 5, maximum: 255 }
    validates :body, presence: true, length: { minimum: 10, maximum: 1500 }
    belongs_to :user

    has_many :comments, dependent: :destroy

    has_rich_text :body
    # For ransack search
    has_one :content, class_name: "ActionText::RichText", as: :record, dependent: :destroy

  # Custom scope to search ActionText body, tutorial I was following has older version of ransack
  scope :with_body_text, ->(query) {
    joins(:rich_text_body).where("action_text_rich_texts.body LIKE ?", "%#{query}%")
  }

    def self.ransackable_attributes(auth_object = nil)
        [ "title", "body", "created_at", "updated_at", "user_id", "views" ]
    end

    def self.ransackable_associations(auth_object = nil)
        [ "user", "comments" ]
    end
end
