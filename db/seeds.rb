# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Add default autorecognition format

adminDan = User.create! :first_name => 'Dan', :last_name => 'Halper', :email => 'danhalper@gmail.com', :password => 'welcome22', :password_confirmation => 'welcome22', :enabled => true, :admin => true
