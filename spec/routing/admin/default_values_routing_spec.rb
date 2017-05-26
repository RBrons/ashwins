require "rails_helper"

RSpec.describe Admin::DefaultValuesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/default_values").to route_to("admin/default_values#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/default_values/new").to route_to("admin/default_values#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/default_values/1").to route_to("admin/default_values#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/default_values/1/edit").to route_to("admin/default_values#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/default_values").to route_to("admin/default_values#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/default_values/1").to route_to("admin/default_values#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/default_values/1").to route_to("admin/default_values#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/default_values/1").to route_to("admin/default_values#destroy", :id => "1")
    end

  end
end
