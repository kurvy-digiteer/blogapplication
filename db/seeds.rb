# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# User.create(email: "admin@example.com",
#    name: "Admin",
#    password: "password",
#    password_confirmation: "password",
#    role: "admin")

# Create admin users
User.create(email: "kurvy@example.com",
    name: "Kurvy Morales",
    password: "password",
    password_confirmation: "password",
    role: User::ROLE_ADMIN)

User.create(email: "testcase@example.com",
    name: "John Doe",
    password: "password",
    password_confirmation: "password",
    role: User::ROLE_ADMIN)

# Create a customer
Customer.create(email: "dante@example.com",
    name: "Dante MC",
    password: "password",
    password_confirmation: "password")

# Create 5 posts by the customer
5.times do |x|
    Post.create(title: "Customer Post #{x + 1}",
        body: "This is post #{x + 1} by a customer. The quick brown fox jumps over the lazy dog",
        customer_id: Customer.first.id,
        active: true,
        feature: false)
end

# Create 4 featured posts by admin users
dates = [
    DateTime.new(2025, 1, 15, 10, 0, 0), # January 15, 2025
    DateTime.new(2025, 2, 20, 12, 0, 0), # February 20, 2025
    DateTime.new(2025, 3, 10, 14, 0, 0), # March 10, 2025
    DateTime.new(2025, 4, 5, 16, 0, 0)   # April 5, 2025
]

dates.each_with_index do |date, i|
    Post.create(
        title: "Featured Post #{i + 1}",
        body: "This is a featured post from #{date.strftime('%B %Y')}.",
        user_id: User.first.id,
        created_at: date,
        updated_at: date,
        active: true,
        feature: true
    )
end
