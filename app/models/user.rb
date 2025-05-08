class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # enum role: { user: 0, admin: 1 }




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
