require "test_helper"

class SexualOrientationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sexual_orientation = sexual_orientations(:one)
  end

  test "should get index" do
    get sexual_orientations_url, as: :json
    assert_response :success
  end

  test "should create sexual_orientation" do
    assert_difference("SexualOrientation.count") do
      post sexual_orientations_url, params: { sexual_orientation: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show sexual_orientation" do
    get sexual_orientation_url(@sexual_orientation), as: :json
    assert_response :success
  end

  test "should update sexual_orientation" do
    patch sexual_orientation_url(@sexual_orientation), params: { sexual_orientation: {  } }, as: :json
    assert_response :success
  end

  test "should destroy sexual_orientation" do
    assert_difference("SexualOrientation.count", -1) do
      delete sexual_orientation_url(@sexual_orientation), as: :json
    end

    assert_response :no_content
  end
end
