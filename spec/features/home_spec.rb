describe "the front page", :type => :feature do

  it "renders correct text" do
    visit '/'
    page.should have_content 'Reveille'
  end
  
end
