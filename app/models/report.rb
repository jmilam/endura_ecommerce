class Report < ApplicationRecord
	def self.create_get_link_from_text(link_text, id)
		case link_text
		when "Tradeshow Requests Approved"
			"tradeshow_support_request_path(#{id})"
		when "Catalog Requests Approved"
			"catalog_request_path(#{id})"
		when "All Approved/Rejected Orders", "Image Requests Approved"
			"order_path(#{id})"
		when "Export Customer Details"
			company_name = Customer.find(id).company_name.gsub("'", "")
			"customer_path(company_name: '#{company_name}')"
		else
			p link_text
		end
	end

end