class BonusCode < ActiveRecord::Base
  self.primary_key = 'code'

  belongs_to :product
  validates :code, presence: true, numericality: true, uniqueness: true, length: {minimum: 1, maximum: 12}
  validates :product, presence: true

  def product_id_matches?(product_id)
    # Compare product IDs without selecting the product from DB
    self.product_id == product_id.to_i
  end

  def self.try_preload_by_product(code, product_id)
    # Lookup the product
    product = Product.find_by(id: product_id) or return
    # Try to fetch bonus codes from remote service, if possible
    product.try_fetch_bonus_codes or return
    # Lookup bonus code within the product
    product.bonus_codes.find_by(code: code)
  end
end
