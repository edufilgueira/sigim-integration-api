require "test_helper"

class SystemOccurrencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_occurrence = system_occurrences(:one)
  end

  test "should get index" do
    get system_occurrences_url
    assert_response :success
  end

  test "should get new" do
    get new_system_occurrence_url
    assert_response :success
  end

  test "should create system_occurrence" do
    assert_difference("SystemOccurrence.count") do
      post system_occurrences_url, params: { system_occurrence: {  } }
    end

    assert_redirected_to system_occurrence_url(SystemOccurrence.last)
  end

  test "should show system_occurrence" do
    get system_occurrence_url(@system_occurrence)
    assert_response :success
  end

  test "should get edit" do
    get edit_system_occurrence_url(@system_occurrence)
    assert_response :success
  end

  test "should update system_occurrence" do
    patch system_occurrence_url(@system_occurrence), params: { system_occurrence: {  } }
    assert_redirected_to system_occurrence_url(@system_occurrence)
  end

  test "should destroy system_occurrence" do
    assert_difference("SystemOccurrence.count", -1) do
      delete system_occurrence_url(@system_occurrence)
    end

    assert_redirected_to system_occurrences_url
  end
end
