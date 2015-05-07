require 'test_helper'

class AboutTest < ActionDispatch::IntegrationTest

  test "about page" do
    visit about_index_path
    assert_index_page(about_index_path,"About", nil, false, false)
    assert page.has_selector?('h4', :text => "System Status"), "System Status was expected in the <h4> tag, but was not found"
    assert page.has_selector?('h4', :text => "Support"), "Support was expected in the <h4> tag, but was not found"
    assert page.has_selector?('h4', :text => "System Information"), "System Information was expected in the <h4> tag, but was not found"
    assert page.has_link?("Capsules", :href => "#smart_proxies")
    assert page.has_link?("Compute Resources", :href => "#compute_resources")
    assert page.has_link?("Red Hat Satellite Blog", :href => "https://access.redhat.com/blogs/1169563")
    assert page.has_link?("User Guide", :href => "https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html/User_Guide/index.html")
    assert page.has_link?("Ohad Levy", :href => "mailto:ohadlevy@gmail.com")
    assert page.has_content?("Version")
  end

end
