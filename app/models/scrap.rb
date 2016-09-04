class Scrap < ActiveRecord::Base
  belongs_to :city

	def self.fetch_sales
	  	City.all.each do |city|
			puts "starting #{city.name} scrap"
			sc=AvitoScraperSales.new city
			start=Time.now
			cmp=Sale.count
			sc.perform
			cmp=Sale.count-cmp
			puts "Sales **** finished #{city.name} scrap - #{cmp} scraped"
			var=1.0*cmp/city.sales.count
			self.create website: "https://avito.ma", category: "Ventes", city_id: city.id,
						 started: start, ended: Time.now, total_scraped: cmp , variation: var

			puts "**Sales** updating #{city.name} and its districts fields"
			city.update sales_count: city.sales.count, buy_sqm: city.buy_sqm_price, yield: city.calculate_yield
			city.districts.each do |district|
				district.update sales_count: district.sales.count, sqm_buy: district.buy_sqm_price, yield: district.calculate_yield
			end
		end
	end

	def self.fetch_rentals
	  	City.all.each do |city|
			puts "starting #{city.name} scrap"
			sc=AvitoScraperRentals.new city
			start=Time.now
			cmp=Rental.count
			sc.perform
			cmp=Rental.count-cmp
			puts "Rentals **** finished #{city.name} scrap - #{cmp} scraped"
			var=1.0*cmp/city.rentals.count
			self.create website: "https://avito.ma", category: "Locations", city_id: city.id,
						 started: start, ended: Time.now, total_scraped: cmp , variation: var

			puts "**Rentals** updating #{city.name} and its districts fields"
			city.update rentals_count: city.rentals.count, rent_sqm: city.rent_sqm_price, yield: city.calculate_yield
			city.districts.each do |district|
				district.update rentals_count: district.rentals.count, sqm_rent: district.rent_sqm_price, yield: district.calculate_yield
			end
		end
	end

	def self.bring_sales
		storage=[]

		initial=City.first.sales.count
		District.where("city_id = ? AND maroc_annonces_code >= ? AND id >=?",1,1,59).each do |district|
			puts "starting #{district.name} scrap"
			sc=MarocAnnoncesScraperSales.new district
			start=Time.now
			cmp=Sale.count
			sc.perform
			cmp=Sale.count-cmp
			puts "Sales **** finished #{district.name} scrap - #{cmp} scraped"
			var=1.0*cmp/district.sales.count
			storage << "#{district.name} -- #{cmp} annonces -- variation :#{var}"
	
			district.update sales_count: district.sales.count, sqm_buy: district.buy_sqm_price, yield: district.calculate_yield
			puts "**Sales** updating #{district.name} "
		end
		var=(City.first.sales.count-initial)/initial
		self.create website: "http://www.marocannonces.com/", category: "Ventes", city_id: 1,
						 started: start, ended: Time.now, total_scraped: cmp , variation: var

		City.first.update sales_count: city.sales.count, buy_sqm: city.buy_sqm_price, yield: city.calculate_yield
		storage
	end
	
end
