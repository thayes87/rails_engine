FactoryBot.define do
  factory :item do
    merchant
    name { Faker::Coffee.blend_name }
    description { Faker::Lorem.sentence(word_count: 3) }
    unit_price { Faker::Number.decimal(l_digits: 2) }
  end
end