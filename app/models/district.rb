class District < ActiveRecord::Base
  belongs_to :city
  has_many :sales
  has_many :rentals

  def calculate_yield
  	(1200*rentals.average(:sqm_price).to_f/sales.average(:sqm_price).to_f).round(2)
  end

  def rent_sqm_price
  	rentals.average(:sqm_price).to_i
  end

  def buy_sqm_price
  	sales.average(:sqm_price).to_i
  end

  def self.valid limit
    valid=[]
    self.all.each do |d|
      if d.rentals_count >=limit && d.sales_count >=limit && d.avito_code !="autre_secteur"
        valid << d
      end
    end
    return valid
  end

  def is_valid?
    rentals_count >=10 && sales_count >=10
  end


end
