require 'rails_helper'

RSpec.describe "admin/default_values/show", type: :view do
  before(:each) do
    @admin_default_value = assign(:admin_default_value, DefaultValue.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
