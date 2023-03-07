require "test_helper"

class ProtectiveMeasureTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @protective_measure_type = protective_measure_types(:one)
  end

  test "should get index" do
    get protective_measure_types_url, as: :json
    assert_response :success
  end

  test "should create protective_measure_type" do
    assert_difference("ProtectiveMeasureType.count") do
      post protective_measure_types_url, params: { protective_measure_type: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show protective_measure_type" do
    get protective_measure_type_url(@protective_measure_type), as: :json
    assert_response :success
  end

  test "should update protective_measure_type" do
    patch protective_measure_type_url(@protective_measure_type), params: { protective_measure_type: {  } }, as: :json
    assert_response :success
  end

  test "should destroy protective_measure_type" do
    assert_difference("ProtectiveMeasureType.count", -1) do
      delete protective_measure_type_url(@protective_measure_type), as: :json
    end

    assert_response :no_content
  end
end
