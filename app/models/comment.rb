class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true
  belongs_to :customer, optional: true
  has_rich_text :body
  has_one_attached :image

  validates :body, presence: true

  validate :user_or_customer_present

  before_save :sanitize_body

  def post_title
    post.title
  end

  # using & returns nil instead of raising an error, and if not nil then it returns the name
  def author_name
    user&.name || customer&.name
  end

  ransacker :author_name do
    Arel.sql("CASE
              WHEN users.id IS NOT NULL THEN users.name
              WHEN customers.id IS NOT NULL THEN customers.name
              ELSE NULL
              END")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id body created_at updated_at post_id user_id customer_id author_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[post user customer]
  end

  private

  def user_or_customer_present
    if user_id.present? && customer_id.present?
      errors.add(:base, "Comment must belong to either a user or a customer, not both")
    elsif user_id.blank? && customer_id.blank?
      errors.add(:base, "Comment must belong to either a user or a customer")
    end
  end

  def sanitize_body
    return unless body.present?
    # Sanitize HTML content from QuillJS
    self.body = ActionController::Base.helpers.sanitize(body, tags: %w[p br strong em u s blockquote pre code h1 h2 h3 h4 h5 h6 ul ol li a img], attributes: %w[href src alt style])
  end
end
