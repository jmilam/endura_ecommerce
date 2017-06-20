# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
	$('.report_link').on 'click', ->
	  ajaxReportRequest $('#date').val() , $('#end_date').val(), $(this).attr 'id'

	ajaxReportRequest = (start_date, end_date, report_type) ->
  	$.ajax
      url: '/report/1'
      type: 'GET'
      dataType: 'script'
      data: report: {start_date: start_date, end_date: end_date}, commit: report_type
      success: (response) ->
        return
      error: (response) ->

        console.log response.responseText