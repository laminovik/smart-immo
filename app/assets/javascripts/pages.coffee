# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

	


jQuery ->
	districts = $('#city_district_id').html()
	$('#city_id').change ->
		city = $('#city_id :selected').text()
		options = $(districts).filter("optgroup[label='#{city}']").html()
		
		if options
			$('#city_district_id').html(options)
			$('#city_district_id').prepend($("<option value='nil'>Quartier</option>"))
			$('#city_district_id').val('nil')
			
		else	
			$('#city_district_id').html(districts)	

