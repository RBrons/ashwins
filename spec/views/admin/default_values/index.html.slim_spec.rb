require 'rails_helper'

RSpec.describe "admin/default_values/index", type: :view do
  before(:each) do
    assign(:default_values, [
      DefaultValue.create!(),
      DefaultValue.create!()
    ])
  end

  it "renders a list of admin/default_values" do
    render
  end
end
