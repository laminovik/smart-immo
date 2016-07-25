class Rental < ActiveRecord::Base
  belongs_to :city
  belongs_to :district
  belongs_to :type

  scope :recent, ->{where('Date.parse(last_update)>?',7.days.ago)}
end
