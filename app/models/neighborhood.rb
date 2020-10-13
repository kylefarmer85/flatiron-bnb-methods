class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start_date, end_date)
    startdate = Date.parse start_date
    enddate = Date.parse end_date
    openings = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.checkin <= enddate && reservation.checkout >= startdate
          openings << listing
        end
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
    highest_neighborhood = ''
    count = 0
    self.all.each do |neighborhood|
      neighborhood.listings.each do |listing|
        if listing.reservations.count >= count
          count = listing.reservations.count
          highest_neighborhood = neighborhood
        end
      end
    end
   highest_neighborhood
  end

  def self.most_res
    neighborhoods = Hash.new(0)
    self.all.each do |neighborhood|
      neighborhood.listings.each do |listing|
        neighborhoods[neighborhood] += listing.reservations.count
      end
    end
    result = neighborhoods.sort_by {|k,v| v}
    result[-1][0]
  end


end
