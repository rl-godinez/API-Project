require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    stub_request(:get, "https://api.salesloft.com/v2/people.json?include_paging_counts=true&page=1&per_page=25")
      .to_return(status: 200, body: '{"data":[{"id": 1, "display_name": "test name", "email_address": "email@test.com"}]}', headers: {})
  end

  test "should get index" do
    get people_path

    assert_response :success
  end

  test "should get email_chars_count" do
    get email_chars_count_people_path, xhr: true

    assert_response :success
    assert_equal "text/javascript", @response.media_type
  end

  test "should get similar_emails" do
    stub_request(:get, "https://api.salesloft.com/v2/people.json?include_paging_counts=true&page=1&per_page=100")
      .to_return(status: 200, body: '{"metadata": { "paging": {"total_pages": 1} },"data":[{"id": 1, "display_name": "test name", "email_address": "email@test.com"}]}', headers: {})

    person = ListPeoplePerPage.new.execute.first
    get similar_emails_person_path(id: person.id), xhr: true

    assert_response :success
    assert_equal "text/javascript", @response.media_type
  end
end