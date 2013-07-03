# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
<<<<<<< HEAD
print "Adding Admin user...\n"
admin = User.new do |u|
  u.name = "Admin"
  u.admin = true
  u.email = "admin@example.com"
  u.password = "password"
  u.password_confirmation = "password"
end

admin.save!
=======
>>>>>>> 616ac7b0183417780c535a52353333211d63cdb3
