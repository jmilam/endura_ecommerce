# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $('#date').datepicker
    dateFormat: 'yy-mm-dd'
  $('#deadline').datepicker
    dateFormat: 'yy-mm-dd'
  $("#image_request_company_name, #catalog_request_company_name").on 'change', ->
    ajaxRequest $(this).val()

  ajaxRequest = (company_name) ->
  	console.log 'make request'
  	$.ajax
    url: '/customer/1'
    type: 'GET'
    dataType: 'json'
    data: company_name: company_name
    success: (response) ->
      response = JSON.stringify response.customer
      response = JSON.parse response
      console.log response
      $('.company_contact').val response.company_contact
      $('.email').val response.contact_email
      $('.phone_number').val response.phone_number
      $('.ship_address').val response.address
      $('.city').val response.city
      $('.state').val response.state
      $('.zipcode').val response.zipcode
      return
  return