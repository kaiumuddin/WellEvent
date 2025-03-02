class Event < ApplicationRecord
  include PgSearch::Model

  belongs_to :category, optional: true

  pg_search_scope :search_by_name_and_description, 
                  against: [:name, :description, :location], 
                  using: {
                    tsearch: { prefix: true } # Enables partial matching
                  }

  belongs_to :organizer, class_name: 'User'
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :location, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validates :category_id, presence: true

  def self.upcoming
    where('starts_at > ?', Time.now).order('starts_at')
  end

  def free?
    price.blank? || price.zero?
  end

  def sold_out?
    (capacity - registrations.size).zero?
  end

  def average_rating
    ratings.average(:rating).to_f.round(2) if ratings.any?
  end

end
