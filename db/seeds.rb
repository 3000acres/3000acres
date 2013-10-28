# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

def load_data
  # for all 3000 Acres sites, including production ones
  load_roles

  # for development environments only
  if Rails.env.development?
    load_test_users
    load_admin_users
  end
end

def load_roles
  puts "Creating admin role..."
  @admin = Role.create(:name => 'Admin')
  puts "Done."
end

def load_test_users
  puts "Loading test users..."
  (1..3).each do |i|
    @user = User.create(
        :name => "test#{i}",
        :email => "test#{i}@example.com",
        :password => "password#{i}",
    )
    @user.confirm!
    @user.save!
  end
  puts "Finished loading test users."
end

def load_admin_users
  puts "Adding admin users..."
  @admin_user = User.create(
    :name => "admin1",
    :email => "admin1@example.com",
    :password => "password1",
  )
  @admin_user.confirm!
  @admin_user.add_role :admin
  @admin_user.save!

  puts "Done!"
end

load_data
