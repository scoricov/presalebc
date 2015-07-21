require 'rails_helper'

RSpec.describe BonusCode, :type => :model do
  subject { create(:bonus_code) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:product) }
  it { should validate_numericality_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should validate_inclusion_of(:code).in_range(0..999999999999).with_message(/is too long/) }

  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        bonus_code = FactoryGirl.build(:bonus_code)
        expect(bonus_code).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        bonus_code = FactoryGirl.build(:bonus_code, code: nil)
        expect(bonus_code).not_to be_valid
      end
    end

  end

  describe "#product_id_matches?" do

    context "if product_id matches" do
      it "should be true" do
        bonus_code = FactoryGirl.create(:bonus_code, code: 1212872323)
        product_id = bonus_code.product.id
        expect(bonus_code.product_id_matches?(product_id)).to be true
      end
    end

    context "if product_id does not match" do
      it "should be false" do
        bonus_code = FactoryGirl.create(:bonus_code, code: 1212872323)
        expect(bonus_code.product_id_matches?(1)).to be false
      end
    end

  end

  describe "#try_preload_by_product" do

    context "preloads codes from TV and finds the specfied code" do
      it "should be true" do
        product_id = FactoryGirl.create(:product, status: 1, service: 1)
        expect(BonusCode.try_preload_by_product(2000000001, product_id)).to be_truthy
      end
    end

    context "does not preload for wrong product_id" do
      it "should be true" do
        expect(BonusCode.try_preload_by_product(2000000001, 210151012)).to be_falsey
      end
    end

    context "does not preload for product with unavailable service" do
      it "should be true" do
        product_id = FactoryGirl.create(:product, status: 1, service: 0)
        expect(BonusCode.try_preload_by_product(2000000001, product_id)).to be_falsey
      end
    end

  end
end
