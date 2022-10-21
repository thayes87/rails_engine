class Item < ApplicationRecord
  belongs_to :merchant 
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_by_name(name)
    where('name ILIKE ?', "%#{name}%")
    .order(:name)
    .first
  end

  def self.find_by_min_max(min_price, max_price)
    where('unit_price >= ? and unit_price <= ?', min_price, max_price)
    .order(Arel.sql('lower(name)'))
    .first
  end

  def self.find_by_min(min_price)
    where('unit_price >= ?', min_price)
    .order(Arel.sql('lower(name)'))
    .first
  end

  def self.find_by_max(max_price) 
    where('unit_price <= ?', max_price)
    .order(Arel.sql('lower(name)'))
    .first
  end
end