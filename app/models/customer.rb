class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, as: :liker, dependent: :destroy

  # Ransackable attributes for search, allows what can be explicitly searched for
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email created_at updated_at]
  end

  # Ransackable associations for search, allows what can be explicitly searched for, taken from the
  # ransackable gems documentation
  def self.ransackable_associations(auth_object = nil)
    %w[posts comments]
  end
end
