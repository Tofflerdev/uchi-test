require 'test_helper'

class MainPageControllerTest < ActionDispatch::IntegrationTest
  def setup
   @right_url = "https://github.com/rails/rails"
   @bad_url = "https://uchi.ru/"
   @test_name = "Test"
   @test_index = "2"
   @test_names = Array.new(3, @test_name)
  end

  test "should get start" do
    get root_url
    assert_response :success
    assert_select 'form.form-horizontal'
  end

  test "should get /search with right url" do
    get search_url, params:{q: @right_url}
    assert_response :success
    assert_select "ul li a", 3
    assert_select "a", "Download zip (3)"
  
  end 

  test "shoudld redirect /search  to root with bad url" do
    get search_url, params:{q: @bad_url}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'form.form-horizontal'
  end

  test "should get /download in .pdf and .zip" do
    get "/download.pdf", params:{name: @test_name, index: @test_index}
    assert_response :success
    get "/download.zip", params:{names: @test_names}
    assert_response :success  
  end

end
