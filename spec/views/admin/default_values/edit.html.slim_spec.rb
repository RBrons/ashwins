require 'rails_helper'

RSpec.describe "admin/default_values/edit", type: :view do
  before(:each) do
    @admin_default_value = assign(:admin_default_value, DefaultValue.create!())
  end

  it "renders the edit admin_default_value form" do
    render

    assert_select "form[action=?][method=?]", admin_default_value_path(@admin_default_value), "post" do
    end
  end
end
