# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def add_postion
  Position.create(name: "no position", layer: 0, min_pv: 0)
  Position.create(name: "silver", layer: 5, min_pv: 250)
  Position.create(name: "gold", layer: 10, min_pv: 1250)
  Position.create(name: "diamon", layer: 15, min_pv: 2500)
end

# add_postion
