require 'test_helper'

class RentalsControllerTest < ActionController::TestCase
  setup do
    @rental = rentals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rentals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rental" do
    assert_difference('Rental.count') do
      post :create, rental: { bathrooms: @rental.bathrooms, city_id: @rental.city_id, district_id: @rental.district_id, last_update: @rental.last_update, link: @rental.link, price: @rental.price, rooms: @rental.rooms, sqm_price: @rental.sqm_price, surface: @rental.surface, type_id: @rental.type_id, website: @rental.website }
    end

    assert_redirected_to rental_path(assigns(:rental))
  end

  test "should show rental" do
    get :show, id: @rental
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rental
    assert_response :success
  end

  test "should update rental" do
    patch :update, id: @rental, rental: { bathrooms: @rental.bathrooms, city_id: @rental.city_id, district_id: @rental.district_id, last_update: @rental.last_update, link: @rental.link, price: @rental.price, rooms: @rental.rooms, sqm_price: @rental.sqm_price, surface: @rental.surface, type_id: @rental.type_id, website: @rental.website }
    assert_redirected_to rental_path(assigns(:rental))
  end

  test "should destroy rental" do
    assert_difference('Rental.count', -1) do
      delete :destroy, id: @rental
    end

    assert_redirected_to rentals_path
  end
end
