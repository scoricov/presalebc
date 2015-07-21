class BonusCodesController < ApplicationController
  before_action :find_fast, :verify_product_id, :try_preload, on: :validate

  def validate
    render status: 200, plain: "Valid bonus code."
  end

  private

  def find_fast
    @bonus_code = BonusCode.find_by(code: params[:bonus_code])
  end

  def verify_product_id
    return unless @bonus_code.present?
    unless @bonus_code.product_id_matches?(params[:product_id])
      render status: 404, plain: "Product ID mismatch."
    end
  end

  def try_preload
    return if @bonus_code.present?
    unless BonusCode.try_preload_by_product(params[:bonus_code], params[:product_id])
      render status: 403, plain: "Bonus code hasn't been sold."
    end
  end
end
