FactoryGirl.define do
  factory :product do
    title "Sample product"
    status 0
    service 0

    factory :product_with_bonus_codes do
      transient do
        bonus_codes_count 5
      end

      after(:create) do |product, evaluator|
        create_list(:bonus_code, evaluator.bonus_codes_count, product: product)
      end
    end
  end
end
