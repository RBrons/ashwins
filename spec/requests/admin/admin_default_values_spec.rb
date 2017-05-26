require 'rails_helper'

RSpec.describe "Admin::DefaultValues", type: :request do
  describe "GET /admin_default_values" do
    it "works! (now write some real specs)" do
      get admin_default_values_path
      expect(response).to have_http_status(200)
    end
  end
end
