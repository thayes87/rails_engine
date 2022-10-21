class Merchant < ApplicationRecord
  has_many :items
  validates :name, presence: true

  def self.find_merchant_by_name(data)
    where('name ILIKE ?', "%#{data[:name]}%")
    .order(:name)
  end
end