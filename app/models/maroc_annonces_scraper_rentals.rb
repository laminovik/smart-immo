require 'nokogiri'
require 'open-uri'

class MarocAnnoncesScraperRentals

	def initialize district
	    @website="http://www.marocannonces.com/"
	    @district=district
	    @city = district.city
  end

  attr_accessor :website, :city, :district

  def perform   
    
    #compteur des pages de resultats
  	k=1
    #condition de poursuite vers la page suivante (absence du nombre total d'annonces)
    more_pages=true

    while more_pages

	    #url k des pages de ventes d'appartements par quartier
	    url = "http://www.marocannonces.com/maroc/location-appartements-#{@district.maroc_annonces_name}-b321-t#{@city.maroc_annonces_code}.html?quartier=#{@district.maroc_annonces_code}&pge=#{k}"
    	#ouverture de la page k
	    data=Nokogiri::HTML(open(url))
    	items=data.css('.cars-list > li')
    	#compteur parcours annonces de la page
    	i=1
    	#parcour des annonces de la page
    	items.each do |item|
    		
	      #encodage ascii de l'url (liens avec des accents ou des liens en arabe)
	      item_link=@website+item.css('.block_img > a').attribute('href').value
	      item_url=URI::encode(item_link)

	      if without_price?(item)
	        puts "***************#{@website} -- #{@city.name} --#{@district.name} -- Pas de prix / Saut de l'annonce #{i} de la page #{k}*************"   
	      elsif Rental.exists?(link: item_url)
	        puts "***************#{@website} -- #{@city.name} --#{@district.name}-- Existe déjà / Saut de l'annonce #{i} de la page #{k}*************"        
	      else
	        begin
		        #chargement de l'annonce
		        item_data=Nokogiri::HTML(open(item_url))
		        if has_details?(item_data)
		          item_extract=extract_item_data(item,item_data,item_url)
		          if valid_record?(item_extract)
		            Rental.create item_extract
		            puts "**********#{@website} -- #{@city.name} -- #{@district.name} -- Extraction de l'annonce #{i} de la page #{k} *************"
		            puts "#{@district.name} **** #{item_extract[:rooms]} pièces de #{item_extract[:surface]} m², au prix de #{item_extract[:price]} DH / mois"
		          else
		            puts "****#{@website} -- #{@city.name} --#{@district.name} -- Non enregistré ******* Prix (#{item_extract[:price]} DH) ou Surface (#{item_extract[:surface]}) m² ou Prix du m² (#{item_extract[:sqm_price]}) non valides "
		          end 
		       	else  
		       		puts "*****#{@website} -- #{@city.name} -- #{@district.name} -- Pas assez d'infos / Saut de l'annonce #{i} de la page #{k}*************"                         
		      	end 
			  
			    rescue OpenURI::HTTPError => e
						  if e.message == '404 Not Found'
						    puts "URL non valide"
						  else
						    raise e
						  end
					end
	      end

	  		i+=1
	  	end


	  	#bloc pour vérifier si la page courante k est la dernière
	  	pages=data.css('ul.paging').css('li')
	  	displayed=pages.count
	  	if items.count <=19 
	  		more_pages=false
	  	elsif pages[displayed-2].children.children.text == k.to_s
	  		
	  	end
	  	k+=1
	  	#sleep(2)
  	end
	end

  def without_price? item
  	item.css(".price").text=="" or item.css('.block_img > a').attribute('href').value[0..4]=="index"
	end

	def has_details? item_data
		item_data.css('.extraQuestionName > li').count >=1		
	end


	def valid_record? extract  
    moyenne=District.find_by_id(extract[:district_id]).sqm_rent
    if moyenne.nil?
      extract[:surface] >=10 && extract[:price]<=70000 && extract[:price]>=500 
    else
      extract[:surface] >=10 && (extract[:sqm_price] >= moyenne/3) && (extract[:sqm_price] <= 3*moyenne)
    end
  end

  def extract_item_data(item,item_data, item_url)
    price=get_price(item)
    surface=get_surface(item_data)
    {
      city_id: @city.id, 
      district_id: @district.id,
      website: @website,
      link: item_url,
      surface: surface, 
      rooms: get_rooms(item_data),
      price: price,
      sqm_price: surface==0 ? nil : price/surface,
      type_id: 1,
      detail: get_detail(item_data),
      last_update: get_last_update(item_data) 
    } 
  end

  def get_price item
	  price_el=item.css(".price").text.scan(/\d+/).join.to_i  
  end

	def get_rooms item_data
		vector=item_data.css('.extraQuestionName > li')
	  	if vector[0].text[0..-3]=="Nombre de Chambres :"
	    	rooms=vector[0].text
	 	elsif vector.count >=2 && vector[1].text[0..-3]=="Nombre de Chambres :"
	 		rooms=vector[1].text
	 	elsif vector.count >=3 
	 		rooms=vector[2].text
	 	end
	   	rooms.nil? ? 0 : rooms[-1].to_i+1 	
	end

  def get_surface item_data
  	vector=item_data.css('.extraQuestionName > li')
  	if vector[0].text[0..6]=="Surface"
    	surface=item_data.css('.extraQuestionName > li')[0].text
 	elsif vector.count >=2 && vector[1].text[0..6]=="Surface"
 		surface=item_data.css('.extraQuestionName > li')[1].text
 	elsif vector.count >=3 
 		surface=item_data.css('.extraQuestionName > li')[2].text
 	end
    surface.nil? ? 0 : surface[16..-1].to_i
  end
   

  def get_detail item_data
  	item_data.css('.block')[1].text.strip
  end

  def get_last_update item_data
    item_data.css('.info-holder > li')[1].text[12..-1]
  end

end
