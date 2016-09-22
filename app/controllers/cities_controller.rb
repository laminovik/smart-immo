class CitiesController < ApplicationController
  def index
  	@cities=City.includes(:sales, :rentals).sort_by(&:name)
  end

  def show
  	@city=City.find(params[:id])
  	@filter=params[:sort]
  	if @filter == "sqm_buy"
  		@districts=@city.valid_districts(40).sort_by(&:sqm_buy).reverse
  	elsif @filter == "sqm_rent"
  		@districts=@city.valid_districts(40).sort_by(&:sqm_rent).reverse
  	elsif @filter == "yield"
  		@districts=@city.valid_districts(40).sort_by(&:yield).reverse
  	else
  		@districts=@city.valid_districts(40).sort_by(&:name)
  	end
  end
  
end
