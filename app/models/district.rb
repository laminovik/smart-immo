class District < ActiveRecord::Base
  belongs_to :city
  has_many :sales
  has_many :rentals
end
