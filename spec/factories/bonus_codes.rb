FactoryGirl.define do
  factory :bonus_code do
    code { DateTime.now.strftime('%Q')[1..-1] }
    product
  end
end
