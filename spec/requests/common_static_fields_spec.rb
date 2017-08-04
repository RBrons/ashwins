require 'rails_helper'

RSpec.describe "CommonStaticFields", type: :request do
  describe "GET /common_static_fields" do
    it "works! (now write some real specs)" do
      get common_static_fields_path
      expect(response).to have_http_status(200)
    end
  end
end
