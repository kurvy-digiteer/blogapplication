class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true
  belongs_to :customer, optional: true
  has_rich_text :body
  has_one_attached :image

  validate :user_or_customer_present

  private

  def user_or_customer_present
    if user_id.present? && customer_id.present?
      errors.add(:base, "Comment must belong to either a user or a customer, not both")
    elsif user_id.blank? && customer_id.blank?
      errors.add(:base, "Comment must belong to either a user or a customer")
    end
  end
end
