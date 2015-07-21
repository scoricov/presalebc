Rails.application.routes.draw do
  get 'bonus_codes/validate'
  match '*path', via: [:get, :post], :to => "application#not_found"
end
