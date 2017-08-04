require "rails_helper"

RSpec.describe CommonStaticFieldsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/common_static_fields").to route_to("common_static_fields#index")
    end

    it "routes to #new" do
      expect(:get => "/common_static_fields/new").to route_to("common_static_fields#new")
    end

    it "routes to #show" do
      expect(:get => "/common_static_fields/1").to route_to("common_static_fields#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/common_static_fields/1/edit").to route_to("common_static_fields#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/common_static_fields").to route_to("common_static_fields#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/common_static_fields/1").to route_to("common_static_fields#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/common_static_fields/1").to route_to("common_static_fields#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/common_static_fields/1").to route_to("common_static_fields#destroy", :id => "1")
    end

  end
end
