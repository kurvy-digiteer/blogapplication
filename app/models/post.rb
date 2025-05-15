class Post < ApplicationRecord
    validates :title, presence: true, uniqueness: true, length: { minimum: 5, maximum: 255 }
    validates :body, presence: true, length: { minimum: 10, maximum: 1500 }
    validate :user_or_customer_present

    belongs_to :user, optional: true
    belongs_to :customer, optional: true

    has_many :comments, dependent: :destroy

    has_rich_text :body
    # For ransack search
    has_one :content, class_name: "ActionText::RichText", as: :record, dependent: :destroy

  # Custom scope to search ActionText body, tutorial I was following has older version of ransack
  scope :with_body_text, ->(query) {
    joins(:rich_text_body).where("action_text_rich_texts.body ILIKE ?", "%#{query}%")
  }

    def self.ransackable_attributes(auth_object = nil)
        [ "title", "body", "created_at", "updated_at", "user_id", "customer_id", "views" ]
    end

    def self.ransackable_associations(auth_object = nil)
        [ "user", "customer", "comments" ]
    end

    private

    def user_or_customer_present
      if user_id.present? && customer_id.present?
        errors.add(:base, "Post must belong to either a user or a customer, not both")
      elsif user_id.blank? && customer_id.blank?
        errors.add(:base, "Post must belong to either a user or a customer")
      end
    end
end
