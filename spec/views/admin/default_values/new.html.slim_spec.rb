require 'rails_helper'

RSpec.describe "admin/default_values/new", type: :view do
  before(:each) do
    assign(:admin_default_value, DefaultValue.new())
  end

  it "renders new admin_default_value form" do
    render

    assert_select "form[action=?][method=?]", default_values_path, "post" do
    end
  end
end
