class Site < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :users
  has_many :customers
  has_many :likes
end
