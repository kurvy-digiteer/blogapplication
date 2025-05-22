class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, as: :liker, dependent: :destroy

    # Constants for roles because enum breaks the website for some reason, I have no idea why.
    ROLE_USER = 0
    ROLE_ADMIN = 1

  # Helper methods
  def admin?
    role == ROLE_ADMIN
  end

  def user?
    role == ROLE_USER
  end

  def role_name
    case role
    when ROLE_ADMIN then "admin"
    when ROLE_USER then "user"
    else "unknown"
    end
  end

  # Ransackable attributes for search, allows what can be explicitly searched for
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email role created_at updated_at]
  end

  # Ransackable associations for search, allows what can be explicitly searched for, taken from the
  # ransackable gems documentation
  def self.ransackable_associations(auth_object = nil)
    %w[posts comments]
  end
end
