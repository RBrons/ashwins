require 'rails_helper'

RSpec.describe "common_static_fields/edit", type: :view do
  before(:each) do
    @common_static_field = assign(:common_static_field, CommonStaticField.create!(
      :type_is => "MyString",
      :title => "MyString"
    ))
  end

  it "renders the edit common_static_field form" do
    render

    assert_select "form[action=?][method=?]", common_static_field_path(@common_static_field), "post" do

      assert_select "input#common_static_field_type_is[name=?]", "common_static_field[type_is]"

      assert_select "input#common_static_field_title[name=?]", "common_static_field[title]"
    end
  end
end
