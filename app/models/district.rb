class District < ActiveRecord::Base
  belongs_to :city
  has_many :sales
  has_many :rentals

  def self.map_avito
  	# à compléter
  end
end
