class PagesController < ApplicationController
  def main
  	@cities=City.order(:name)
  end
end
