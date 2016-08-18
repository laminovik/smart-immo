class City < ActiveRecord::Base
	has_many :districts
	has_many :rentals
	has_many :sales

	#private

	def valid_districts limit
		valid=[]
		districts.each do |d|
			if d.rentals.count >=limit && d.sales.count >=limit
				valid << d
			end
		end
		return valid
	end

	def yield
		(1200*rentals.average(:sqm_price).to_f/sales.average(:sqm_price).to_f).round(2)
	end
end
