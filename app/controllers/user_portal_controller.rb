class UserPortalController < ApplicationController
  def index
    @user = current_user
    #@product = Product.new
    @products = Product.group(:group, :price, :id).order('name ASC')
    @catalog = CatalogRequest.new(params[:form_params])
    @sales_reps = SalesRep.all
    @tsms = Tsm.all
    @customers = Customer.all.order('company_name ASC')
    @images = Image.order('name ASC')
    @image_groups = {groups: [], sub_groups: []}
    Image.all.each do |image| 
      @image_groups[:groups] << image.group unless @image_groups[:groups].include?(image.group)
      @image_groups[:sub_groups] << image.sub_group unless @image_groups[:sub_groups].include?(image.sub_group)
    end
    
    @img_request_purpose = ["Advertisement", "System Brochure", "Single Product Brochure", "Website", "Other"]
    @file_formats = ["PNG", "JPEG", "TIFF", "GIF"]
    @attendees_count = (1..20).to_a
    @show_sizes = ["Small (Tabletops)", "Medium (Tabletops and Door Displays)", "Large (Full show display)"]
    @target_markets = ["Endura Customers", "Builders", "Dealers"]
    
    @groups = Hash.new
    @products.map {|product| @groups[product.group] = Array.new }.uniq
    @products.each {|product| @groups[product.group].push(product)}
    @produced_by = ["Customer", "Endura Marketing"]
    @page_sizes = ["N/A", "1/8 page", "1/4 page", "3/8 page", "1/2 page", "5/8 page", "3/4 page", "7/8 page", "full page"]
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
