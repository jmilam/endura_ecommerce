class Pdf
	require 'prawn'
	#require 'prawn-table'

	def initialize
		@pdf = Prawn::Document.new
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


			draw_text_box "Contact Info:", [0, @pdf.cursor], default_width, :left, 8
			@pdf.move_down 10
			draw_text_box "#{request.company_name}", [50, @pdf.cursor] , default_width, :left, 8
			draw_text_box "#{request.company_contact}\n #{request.email}\n #{request.phone_number}", [50, @pdf.cursor], default_width, :left, 8
			@pdf.move_down 35
			@pdf.stroke_horizontal_rule
			@pdf.move_down 20

			@pdf.text "Order Details", align: :center, size: 14
			@pdf.table [["Date", "Deadline", "Sales Rep", "TSM"], ["#{request.date}", "#{request.deadline}", "#{request.sales_rep}", "#{request.tsm}"]], width: 540 do
				row(0).style background_color: 'd9534f'
			end

			@pdf.move_down 20
			
			@pdf.table [["Purpose of Request", "#{request.request_purpose}"], ["Other Entry", "#{request.other_entry}"], ["Total # of Images", "#{request.total_number_images}"], ["Images needed", "#{request.images_needed}"], ["File Format", "#{request.file_format}"]], width: 540 do
				row(0).style background_color: 'd9534f'
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

	def draw_header (text, location, width, align)
		@pdf.image "#{Rails.root}/public/images/endura-pdf.jpeg", height: 40
		draw_text_box text, location, width, align
	end

	def draw_text_box(text, location, width, align=:left, size=12)
		@pdf.text_box text, at: location, width: width, align: align, size: size
	end
end