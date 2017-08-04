require 'rails_helper'

RSpec.describe "common_static_fields/show", type: :view do
  before(:each) do
    @common_static_field = assign(:common_static_field, CommonStaticField.create!(
      :type_is => "Type Is",
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type Is/)
    expect(rendered).to match(/Title/)
  end
end
