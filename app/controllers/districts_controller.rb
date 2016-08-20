class DistrictsController < ApplicationController
  def index
  	@districts=District.valid(100).sort_by(&:yield).reverse
  end

  def show
  end
end
