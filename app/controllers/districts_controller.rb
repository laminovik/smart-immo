class DistrictsController < ApplicationController
  def index
  	@districts=District.valid(100).sort_by(&:yield).reverse
  end

  def show
  	@city=City.find_by_name(params[:city])
  	@district=District.find_by_id(params[:district])
  	@surface=params[:surface]
  	@type=params[:type]
  	@sqm_price_buy = District.find_by_id(params[:district]).sqm_buy 
  	@price= @sqm_price_buy*@surface.to_i
    @sqm_price_rent = District.find_by_id(params[:district]).sqm_rent
    @rent= @sqm_price_rent*@surface.to_i

  end
end
