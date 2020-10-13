class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
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
    highest_city = ''
    count = 0
    self.all.each do |city|
      city.listings.each do |listing|
        if listing.reservations.count >= count
          count = listing.reservations.count
          highest_city = city
        end
      end
    end
   highest_city
  end

  def self.most_res
    cities = Hash.new(0)
    self.all.each do |city|
      city.listings.each do |listing|
        cities[city] += listing.reservations.count
      end
    end
    result = cities.sort_by {|k,v| v}
    result[-1][0]
  end

end

