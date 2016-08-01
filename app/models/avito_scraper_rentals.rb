require 'nokogiri'
require 'open-uri'
class AvitoScraperRentals

  def initialize city
    @website="http://avito.ma"
    @city = city
    @date=Date.today
  end

  attr_accessor :website, :date, :city

  def perform
    fetch_results
  end

 

  def fetch_results
    
    #url main_page des locations d'appartements à Casablanca, Rabat, Marrakech, Tanger, Agadir, Mohammedia, k%C3%A9nitra, Fès
    url = "http://www.avito.ma/fr/f%C3%A8s/appartements-%C3%A0_louer"

     #url de navigation dans les pages de résultats des locations
    nav_url="http://www.avito.ma/fr/f%C3%A8s/appartements-%C3%A0_louer?o="
    

    data=Nokogiri::HTML(open(url))

    #nombre de pages de résultats à parcourir
    total_items=data.at_css('small').text.to_i
    items=data.css('h2.fs14')
    items_per_page=items.count
    total_pages=total_items/items_per_page

    #boucle de parcours des pages de résultats
    for k in 2..total_pages
      #just in case of restart after error
      #data=Nokogiri::HTML(open(nav_url+k.to_s))
      i=1
      #parcours des 35 résultats de la page num k
      items.each do |item|
        #encodage ascii de l'url (liens avec des accents ou des liens en arabe)
        item_url=URI::encode(item.first_element_child[:href])
        #chargement de l'annonce
        item=Nokogiri::HTML(open(item_url))
        #récupération du prix si existant
        price_el=item.at_css(".amount")

        #si prix absent on passe à l'annonce suivante
        if  !price_el.nil?
          price=price_el.text.scan(/\d+/).join.to_i


          info=item.at_css("aside").css("h2")
          #Extraction nombre de pièces
          rooms=info[0].text
          rooms=rooms[18..rooms.length-1].to_i
          #Extraction de la surface
          surface=info[1].text
          surface=surface[9..surface.length-4].to_i
          district=info[2].text
          district=district[9..district.length-1]
          if info[4].text=="Type: Appartements, Offre de location"
            type=1
          end
          #détail texte de l'annonce
          detail=item.at_css('p').text.strip
          #date de publication
          vector=item.css('abbr')
          update=vector[vector.length-1].values[1]


          #ActiveRecord::Base.transaction do
            Rental.create(city_id: @city.id, surface: surface, rooms: rooms, price: price,
             link: item_url, type_id: type, website: @website, temp: district, detail: detail, last_update: update)
          #end
         


          puts "*************** Extraction de l'annonce #{i} de la page #{k-1}/#{total_pages} *************"
          puts "#{rooms} pièces de #{surface} m² à "+district.to_s+ " au prix de #{price} DH par mois"
        else
           puts "*************** Saut de l'annonce #{i} de la page #{k} *************"
          
        end
        i+=1
        #sleep(3)
        end

    data=Nokogiri::HTML(open(nav_url+k.to_s))
  end


end
end