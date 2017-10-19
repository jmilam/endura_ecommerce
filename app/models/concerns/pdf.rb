class Pdf
	require 'prawn'
	#require 'prawn-table'

	def initialize
		@pdf = Prawn::Document.new
	end

	def tradeshow_requests(requests)
		page_count = requests.count
		left_start = 80
		right_start = 350
		default_width = 250

		requests.each do |request|
			page_count -= 1
			curr_cursor = @pdf.cursor
			draw_header "Tradeshow Request", [right_start, @pdf.cursor ], 180, :right
			@pdf.move_down 20


			draw_text_box "Contact Info:", [0, @pdf.cursor], default_width, :left, 8
			@pdf.move_down 10
			draw_text_box "#{request.first_name} #{request.last_name}", [50, @pdf.cursor] , default_width, :left, 8
			@pdf.move_down 10
			#draw_text_box "#{request.address}\n #{request.city} #{request.state}, #{request.zipcode}\n", [50, @pdf.cursor] , default_width, :left, 8
			@pdf.move_down 10
			draw_text_box "#{request.email}\n #{request.phone_number}", [50, @pdf.cursor], default_width, :left, 8
			@pdf.move_down 35
			@pdf.stroke_horizontal_rule
			@pdf.move_down 20

			@pdf.text "#{request.show_name}", align: :center, size: 14
			@pdf.table [["Start Date", "End Date", "Booth Number", "Booth Dimensions"], ["#{request.start_date}", "#{request.end_date}", "#{request.booth_num}", "#{request.booth_dimensions}"]], width: 540 do
				row(0).style background_color: 'd9534f'
			end

			@pdf.move_down 20
			
			@pdf.table [["Show Size", "#{request.show_size}"], ["Target Market", "#{request.target_market}"], ["Number of Attendees", "#{request.number_of_attendees}"], ["Z Cap Sill", "ADA Sills"], ["#{request.z_cap_sill}","#{request.ada_sills}"], ["ZAI Sills", "Trilennium Multi Point Locking"], ["#{request.zai_sills}","#{request.trilennium_multi_point_locking}"], ["Multi Point Astragal", "Ultimate Astragal"], ["#{request.multi_point_astragal}", "#{request.ultimate_astragal}"], ["Ultimate Flip Lever Astragal", "Framesaver"], ["#{request.ultimate_flip_lever_astragal}", "#{request.framesaver}"], ["Weathersealing", "Registration Assistance"], ["#{request.weathersealing}", "#{request.registration_assistance}"]], width: 540 do
				
				[3,5,7,9,11].each do |num|
					row(num).style background_color: 'd9534f'
				end
			end

			@pdf.start_new_page unless page_count == 0
		end

		@pdf
	end

	def catalog_requests(requests)
		page_count = requests.count
		left_start = 80
		right_start = 350
		default_width = 250

		requests.each do |request|
			page_count -= 1
			curr_cursor = @pdf.cursor
			draw_header "Catalog Request", [right_start, @pdf.cursor ], 180, :right
			@pdf.move_down 20

			draw_text_box "Shipping To:", [0, @pdf.cursor] , default_width, :left, 8
			draw_text_box "Contact Info:", [right_start, @pdf.cursor], default_width, :left, 8
			@pdf.move_down 10
			draw_text_box "#{request.company_name}\n #{request.ship_address}\n #{request.city}\t #{request.state}, #{request.zipcode}", [50, @pdf.cursor] , default_width, :left, 8
			draw_text_box "#{request.company_contact}\n #{request.email}\n #{request.phone_number}", [right_start + 50, @pdf.cursor], default_width, :left, 8
			@pdf.move_down 35
			@pdf.stroke_horizontal_rule
			@pdf.move_down 20
			
			@pdf.text "Order Details", align: :center, size: 14
			@pdf.table [["Date", "Deadline", "Sales Rep", "TSM", "Produced By", "Total Pages"], ["#{request.date}", "#{request.deadline}", "#{request.sales_rep}", "#{request.tsm}", "#{request.produced_by}", "#{request.page_count}"]], width: 540 do
				row(0).style background_color: 'd9534f'
			end
			@pdf.move_down 20

			@pdf.table [["Product", "Size"], ["Endura Intro", "#{request.endura_intro}"], ["Z-articulating Cap Sill", "#{request.z_cap_sill}"], ["Trillenium Multi Point", "#{request.trillenium_multi_point}"], ["Multi Point Astragal", "#{request.multi_point_astragal}"],
									["Ultimage Astragal", "#{request.ultimate_astragal}"], ["Flip Lever Astragal", "#{request.flip_lever_astragal}"], ["Frame Saver", "#{request.framesaver}"], ["Weatherseaaling", "#{request.weathersealing}"], ["Other", "#{request.other}"],
									["Other Descripation", "#{request.other_desc}"]], width: 540 do

									row(0).style background_color: 'd9534f'
			end

			@pdf.start_new_page unless page_count == 0
		end
		@pdf
	end

	def image_requests(requests)
		page_count = requests.count
		left_start = 80
		right_start = 350
		default_width = 250

		requests.each do |request|
			page_count -= 1
			curr_cursor = @pdf.cursor

			draw_header "Image Request", [right_start, @pdf.cursor ], 180, :right
			@pdf.move_down 20

			@pdf.text "Order Details", align: :center, size: 14
			@pdf.table [["Deadline", "Company Name", "Contact Email", "Phone Number"], ["#{request.order.deadline}", "#{request.order.customer.company_name}", "#{request.order.customer.contact_email}", "#{request.order.customer.phone_number}"]], width: 540 do
				row(0).style background_color: 'd9534f'
			end
			@pdf.move_down 20

			image = Image.find(request.reference_id)

			@pdf.table [["Image Description", "#{image.name}"], ["Price", "#{image.price}"], ["File Name", "#{image.file_name}"], ["Quantity", "#{request.quantity}"],
									["Group", "#{image.group}"], ["Sub-Group", "#{image.sub_group}"], ["Note", "#{request.note}"]], width: 540 do
			end

			@pdf.start_new_page unless page_count == 0

		end

		@pdf
	end

	def funds_details_by_customer(customers, orders, funds)
		page_count = funds.count
		left_start = 80
		right_start = 350
		default_width = 250
		draw_header "", [right_start, @pdf.cursor ], 180, :right

		funds.each do |key, fund|
			page_count -= 1
			@pdf.move_down 20

			curr_cursor = @pdf.cursor
			customer = customers.find_by(id: key)

			bank = customer.funds_bank

			unless bank.nil?
				@pdf.text "#{customer.company_name}", align: :center, size: 14
				@pdf.table [["Allocated Amount", "Current Balance"], ["#{bank.allocated_amt}", "#{bank.current_bal}"]], width: 540 do
					row(0).style background_color: 'd9534f'
				end

				@pdf.move_down 20

				@pdf.table [["Order #", "Order Total"]], width: 540, column_widths: 270 do
					row(0).style background_color: 'd9534f'
				end

				fund[:order_ids].zip(fund[:order_sum]).each do |order_details|
					@pdf.table [["#{order_details[0]}", "#{order_details[1]}"]], width: 540, column_widths: 270
				end

				@pdf.move_down 20
				@pdf.start_new_page
			end
		end

		@pdf
	end

	def draw_header (text, location, width, align)
		@pdf.image "#{Rails.root}/public/images/endura-pdf.jpeg", height: 40
		draw_text_box text, location, width, align
	end

	def draw_text_box(text, location, width, align=:left, size=12)
		@pdf.text_box text, at: location, width: width, align: align, size: size
	end

end