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
			$('#city_district_id').prepend($("<option value='nil'>Quartier à #{city}</option>"))
			$('#city_district_id').val('nil')
			
		else	
			$('#city_district_id').html(districts)

	$('form').on 'submit', (e) ->	
		city = $('#city_id :selected').text()
		district = $('#city_district_id :selected').val()
		surface = $('#surface').val()

		if city == 'Ville'
			e.preventDefault()
			$("div.city_alert").show("slow").delay(4000).hide("slow")
			return false
		else if district == 'nil'
			e.preventDefault()
			$("div.district_alert").show("slow").delay(4000).hide("slow")
			return false
		else if surface.length < 2
			e.preventDefault()
			$("div.surface_alert").show("slow").delay(4000).hide("slow")
			return false
		else
			return true
			

      	
	

