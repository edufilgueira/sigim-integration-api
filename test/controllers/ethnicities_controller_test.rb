require "test_helper"

class EthnicitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ethnicity = ethnicities(:one)
  end

  test "should get index" do
    get ethnicities_url, as: :json
    assert_response :success
  end

  test "should create ethnicity" do
    assert_difference("Ethnicity.count") do
      post ethnicities_url, params: { ethnicity: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show ethnicity" do
    get ethnicity_url(@ethnicity), as: :json
    assert_response :success
  end

  test "should update ethnicity" do
    patch ethnicity_url(@ethnicity), params: { ethnicity: {  } }, as: :json
    assert_response :success
  end

  test "should destroy ethnicity" do
    assert_difference("Ethnicity.count", -1) do
      delete ethnicity_url(@ethnicity), as: :json
    end

    assert_response :no_content
  end
end
