class CitiesController < ApplicationController
  def index
  	@cities=City.includes(:sales, :rentals)
  end

  def show
  	@city=City.find(params[:id])
  	@districts=@city.valid_districts(40)
  end
  
end
