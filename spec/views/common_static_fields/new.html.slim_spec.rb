require 'rails_helper'

RSpec.describe "common_static_fields/new", type: :view do
  before(:each) do
    assign(:common_static_field, CommonStaticField.new(
      :type_is => "MyString",
      :title => "MyString"
    ))
  end

  it "renders new common_static_field form" do
    render

    assert_select "form[action=?][method=?]", common_static_fields_path, "post" do

      assert_select "input#common_static_field_type_is[name=?]", "common_static_field[type_is]"

      assert_select "input#common_static_field_title[name=?]", "common_static_field[title]"
    end
  end
end
