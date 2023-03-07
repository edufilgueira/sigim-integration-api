require "application_system_test_case"

class SystemOccurrencesTest < ApplicationSystemTestCase
  setup do
    @system_occurrence = system_occurrences(:one)
  end

  test "visiting the index" do
    visit system_occurrences_url
    assert_selector "h1", text: "System occurrences"
  end

  test "should create system occurrence" do
    visit system_occurrences_url
    click_on "New system occurrence"

    click_on "Create System occurrence"

    assert_text "System occurrence was successfully created"
    click_on "Back"
  end

  test "should update System occurrence" do
    visit system_occurrence_url(@system_occurrence)
    click_on "Edit this system occurrence", match: :first

    click_on "Update System occurrence"

    assert_text "System occurrence was successfully updated"
    click_on "Back"
  end

  test "should destroy System occurrence" do
    visit system_occurrence_url(@system_occurrence)
    click_on "Destroy this system occurrence", match: :first

    assert_text "System occurrence was successfully destroyed"
  end
end
