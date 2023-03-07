require "test_helper"

class RelationshipDegreesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @relationship_degree = relationship_degrees(:one)
  end

  test "should get index" do
    get relationship_degrees_url, as: :json
    assert_response :success
  end

  test "should create relationship_degree" do
    assert_difference("RelationshipDegree.count") do
      post relationship_degrees_url, params: { relationship_degree: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show relationship_degree" do
    get relationship_degree_url(@relationship_degree), as: :json
    assert_response :success
  end

  test "should update relationship_degree" do
    patch relationship_degree_url(@relationship_degree), params: { relationship_degree: {  } }, as: :json
    assert_response :success
  end

  test "should destroy relationship_degree" do
    assert_difference("RelationshipDegree.count", -1) do
      delete relationship_degree_url(@relationship_degree), as: :json
    end

    assert_response :no_content
  end
end
