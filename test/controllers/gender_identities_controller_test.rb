require "test_helper"

class GenderIdentitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gender_identity = gender_identities(:one)
  end

  test "should get index" do
    get gender_identities_url, as: :json
    assert_response :success
  end

  test "should create gender_identity" do
    assert_difference("GenderIdentity.count") do
      post gender_identities_url, params: { gender_identity: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show gender_identity" do
    get gender_identity_url(@gender_identity), as: :json
    assert_response :success
  end

  test "should update gender_identity" do
    patch gender_identity_url(@gender_identity), params: { gender_identity: {  } }, as: :json
    assert_response :success
  end

  test "should destroy gender_identity" do
    assert_difference("GenderIdentity.count", -1) do
      delete gender_identity_url(@gender_identity), as: :json
    end

    assert_response :no_content
  end
end
