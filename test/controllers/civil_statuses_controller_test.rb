require "test_helper"

class CivilStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @civil_status = civil_statuses(:one)
  end

  test "should get index" do
    get civil_statuses_url, as: :json
    assert_response :success
  end

  test "should create civil_status" do
    assert_difference("CivilStatus.count") do
      post civil_statuses_url, params: { civil_status: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show civil_status" do
    get civil_status_url(@civil_status), as: :json
    assert_response :success
  end

  test "should update civil_status" do
    patch civil_status_url(@civil_status), params: { civil_status: {  } }, as: :json
    assert_response :success
  end

  test "should destroy civil_status" do
    assert_difference("CivilStatus.count", -1) do
      delete civil_status_url(@civil_status), as: :json
    end

    assert_response :no_content
  end
end
