class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

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
    [ "created_at", "email", "id", "name", "remember_created_at", "updated_at", "views" ]
  end

  # Ransackable associations for search, allows what can be explicitly searched for, taken from the
  # ransackable gems documentation
  def self.ransackable_associations(auth_object = nil)
    [ "posts", "comments" ]
  end
end
