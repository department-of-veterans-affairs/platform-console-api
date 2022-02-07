# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.where(name: 'John Doe', email: 'user@example.com').first_or_create password: 'password', uid: SecureRandom.uuid
User.where(name: 'Jane Doe', email: 'jane@example.com').first_or_create(
  password: 'password', uid: SecureRandom.uuid, admin: true
)
