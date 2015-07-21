require 'rails_helper'

RSpec.describe Product, :type => :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:service) }
  it { should validate_numericality_of(:status) }
  it { should validate_numericality_of(:service) }
  it { should validate_inclusion_of(:status).in_array((0..1).to_a) }
  it { should validate_inclusion_of(:service).in_array((0..2).to_a) }
  it { should validate_length_of(:title).is_at_most(255) }

  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        product = FactoryGirl.build(:product)
        expect(product).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        product = FactoryGirl.build(:product, title: "")
        expect(product).not_to be_valid
      end
    end

  end

  describe "#bonus_codes_via_service?" do

    context "service available" do
      it "should be true" do
        product = FactoryGirl.create(:product, status: 1, service: 1)
        expect(product.bonus_codes_via_service?).to be true
      end
    end

    context "service unavailable" do
      it "should be false" do
        product = FactoryGirl.create(:product, status: 1, service: 0)
        expect(product.bonus_codes_via_service?).to be false
      end
    end

  end


  describe "#bonus_codes_loaded?" do

    context "pre-loaded" do
      it "should be true" do
        product = FactoryGirl.create(:product, status: 0, service: 0)
        product.bonus_codes.create([{code: 123123}, {code: 2872343}])
        expect(product.bonus_codes_loaded?).to be true
      end
    end

    context "not pre-loaded" do
      it "should be false" do
        product = FactoryGirl.create(:product, status: 0, service: 0)
        expect(product.bonus_codes_loaded?).to be false
      end
    end

  end

  describe "#try_fetch_bonus_codes" do

    context "pre-loaded, without external service" do
      it "should be nil" do
        product = FactoryGirl.create(:product, status: 0, service: 0)
        expect(product.try_fetch_bonus_codes).to be_nil
      end
    end

    context "pre-loaded, with external service" do
      it "should be nil" do
        product = FactoryGirl.create(:product, status: 0, service: 1)
        expect(product.try_fetch_bonus_codes).to be_nil
      end
    end

    context "without bonus codes, with external service 'TV'" do
      product = FactoryGirl.create(:product, status: 1, service: 1)
      it "should pre-load 51 bonus codes" do
        expect(product.try_fetch_bonus_codes).not_to be_nil
        expect(product.bonus_codes.count).to eq 51
      end
    end

    context "without bonus codes, with external service 'RTG'" do
      product = FactoryGirl.create(:product, status: 1, service: 2)
      it "should pre-load 21 bonus codes" do
        expect(product.try_fetch_bonus_codes).not_to be_nil
        expect(product.bonus_codes.count).to eq 21
      end
    end

  end

end
