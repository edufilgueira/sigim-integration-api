require "test_helper"

class ScholaritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scholarity = scholarities(:one)
  end

  test "should get index" do
    get scholarities_url, as: :json
    assert_response :success
  end

  test "should create scholarity" do
    assert_difference("Scholarity.count") do
      post scholarities_url, params: { scholarity: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show scholarity" do
    get scholarity_url(@scholarity), as: :json
    assert_response :success
  end

  test "should update scholarity" do
    patch scholarity_url(@scholarity), params: { scholarity: {  } }, as: :json
    assert_response :success
  end

  test "should destroy scholarity" do
    assert_difference("Scholarity.count", -1) do
      delete scholarity_url(@scholarity), as: :json
    end

    assert_response :no_content
  end
end
