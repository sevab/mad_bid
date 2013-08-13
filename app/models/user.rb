class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [ :username ]
	
	has_many :bids

  #private
  def makes_bid item
    time_now = Time.now
    my_bid = Bid.create(user: self, listing: item)
    my_bid.update_price item.current_price
    item.add_bid(self.username, my_bid.id, time_now)
  end
end