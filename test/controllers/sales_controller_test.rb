require 'test_helper'

class SalesControllerTest < ActionController::TestCase
  setup do
    @sale = sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, sale: { bathrooms: @sale.bathrooms, city_id: @sale.city_id, district_id: @sale.district_id, last_update: @sale.last_update, link: @sale.link, price: @sale.price, rooms: @sale.rooms, surface: @sale.surface, type_id: @sale.type_id, website: @sale.website }
    end

    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should show sale" do
    get :show, id: @sale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale
    assert_response :success
  end

  test "should update sale" do
    patch :update, id: @sale, sale: { bathrooms: @sale.bathrooms, city_id: @sale.city_id, district_id: @sale.district_id, last_update: @sale.last_update, link: @sale.link, price: @sale.price, rooms: @sale.rooms, surface: @sale.surface, type_id: @sale.type_id, website: @sale.website }
    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, id: @sale
    end

    assert_redirected_to sales_path
  end
end
