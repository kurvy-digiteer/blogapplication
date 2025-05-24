class Post < ApplicationRecord
  before_validation :generate_permalink
  validates :permalink, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 5, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10, maximum: 1500 }
  validate :user_or_customer_present

  belongs_to :user, optional: true
  belongs_to :customer, optional: true

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  before_save :sanitize_body

  def liked_by?(liker)
    likes.exists?(liker: liker)
  end

  def to_param
    permalink
  end

  scope :with_body_text, ->(query) {
    where("body ILIKE ?", "%#{query}%")
  }

  scope :between_years, ->(start_year, end_year) {
    where(created_at: Date.new(start_year, 1, 1)..Date.new(end_year, 12, 31))
  }

  def self.ransackable_attributes(auth_object = nil)
    [ "id", "title", "body", "created_at", "updated_at", "user_id", "customer_id", "views", "likes_count", "feature", "active", "permalink" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user", "customer", "comments", "likes" ]
  end

  private
  def generate_permalink
    self.permalink = title.to_s.parameterize if title.present?
  end

  def user_or_customer_present
    if user_id.present? && customer_id.present?
      errors.add(:base, "Post must belong to either a user or a customer, not both")
    elsif user_id.blank? && customer_id.blank?
      errors.add(:base, "Post must belong to either a user or a customer")
    end
  end

  def sanitize_body
    return unless body.present?
    self.body = ActionController::Base.helpers.sanitize(body, tags: %w[p br strong em u s blockquote pre code h1 h2 h3 h4 h5 h6 ul ol li a img], attributes: %w[href src alt style])
  end
end
