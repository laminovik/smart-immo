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

	def self.bring_sales(min=nil,max=nil,ratio=nil)
		min ||= 0
		max ||= 1000
		ratio ||= 1
		storage=[]
		start=Time.now

		initial=City.first.sales.count
		District.where("city_id >= ? AND maroc_annonces_code >= ?",2,1).each do |district|
			
			if district.id<=max && district.id>=min
				puts "starting #{district.name} scrap"
				sc=MarocAnnoncesScraperSales.new district
				
				cmp=Sale.count
				sc.perform
				cmp=Sale.count-cmp
				puts "Sales **** finished #{district.name} scrap - #{cmp} scraped"
				var=1.0*cmp/district.sales.count
				storage << "#{district.name} -- #{cmp} annonces -- variation :#{var}"
		
				district.update sales_count: district.sales.count, sqm_buy: district.buy_sqm_price, yield: district.calculate_yield
				puts "**Sales** updating #{district.name} "
			end
		end
		cmp=City.first.sales.count-initial
		var=cmp/initial
		self.create website: "http://www.marocannonces.com/", category: "Ventes", city_id: 1,
						 started: start, ended: Time.now, total_scraped: cmp , variation: var

		City.first.update sales_count: City.first.sales.count, buy_sqm: City.first.buy_sqm_price, yield: City.first.calculate_yield
		storage
	end

	def self.bring_rentals(min=nil,max=nil, ratio=nil)
		min ||= 0
		max ||= 1000
		ratio ||= 1
		storage=[]
		start=Time.now

		initial=City.first.rentals.count
		District.where("city_id >= ? AND maroc_annonces_code >= ?",2,1).each do |district|
			
			if district.id<=max && district.id>=min
				puts "starting #{district.name} scrap"
				sc=MarocAnnoncesScraperRentals.new district
				
				cmp=Rental.count
				sc.perform
				cmp=Rental.count-cmp
				puts "Rentals **** finished #{district.name} scrap - #{cmp} scraped"
				var=1.0*cmp/district.rentals.count
				storage << "#{district.name} -- #{cmp} annonces -- variation :#{var}"
		
				district.update rentals_count: district.rentals.count, sqm_rent: district.rent_sqm_price, yield: district.calculate_yield
				puts "**Rentals** updating #{district.name} "
			end
		end
		cmp=City.first.rentals.count-initial
		var=cmp/initial
		self.create website: "http://www.marocannonces.com/", category: "Locations", city_id: 1,
						 started: start, ended: Time.now, total_scraped: cmp , variation: var

		City.first.update rentals_count: City.first.rentals.count, rent_sqm: City.first.rent_sqm_price, yield: City.first.calculate_yield
		storage
	end
	
end
