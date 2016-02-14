# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do |i|
  user = User.create!(login: "user#{i+1}", email: "user#{i+1}@example.com", 
       password: "password#{i+1}", hide_acc: i.odd? ? true : false, 
       first_name: FFaker::Name.first_name, last_name: FFaker::Name.last_name)
  # user.save
  user.bg_packs.create({name: "pack1", device_type: "ipad"})
  user.bg_packs.create({name: "pack1", device_type: "ipad2"})
  user.bg_packs.create({name: "pack2", device_type: "ipad2"})
end