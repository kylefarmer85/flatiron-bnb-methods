class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true
  validates :neighborhood, presence: :true


  before_create :make_host
  before_destroy :host_status

  def make_host
    unless self.host.host
      self.host.update(:host => true)
    end
  end

  def host_status
    if self.host.listings.count <= 1
      self.host.update(:host => false)
    end
  end

  def average_review_rating
    ratings = 0.0
    count = 0
    self.reviews.each do |review|
      ratings += review.rating
      count +=1
    end
    result = (ratings / count)
    result
  end

end
