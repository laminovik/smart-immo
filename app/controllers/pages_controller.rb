class PagesController < ApplicationController
  def main
  	@cities=City.order(:name)
  	@districts=District.valid(100).sort_by(&:yield).reverse[0..4]
  end
end
