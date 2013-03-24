describe "users" do

  let(:user) { create(:user) }

  describe "logging in" do
    it "incorrect user can't sign in" do
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => user.email + '.kp'
        fill_in 'Password', :with => user.password
      end
      click_button 'Sign in'
      page.should have_content 'Invalid'
    end
  
    it "logs in" do
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
      end
      click_button 'Sign in'
      page.should have_content 'Signed in successfully'
    end
  end
  
  describe "signing up" do
    pending
  end

end
