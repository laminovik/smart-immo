


City.where("id >=?",2).each do |city|
	puts "starting #{city.name} scrap"
	sc=AvitoScraperRentals.new city
	start=Time.now
	cmp=Rental.count
	sc.perform
	cmp=Rental.count-cmp
	ville=" *** #{city.name}  - #{cmp} annonces ***"
	puts "finished #{city.name} scrap - #{cmp} scraped"
	var=1.0*cmp/city.rentals.count
	Scrap.create website: "https://avito.ma", category: "Locations", city_id: city.id,
				 started: start, ended: Time.now, total_scraped: cmp , variation: var
end


