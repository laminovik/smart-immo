# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rental.create([{
city_id: 1,
district_id: 1,
price: 27000,
type_id: 1,
rooms: 3,
bathrooms: 2,
surface: 240,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-racine-314046.html",
last_update: "19/07/2016"
},
{
city_id: 1,
district_id: 2,
price: 6000,
type_id: 1,
rooms: 2,
bathrooms: 1,
surface: 120,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-centre-ville-316124.html",
last_update: "06/07/2016"
},
{
city_id: 1,
district_id: 3,
price: 6500,
type_id: 1,
rooms: 3,
bathrooms: 2,
surface: 115,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-2-mars-316125.html",
last_update: "13/07/2016"
},
{
city_id: 1,
district_id: 4,
price: 16500,
type_id: 1,
rooms: 2,
bathrooms: 2,
surface: 140,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-triangle-d-or-313954.html",
last_update: "19/07/2016"
},
{
city_id: 1,
district_id: 5,
price: 22000,
type_id: 1,
rooms: 3,
bathrooms: 2,
surface: 212,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-les-princesses-313530.html",
last_update: "17/05/2016"
},
{
city_id: 1,
district_id: 6,
price: 16000,
type_id: 1,
rooms: 3,
bathrooms: 3,
surface: 160,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-bouskoura-316727.html",
last_update: "22/07/2016"
},
{
city_id: 1,
district_id: 7,
price: 50000,
type_id: 2,
rooms: 6,
bathrooms: 5,
surface: 1200,
website: "https://sarouty.ma",
link: "/villa-a-louer-casablanca-californie-290097.html",
last_update: "17/05/2016"
},
{
city_id: 1,
district_id: 8,
price: 27000,
type_id: 2,
rooms: 4,
bathrooms: 3,
surface: 480,
website: "https://sarouty.ma",
link: "/villa-a-louer-casablanca-ain-diab-289341.html",
last_update: "10/05/2016"
},
{
city_id: 1,
district_id: 3,
price: 9500,
type_id: 1,
rooms: 3,
bathrooms: 3,
surface: 118,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-2-mars-259643.html",
last_update: "08/07/2016"
},
{
city_id: 1,
district_id: 10,
price: 12000,
type_id: 1,
rooms: 3,
bathrooms: 1,
surface: 150,
website: "https://sarouty.ma",
link: "/appartement-a-louer-casablanca-gauthier-313639.html",
last_update: "03/06/2016"
}])

puts "created "+Rental.count.to_s+ " rentals in the database"