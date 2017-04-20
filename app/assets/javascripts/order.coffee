$(document).on "turbolinks:load", ->
  
  current_date = new Date()
  current_date.setDate(current_date.getDate() + 14)
  min_date = new Date(current_date.getFullYear(), current_date.getMonth(), current_date.getDate())

  $('.update_response').css 'height', '20px'

  $('#date').datepicker
    dateFormat: 'yy-mm-dd'
  
  $('#deadline').datepicker
    dateFormat: 'yy-mm-dd'
    minDate: min_date
  
  $('.right').tooltip
    placehment: 'right'

  $("#image_request_company_name, #catalog_request_company_name, #order_customer_id").on 'change', ->
    ajaxCompanyRequest $(this).find('option:selected').text(), '/customer/1', 'GET'

  $('.order_item_delete').on 'click', (e) ->
    e.preventDefault()  
    e.stopPropagation()
    
    ajaxOrderItemDelete $(this), 'DELETE'

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

  ajaxOrderItemDelete = (link_object, request_type) ->
    url = link_object.attr 'href'
    $.ajaxSetup headers: 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    $.ajax
      url: url
      type: request_type
      dataType: 'json'
      success: (response) ->
        total_row = link_object.parents('tr').siblings().last()
        delete_count = parseInt(link_object.parent().siblings('td:eq(1)').text())
        console.log link_object.parent().siblings('td:eq(2)').text().match(/[^$]+/)
        delete_cost = parseFloat(link_object.parent().siblings('td:eq(2)').text().match(/[^$]+/)[0])
        total_count = parseInt(total_row.children('td:eq(1)').text())
        total_cost = parseFloat(total_row.children('td:eq(2)').text().match(/[^$]+/)[0])
        total_row.children('td:eq(1)').text(total_count - delete_count)
        total_row.children('td:eq(2)').text("$" + (total_cost - delete_cost).toFixed(2))
        $('#cart_count').text(parseInt($('#cart_count').text()) - delete_count)
        link_object.parents('tr').remove()
        return
      error: (jqXHR, textStatus) ->
        alert textStatus
        return

  return