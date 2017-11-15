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
    $('#product_config, #sub_product, #product_finish, #sub_finish').attr 'hidden', false

  $('.update_response').css 'height', '20px'

  $('.add_user').on 'click', ->
    $('.user_group').append '<div class="form-group"><div class="form-inline"><input placeholder="Name" class="form-control" type="text" name="tradeshow_request[attendee_name][]" id="tradeshow_request_attendee_name[]"> <input placeholder="Email" class="form-control" type="text" name="tradeshow_request[attendee_email][]" id="tradeshow_request_attendee_email[]"></div></div>' 

  $('#date').datepicker
    dateFormat: 'yy-mm-dd'
  $('.date').datepicker
    dateFormat: 'yy-mm-dd'
  $('#deadline').datepicker
    dateFormat: 'yy-mm-dd'
    minDate: min_date
  $('#end_date').datepicker
    dateFormat: 'yy-mm-dd'

  $("#image_request_company_name, #catalog_request_company_name, #order_company_name").on 'change', ->
    ajaxCompanyRequest $(this).val(), '/customer/1', 'GET'

  $('.add_to_cart').on 'click', ->
    ajaxSubProductRequest($(this), '/product/get_product_sub_values', $(this).parents('.product_container').attr('product_id'), $('#sub_product'), 'sub_products')

  $('#save_config').on 'click', ->
    $.ajax
      url: '/product_configuration'
      dataType: 'json'
      type: 'post'
      data: product_config: product_id: $('#product_config_product_id').val(), item_qty: $('#product_config_item_qty').val(), item_note: $('#product_config_item_note').val(), sub_product: $('#sub_product').val(), finish: $('#product_finish').val(), sub_finish: $('#sub_finish').val()
      success: (response) ->
        $('#configModal').modal 'hide'
        response = JSON.stringify response
        response = JSON.parse response
        if response.success
          sum = parseInt $('#cart_count').text()
          $('#cart_count').text sum + 1
          #object.parents('.thumbnail').children('.update_response').text('Successfully added')

  $('.item_qty_input').on 'keyup', ->
    if $(this).val() == ''

    else
      item_cost = parseFloat $(this).parent().parent().siblings('.item_cost').text().match(/[^$]+/)[0]
      qty = parseInt $(this).val()
      if item_cost * qty == 0
        $(this).parent().parent().siblings('.total_cost').text("$0.00")
      else
        $(this).parent().parent().siblings('.total_cost').text("$" + (item_cost * qty).toFixed(2))

  $('.registration_assistance, .credit_issued, .additional_notes').on 'click', ->
    if $(this).val() == "true"
      $(this).parents('.row:eq(0)').next().removeClass('hide')
    else
      $(this).parents('.row:eq(0)').next().addClass('hide')

  $('#sub_product, #product_finish').on 'change', ->
    if $(this).attr('id') == 'sub_product'
      ajaxSubProductRequest($(this), '/product/get_product_sub_values', $(this).val(), $('#product_finish'), 'product_finish')
    else if $(this).attr('id') == 'product_finish'
      ajaxSubProductRequest($(this), '/product/get_product_sub_values', $(this).val(), $('#sub_finish'), 'sub_finish')
    else
      console.log $(this).attr 'id'

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

  ajaxSubProductRequest = (working_div, url, id, working_select, model_value) ->
    $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    $.ajax
      url: url
      type: 'GET'
      dataType: 'json'
      data: id: id, model_value: model_value
      success: (response) ->
        if response.has_sub_values && model_value == 'sub_products'
          $('#product_config_product_id').val(id)
          $('#product_config_item_qty').val(working_div.parent().parent().parent().children('.thumbnail').children('.item_qty').children().children('.item_qty_input').val())
          $('#product_config_item_note').val(working_div.parent().parent().parent().children('.thumbnail').children('.notes').children().eq(1).val())

          working_select.children('option:gt(0)').remove()
          $('#product_finish').children('option:gt(0)').remove()
          $('#sub_finish').children('option:gt(0)').remove()

          $.each response.sub_values, (key, value) ->
            working_select.append '<option value=' + value.sub_product_id + '>' + key + '</option>'

          $('#configModal').modal 'show'
        else if response.has_sub_values && model_value == 'product_finish'
          working_select.children('option:gt(0)').remove()
          $('#sub_finish').children('option:gt(0)').remove()

          $.each response.sub_values, (key, value) ->
            $('#product_finish').append '<option value=' + value.id + '>' + value.name + '</option>'
        else if response.has_sub_values && model_value == 'sub_finish'
          working_select.children('option:gt(0)').remove()
          $('#sub_finish').children('option:gt(0)').remove()

          $.each response.sub_values, (key, value) ->
            $('#sub_finish').append '<option value=' + value.id + '>' + value.name + '</option>'
        else if response.has_product_finish
          working_select.children().remove()

          $.each value.product_finishes, (key, value) ->
            $('#product_finish').append '<option value=' + value.prod_finish_id + '>' + value.name + '</option>'
        else
          qty = working_div.parent().parent().parent().children('.thumbnail').children('.item_qty').children().children('.item_qty_input').val()

          item_desc = working_div.parent().parent().parent().children('.thumbnail').children('.product_name_container').text()
          item_note = working_div.parent().parent().parent().children('.thumbnail').children('.notes').children().eq(1).val()

          ajaxCartRequest working_div.val(), '/order_item', 'POST', item_desc, qty, working_div, item_note, window.location.search.match(/[^=]+/g)[1]

        #return

  return