class UserPortalController < ApplicationController
  def index
    #@product = Product.new
    @products = Product.group(:group, :price, :id)
    @sales_reps = SalesRep.all
    @tsms = Tsm.all
    @customers = Customer.all
    @img_request_purpose = ["Advertisement", "System Brochure", "Single Product Brochure", "Website", "Other"]
    @file_formats = ["JPEG", "PNG", "TIFF", "GIF"]
    @groups = Hash.new
    @products.map {|product| @groups[product.group] = Array.new }.uniq
    @products.each {|product| @groups[product.group].push(product)}
    @produced_by = ["Customer", "Endura Marketing"]
    @page_sizes = ["1/8 page", "1/4 page", "3/8 page", "1/2 page", "5/8 page", "3/4 page", "7/8 page", "full page"]
    @partial = "partials/home_account_page"
  	unless params[:partial].nil?
  		@partial = "partials/#{params[:partial]}_form"
  	end

  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def destroy
  end
end
