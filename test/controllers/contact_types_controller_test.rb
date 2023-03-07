require "test_helper"

class ContactTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact_type = contact_types(:one)
  end

  test "should get index" do
    get contact_types_url, as: :json
    assert_response :success
  end

  test "should create contact_type" do
    assert_difference("ContactType.count") do
      post contact_types_url, params: { contact_type: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show contact_type" do
    get contact_type_url(@contact_type), as: :json
    assert_response :success
  end

  test "should update contact_type" do
    patch contact_type_url(@contact_type), params: { contact_type: {  } }, as: :json
    assert_response :success
  end

  test "should destroy contact_type" do
    assert_difference("ContactType.count", -1) do
      delete contact_type_url(@contact_type), as: :json
    end

    assert_response :no_content
  end
end
