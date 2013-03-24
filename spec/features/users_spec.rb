describe "users" do

  before :all do
    User.create(:email => 'user@example.com', :password => 'askdjfhkah')
  end
  
  it "logs in" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'askdjfhkah'
    end
    click_button 'Sign in'
    page.should have_content 'Signed in successfully'
  end
  
end
