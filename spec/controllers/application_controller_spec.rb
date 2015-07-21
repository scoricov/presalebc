require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  describe "#not_found" do
    it "unknown paths should route to not_found" do
      expect(get: '/newunknown').to route_to({"controller"=>"application", "action"=>"not_found", "path"=>"newunknown"})
    end
  end
end
