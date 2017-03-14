$(document).on "turbolinks:load", ->
  $('.update_response').css 'height', '20px'

  $('#date').datepicker
    dateFormat: 'yy-mm-dd'
  $('#deadline').datepicker
    dateFormat: 'yy-mm-dd'
  $("#image_request_company_name, #catalog_request_company_name, #_order_company_name").on 'change', ->
    ajaxCompanyRequest $(this).val(), '/customer/1', 'GET'

  ajaxCompanyRequest = (company_name, url, request_type) ->
  	$.ajax
      url: url
      type: request_type
      dataType: 'json'
      data: company_name: company_name
      success: (response) ->
        response = JSON.stringify response.customer
        response = JSON.parse response
        $('.company_contact').val response.company_contact
        $('.email').val response.contact_email
        $('.phone_number').val response.phone_number
        $('.ship_address').val response.address
        $('.city').val response.city
        $('.state').val response.state
        $('.zipcode').val response.zipcode
        return
  return