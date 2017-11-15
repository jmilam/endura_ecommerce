$(document).on "turbolinks:load", ->

	$('#product-finish-add, #sub-finish-add').on 'click', () ->
		if $(this).attr('id') == 'product-finish-add'
			$('#product_finishes').append '<option>' + $('#product-finish').val() + '</option>'
			$('#product-finish').val ''
			$('#product-finish').focus()
		else if $(this).attr('id') == 'sub-finish-add'
			$('#sub_finishes').append '<option>' + $('#sub-finish').val() + '</option>'
			$('#sub-finish').val ''
			$('#sub-finish').focus()

	$('#save-sub-product').on 'click', (e) ->
		e.preventDefault()

		$.each $('#product_finishes').children('option'), (key, value) ->
			$(this).attr 'selected', true

		$('#sub_product_form').submit()

	$('#save-sub-finish').on 'click', (e) ->
		e.preventDefault()

		$.each $('#sub_finishes').children('option'), (key, value) ->
			$(this).attr 'selected', true

		$('#sub_finish_form').submit()

