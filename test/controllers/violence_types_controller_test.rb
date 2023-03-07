require "test_helper"

class ViolenceTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @violence_type = violence_types(:one)
  end

  test "should get index" do
    get violence_types_url, as: :json
    assert_response :success
  end

  test "should create violence_type" do
    assert_difference("ViolenceType.count") do
      post violence_types_url, params: { violence_type: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show violence_type" do
    get violence_type_url(@violence_type), as: :json
    assert_response :success
  end

  test "should update violence_type" do
    patch violence_type_url(@violence_type), params: { violence_type: {  } }, as: :json
    assert_response :success
  end

  test "should destroy violence_type" do
    assert_difference("ViolenceType.count", -1) do
      delete violence_type_url(@violence_type), as: :json
    end

    assert_response :no_content
  end
end
