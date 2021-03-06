require 'nokogiri'
require 'open-uri'
class AvitoScraperRentals

  def initialize city
    @website="https://avito.ma"
    @city = city
  end

  attr_accessor :website, :city

  def perform ratio  
    #url main_page des locations d'appartements par ville
    url = "https://www.avito.ma/fr/#{URI::encode(@city.name.downcase)}/appartements-%C3%A0_louer"
    #url de navigation dans les pages de résultats des locations
    nav_url="https://www.avito.ma/fr/#{URI::encode(@city.name.downcase)}/appartements-%C3%A0_louer?o=" 
    data=Nokogiri::HTML(open(url))
    #nombre de pages de résultats à parcourir
    total_pages=count_pages(data)
    #boucle de parcours des pages de résultats
    for k in 2..(total_pages/ratio)
      items=data.css('h2.fs14')
      i=1
      #parcours des 35 résultats de la page num k
      items.each do |item|
        #encodage ascii de l'url (liens avec des accents ou des liens en arabe)
        item_url=URI::encode(item.first_element_child[:href])

        if without_price?(data,i)
          puts "***************@ #{@city.name} -- Pas de prix / Saut de l'annonce #{i} de la page #{k-1}/#{total_pages}*************"   
        elsif Rental.exists?(link: item_url)
          puts "*************** Existe déjà / Saut de l'annonce #{i} de la page #{k-1}/#{total_pages}*************"        
        else
          #chargement de l'annonce
          item_data=Nokogiri::HTML(open(item_url))
          item_extract=extract_item_data(item_data,item_url)
          if valid_record?(item_extract)
            Rental.create item_extract
            puts "*************** @ #{@city.name} -- Extraction de l'annonce #{i} de la page #{k-1}/#{total_pages} *************"
            puts "#{item_extract[:rooms]} pièces de #{item_extract[:surface]} m², au prix de #{item_extract[:price]} DH / mois"
          else
            puts "**** Non enregistré ******* Prix (#{item_extract[:price]} DH) ou Surface (#{item_extract[:surface]}) m² ou Prix du m² (#{item_extract[:sqm_price]}) non valides "
          end                            
        end        
        i+=1
      end
      sleep(2)
      data=Nokogiri::HTML(open(nav_url+k.to_s))
    end
  end

  def count_pages data
    total_items=data.at_css('small').text.to_i
    items=data.css('h2.fs14')
    items_per_page=items.count
    total_pages=total_items/items_per_page
  end

  def without_price?(data,index)
    data.css(".price_value")[index-1].nil? or data.css(".price_value")[index-1].children.text.to_i==0
  end

    def extract_item_data(item_data, item_url)
     price=get_price(item_data)
     surface=get_surface(item_data)
     {
      city_id: @city.id, 
      district_id: get_district_id(item_data),
      website: @website,
      link: item_url,
      surface: surface, 
      rooms: get_rooms(item_data),
      price: price,
      sqm_price: surface==0 ? nil : price/surface,
      type_id: get_type(item_data),
      detail: get_detail(item_data),
      last_update: get_last_update(item_data) 
      } 
  end

  def valid_record? extract
    if District.find_by_id(extract[:district_id]).nil?
      extract[:surface] >=10 && extract[:price]<=70000
    else
      moyenne=District.find_by_id(extract[:district_id]).sqm_rent
      if moyenne.nil?
        extract[:surface] >=10 && extract[:price]<=70000
      else
      extract[:surface] >=10 && extract[:price]<=70000 && (extract[:sqm_price] >= moyenne/3) && (extract[:sqm_price] <= 3*moyenne)
      end
    end
  end

  def get_price item_data
    price_el=item_data.at_css(".amount")  
    #normalement il ne devrait pas en avoir besoin mais suite à plantages mystérieux
    price_el.nil? ? 0 : price_el.text.scan(/\d+/).join.to_i

  end

  def get_rooms item_data
    rooms=item_data.at_css("aside").css("h2")
    rooms=rooms[18..rooms.length-1].to_i
  end

  def get_surface item_data
    surface=item_data.at_css("aside").css("h2")[1].text
    surface=surface[9..surface.length-4].to_i
  end

  
  def get_type item_data
    item_data.at_css("aside").css("h2")[4].text=="Type: Appartements, Offre de location" ? 1 : nil
  end

  def get_detail item_data
    item_data.at_css('p').text.strip
  end

  #dernière mise à jour de l'annonce sur avito
  def get_last_update item_data
    vector=item_data.css('abbr')
    update=vector[vector.length-1].values[1]
  end

  
  def get_district_id item_data
    district=item_data.at_css("aside").css("h2")[2].text
    district=district[9..district.length-1]
    district=District.where("city_id= ? AND avito_code=?",@city.id,district).first
    district.nil? ? nil : district.id
  end            

end