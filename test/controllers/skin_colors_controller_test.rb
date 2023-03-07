require "test_helper"

class SkinColorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skin_color = skin_colors(:one)
  end

  test "should get index" do
    get skin_colors_url, as: :json
    assert_response :success
  end

  test "should create skin_color" do
    assert_difference("SkinColor.count") do
      post skin_colors_url, params: { skin_color: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show skin_color" do
    get skin_color_url(@skin_color), as: :json
    assert_response :success
  end

  test "should update skin_color" do
    patch skin_color_url(@skin_color), params: { skin_color: {  } }, as: :json
    assert_response :success
  end

  test "should destroy skin_color" do
    assert_difference("SkinColor.count", -1) do
      delete skin_color_url(@skin_color), as: :json
    end

    assert_response :no_content
  end
end
