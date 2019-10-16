require 'capybara/minitest'

Capybara.app = BunksController

class CapybaraTestCase < MiniTest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def setup
    @database = CampDatabase.new
  end

  def session
    last_request.env["rack.session"]
  end

  def test_all_bunks_page_links
    visit '/bunks'

    edit_page = all('td a').map {|a| a[:href] }.find {|href| href =~ /\/bunks\/\d+\/edit/}
    info_page = all('td a').map {|a| a[:href] }.find {|href| href =~ /\/bunks\/\d+\/info/}

    visit info_page
    assert page.has_content? "Bunk's Information"
    visit edit_page
    assert page.has_content? "Save Changes"
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end