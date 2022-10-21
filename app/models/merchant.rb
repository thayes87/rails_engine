class Merchant < ApplicationRecord
  has_many :items
  validates :name, presence: true

  def self.find_merchant_by_name(name)
    where('name ILIKE ?', "%#{name}%")
    .order(:name)
  end
end