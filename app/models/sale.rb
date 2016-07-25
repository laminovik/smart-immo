class Sale < ActiveRecord::Base
  belongs_to :city
  belongs_to :district
  belongs_to :type
end
