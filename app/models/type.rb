class Type < ActiveRecord::Base
	has_many :sales
	has_many :rentals
end
