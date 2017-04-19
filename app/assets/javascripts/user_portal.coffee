# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  current_date = new Date()
  current_date.setDate(current_date.getDate() + 14)
  min_date = new Date(current_date.getFullYear(), current_date.getMonth(), current_date.getDate())

  $('#item_product_type, #image_group, #image_sub_group').on 'change', ->
    $('div').attr 'hidden', false
    $('input').not('.' + $(this).val().toLowerCase()).parent().attr 'hidden', true
    $('.item_qty_input').parent().attr 'hidden', false
  $('.update_response').css 'height', '20px'

  $('#date').datepicker
    dateFormat: 'yy-mm-dd'
  $('#deadline').datepicker
    dateFormat: 'yy-mm-dd'
    minDate: min_date
  $("#image_request_company_name, #catalog_request_company_name, #order_company_name").on 'change', ->
    ajaxCompanyRequest $(this).val(), '/customer/1', 'GET'

  $('.add_to_cart').on 'click', ->
    qty = $(this).parent().parent().parent().children('.thumbnail').children('.item_qty').children().children('.item_qty_input').val()

    item_desc = $(this).parent().parent().parent().children('.thumbnail').children('.product_name_container').text()
    item_note = $(this).parent().parent().parent().children('.thumbnail').children('.notes').children().eq(1).val()
    ajaxCartRequest $(this).val(), '/order_item', 'POST', item_desc, qty, $(this), item_note, window.location.search.match(/[^=]+/g)[1]

  $('.item_qty_input').on 'keyup', ->
    if $(this).val() == ''

    else
      item_cost = parseFloat $(this).parent().parent().siblings('.item_cost').text().match(/[^$]+/)[0]
      qty = parseInt $(this).val()
      if item_cost * qty == 0
        $(this).parent().parent().siblings('.total_cost').text("$0.00")
      else
        $(this).parent().parent().siblings('.total_cost').text("$" + (item_cost * qty).toFixed(2))

  $('.registration_assistance, .credit_issued').on 'click', ->
    if $(this).val() == "true"
      $(this).parents('.row:eq(0)').next().removeClass('hide')
    else
      $(this).parents('.row:eq(0)').next().addClass('hide')

  ajaxCartRequest = (company_name, url, request_type, item_desc, qty, object, note, item_type) ->
    $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    $.ajax
      url: url
      type: request_type
      dataType: 'json'
      data: qty: qty, item_desc: item_desc, note: note, item_type: item_type
      success: (response) ->
        response = JSON.stringify response
        response = JSON.parse response
        if response.success
          sum = parseInt $('#cart_count').text()
          $('#cart_count').text sum + 1
          #$('#cart_count').text sum + parseInt qty 
          object.parents('.thumbnail').children('.update_response').text('Successfully added')
        return

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