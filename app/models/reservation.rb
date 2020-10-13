class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkin, :checkout
  validate :available, :guest_and_host_not_the_same, :checkout_after_checkin

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment.")
    end
  end

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def duration
    (checkout - checkin).to_i
  end

  def total_price
    listing.price * duration
  end

  def checkout_after_checkin
    if self.checkout && self.checkin
      if self.checkout <= self.checkin
        errors.add(:guest_id, "Your checkin date needs to be after your checkout date")
      end
    end
  end


end
