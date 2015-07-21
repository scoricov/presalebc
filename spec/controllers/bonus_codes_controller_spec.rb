require 'rails_helper'

RSpec.describe BonusCodesController, :type => :controller do
  describe "#validate" do

    context "invalid request" do
      it "should forbid invalid or missing parameters" do
        get :validate, {product_id: 'weird', bonus_code: 'xxx'}
        expect(response.status).to eq(403)
        get :validate, {bonus_code: 123}
        expect(response.status).to eq(403)
        get :validate, {product_id: 1212 }
        expect(response.status).to eq(403)
      end
    end

    context "requested code exists but doesn’t belong to a product with provided product_id" do
      it "should respond 404" do
        create(:bonus_code, code: 68483737392)
        get :validate, {product_id: 101011011, bonus_code: 68483737392}
        expect(response.status).to eq(404)
      end
    end

    context "bonus code hasn’t been sold" do
      it "should respond 403" do
        get :validate, {product_id: 101011011, bonus_code: 968483737395}
        expect(response.status).to eq(403)
      end
    end

    context "bonus code exists and matches product" do
      it "should respond success" do
        code = 68483737392
        product = create(:product, bonus_codes: [create(:bonus_code, code: code)])
        get :validate, {product_id: product.id, bonus_code: code}
        expect(response).to have_http_status(:success)
      end
    end

    context "bonus code was not pre-loaded but then was fetched from service TV" do
      it "should respond success" do
        product = create(:product, status: 1, service: 1)
        get :validate, {product_id: product.id, bonus_code: 2000000002}
        expect(response).to have_http_status(:success)
      end
    end

    context "bonus code was not pre-loaded but then was fetched from service RTG" do
      it "should respond success" do
        product = create(:product, status: 1, service: 2)
        get :validate, {product_id: product.id, bonus_code: 4000000015}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
