class Item < ApplicationRecord
  belongs_to :merchant 
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_by_name(data)
    where('name ILIKE ?', "%#{data[:name]}%")
    .order(:name)
    .first
  end

  def self.find_by_min_max(data)
    where('unit_price >= ? and unit_price <= ?', data[:min_price], data[:max_price])
    .order(Arel.sql('lower(name)'))
    .first
  end

  def self.find_by_min(data)
    where('unit_price >= ?', data[:min_price])
    .order(Arel.sql('lower(name)'))
    .first
  end

  def self.find_by_max(data) 
    where('unit_price <= ?', data[:max_price])
    .order(Arel.sql('lower(name)'))
    .first
  end
end