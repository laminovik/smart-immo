class DistrictsController < ApplicationController
  def index
  	@districts=District.valid(100).sort_by(&:yield).reverse
  end

  def show
  	@city=City.find_by_name(params[:city])
  	@district=District.find_by_id(params[:district])
    if @district.is_valid?
    	@surface=params[:surface]
    	@type=params[:type]
    	@sqm_price_buy = District.find_by_id(params[:district]).sqm_buy 
    	@price= @sqm_price_buy*@surface.to_i
      @sqm_price_rent = District.find_by_id(params[:district]).sqm_rent
      @rent= @sqm_price_rent*@surface.to_i
      @stats_sales = @district.sales.pluck(:sqm_price).extend(DescriptiveStatistics).descriptive_statistics
      @stats_rentals = @district.rentals.pluck(:sqm_price).extend(DescriptiveStatistics).descriptive_statistics
    end

  end
end
