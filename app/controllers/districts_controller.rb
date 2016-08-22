class DistrictsController < ApplicationController
  def index
  	@districts=District.valid(100).sort_by(&:yield).reverse
  end

  def show
  	@city=City.find_by_name(params[:city])
  	@district=District.find_by_id(params[:district])
  	@surface=params[:surface]
  	@type=params[:type]
  	@sqm_price = @type=='1' ? District.find_by_id(params[:district]).buy_sqm_price : District.find_by_id(params[:district]).rent_sqm_price 
  	@price= @sqm_price*@surface.to_i
  end
end
