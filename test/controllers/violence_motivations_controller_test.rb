require "test_helper"

class ViolenceMotivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @violence_motivation = violence_motivations(:one)
  end

  test "should get index" do
    get violence_motivations_url, as: :json
    assert_response :success
  end

  test "should create violence_motivation" do
    assert_difference("ViolenceMotivation.count") do
      post violence_motivations_url, params: { violence_motivation: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show violence_motivation" do
    get violence_motivation_url(@violence_motivation), as: :json
    assert_response :success
  end

  test "should update violence_motivation" do
    patch violence_motivation_url(@violence_motivation), params: { violence_motivation: {  } }, as: :json
    assert_response :success
  end

  test "should destroy violence_motivation" do
    assert_difference("ViolenceMotivation.count", -1) do
      delete violence_motivation_url(@violence_motivation), as: :json
    end

    assert_response :no_content
  end
end
