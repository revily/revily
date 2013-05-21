describe "users" do
  pending do
    let(:account) { create(:account) }
    let(:user) { create(:user, account: account) }
    # before do
    # sign_out user
    # end

    describe "logging in" do
      context 'invalid user' do
        it "incorrect user can't sign in" do
          visit '/users/sign_in'
          within("#new_user") do
            fill_in 'Email', :with => user.email + '.kp'
            fill_in 'Password', :with => user.password
          end
          click_button 'Sign in'
          page.should have_content 'Invalid'
        end
      end

      context 'valid user', :pending do

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
    end

    describe "signing up" do
      pending
    end
  end
end
