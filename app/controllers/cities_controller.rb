class CitiesController < ApplicationController
  def index
  	@cities=City.includes(:sales, :rentals).sort_by(&:name)
  end

  def show
  	@city=City.find(params[:id])
  	@districts=@city.valid_districts(40).sort_by(&:name)
  end
  
end
