require 'nokogiri'
require 'open-uri'
class AvitoScraperSales

  def initialize city
    @website="https://avito.ma"
    @city = city
    @date=Date.today
  end

  attr_accessor :website, :date, :city

  def perform
    fetch_results
  end

 

  def fetch_results
    #url main_page des ventes d'appartements à Casablanca, Rabat, Marrakech, Tanger, Agadir, Mohammedia, Kénitra, k%C3%A9nitra
    url = "https://www.avito.ma/fr/#{URI::encode(@city.name.downcase)}/appartements-%C3%A0_vendre"
    #url de navigation dans les pages de résultats des ventes
    nav_url="https://www.avito.ma/fr/#{URI::encode(@city.name.downcase)}/appartements-%C3%A0_vendre?o="  
    #chargement de la page principale de résultats
    data=Nokogiri::HTML(open(url))
    #nombre de pages de résultats à parcourir
    total_pages=count_pages(data)
    #boucle de parcours des pages de résultats
    for k in 2..(total_pages/7)
      #data=Nokogiri::HTML(open(nav_url+k.to_s))
      items=data.css('h2.fs14')
      i=1
      #parcours des 35 résultats de la page num k
      items.each do |item|

        #encodage ascii de l'url (liens avec des accents ou des liens en arabe)
        item_url=URI::encode(item.first_element_child[:href])

        if without_price?(data,i)
          puts "*************** Pas de prix / Saut de l'annonce #{i} de la page #{k-1}/#{total_pages}*************"  
        elsif Sale.exists?(link: item_url)
          puts "*************** Existe déjà / Saut de l'annonce #{i} de la page #{k-1}/#{total_pages}*************" 
        else
          #chargement de l'annonce
          item_data=Nokogiri::HTML(open(item_url))
          item_extract=extract_item_data(item_data,item_url)
          if valid_record?(item_extract)
            Sale.create item_extract
            puts "*************** Extraction de l'annonce #{i} de la page #{k-1}/#{total_pages} *************"
            puts "#{item_extract[:rooms]} pièces de #{item_extract[:surface]} m², au prix de #{item_extract[:price]} DH"
          else
            puts "**** Non enregistré ******* Prix (#{item_extract[:price]} DH) ou Surface (#{item_extract[:surface]} m²) ou Prix du m² (#{item_extract[:sqm_price]}) non valides "
          end                                   
        end
        i+=1 
      end
      sleep(2)
      data=Nokogiri::HTML(open(nav_url+k.to_s))
    end
  end

  #calcul du nombre de pages de résultats
  def count_pages data
    total_items=data.at_css('small').text.to_i
    items=data.css('h2.fs14')
    items_per_page=items.count
    total_pages=total_items/items_per_page
  end

  #
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

  #Pour exclure les annonces avec prix ou surface bcp trop faibles
  def valid_record? extract
    moyenne=District.find_by_id(extract[:district_id]).sqm_buy
    extract[:surface] >=10 && extract[:price]>=50000 && (extract[:sqm_price] >= moyenne/3) && (extract[:sqm_price] <= 3*moyenne)
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
    item_data.at_css("aside").css("h2")[4].text=="Type: Appartements, Offre" ? 1 : nil
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