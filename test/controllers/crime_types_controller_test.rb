require "test_helper"

class CrimeTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crime_type = crime_types(:one)
  end

  test "should get index" do
    get crime_types_url, as: :json
    assert_response :success
  end

  test "should create crime_type" do
    assert_difference("CrimeType.count") do
      post crime_types_url, params: { crime_type: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show crime_type" do
    get crime_type_url(@crime_type), as: :json
    assert_response :success
  end

  test "should update crime_type" do
    patch crime_type_url(@crime_type), params: { crime_type: {  } }, as: :json
    assert_response :success
  end

  test "should destroy crime_type" do
    assert_difference("CrimeType.count", -1) do
      delete crime_type_url(@crime_type), as: :json
    end

    assert_response :no_content
  end
end
