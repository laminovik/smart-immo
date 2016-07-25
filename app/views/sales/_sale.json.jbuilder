json.extract! sale, :id, :city_id, :district_id, :type_id, :price, :surface, :rooms, :bathrooms, :website, :link, :last_update, :created_at, :updated_at
json.url sale_url(sale, format: :json)