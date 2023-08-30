FactoryBot.define do 
  factory :market do 
    name { Faker::Music::Hiphop.groups }
    street { Faker::Ancient.primordial }
    city { Faker::Address.city }
    county { Faker::Adjective.negative }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end

  factory :vendor do
    name { Faker::Company.name }
    description { Faker::Adjective.positive }
    contact_name { Faker::Superhero.name }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { Faker::Boolean.boolean }
  end
end