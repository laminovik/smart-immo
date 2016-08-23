


City.where("id >= ?",5).each do |city|
	puts "starting #{city.name} scrap"
	sc=AvitoScraperSales.new city
	start=Time.now
	cmp=Sale.count
	sc.perform
	cmp=Sale.count-cmp
	ville=" *** #{city.name}  - #{cmp} annonces ***"
	puts "finished #{city.name} scrap - #{cmp} scraped"
	var=1.0*cmp/city.sales.count
	Scrap.create website: "https://avito.ma", category: "Ventes", city_id: city.id,
				 started: start, ended: Time.now, total_scraped: cmp , variation: var
end


