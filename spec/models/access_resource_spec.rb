require 'rails_helper'

RSpec.describe AccessResource, type: :model do

  context :attributes do
    it "has id" do
      expect(AccessResource.new(id: 1)).to have_attributes(id: 1)
    end

    it "has resource_id" do
      expect(AccessResource.new(resource_id: 1)).to have_attributes(resource_id: 1)
    end

    it "has resource_klass" do
      expect(AccessResource.new(resource_klass: "Klass")).to have_attributes(resource_klass: "Klass")
    end

    it "has user_id" do
      expect(AccessResource.new(user_id: 1)).to have_attributes(user_id: 1)
    end

    it "has can_access" do
      expect(AccessResource.new(can_access: true)).to have_attributes(can_access: true)
    end

    it "has super_user" do
      expect(AccessResource.new(super_user: true)).to have_attributes(super_user: true)
    end

  end

end