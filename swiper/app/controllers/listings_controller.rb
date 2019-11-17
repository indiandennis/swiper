class ListingsController < ApplicationController

    private
    def listing_params
        params.require(:listing).permit(:location, :description, :start_time, :end_time, :price, :reserved_amount, :reserved_time)
    end

    def filter_listings(filter_params)
        selected_locations = []
        Listing.locations.keys.each do |loc|
            if filter_params[loc] == '1'
                selected_locations << loc
            end
        end
        
        filtered = Listing.where(location: selected_locations, buyer: nil)
        filtered = filtered.where("price <= ?", filter_params[:price]) unless !filter_params[:price] || filter_params[:price].empty?
        filtered = filtered.where("? <= amount", filter_params[:amount]) unless !filter_params[:amount] || filter_params[:amount].empty?
        return filtered
    end

    public
    def index
        @listings = Listing.all
    end

    def show
        @listing = Listing.find(params[:id])
    end

    def new
        @listing = Listing.new
    end

    def create
        @listing = current_user.listings.new(listing_params)

        if @listing.save
            redirect_to listing_path(@listing), notice: "Listing Created!"
        else
            @errors = @listing.errors.full_messages
            render :new
        end
    end

    def edit
        @listing = current_user.listings.find(params[:id])
    end

    def update
        @listing = current_user.listings.find(params[:id])

        if @listing.update_attributes(listing_params)
            redirect_to listing_path(@listing), notice: "Listing Updated!"
        else
            @errors = @listing.errors.full_messages
            render :edit
        end
    end

    def destroy
        listing = Listing.find(params[:id])
        listing.destroy
        redirect_to listings_path, notice: "Deleted Listing: #{listing.name}"
    end

    def reserve
        @listing = Listing.find(params[:id])
        
        if @listing.buyer != nil
            redirect_to listing_path(@listing, :id => params[:id]), alert: "This listing cannot be reserved at this time"
        end

        if @listing.update({:buyer => current_user.id, :reserved_amount => :reserved_amount, :reserved_time => :reserved_time})
            redirect_to listing_path(@listing), notice: "Listing reserved!"
        else
            @errors = @listing.errors.full_messages
            render :show
        end
    end

    def listing_params
        params.require(:listing).permit(:name, :description)
    end
end