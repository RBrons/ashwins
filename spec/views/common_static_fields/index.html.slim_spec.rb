require 'rails_helper'

RSpec.describe "common_static_fields/index", type: :view do
  before(:each) do
    assign(:common_static_fields, [
      CommonStaticField.create!(
        :type_is => "Type Is",
        :title => "Title"
      ),
      CommonStaticField.create!(
        :type_is => "Type Is",
        :title => "Title"
      )
    ])
  end

  it "renders a list of common_static_fields" do
    render
    assert_select "tr>td", :text => "Type Is".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
