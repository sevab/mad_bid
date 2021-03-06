class BidsController < ApplicationController
  respond_to :html, :json
  def create
    if current_user && current_user.amount_of_credits > 0
      # verify that params['id'] is within the range
      # of ids of the active listings. Or catch an exception
      # => find will return a massive exceptiom
      # => find_by will return a nil.
      @listing = Listing.find(params['id'])
      if @listing.credits_per_bid < current_user.amount_of_credits
        current_user.makes_bid @listing
        websocket[:bids].trigger 'new',
          { id: @listing.id, current_price: @listing.current_price, latest_bidder: @listing.latest_bidder, active: @listing.active}
      end
    end
  end

  def show
    respond_with current_user do |format|
       format.json {render json: current_user.as_json(only: [:amount_of_credits])}
    end
  end
end
