require 'rails_helper'

feature "Authentication" do

  subject { page }

  feature "signin page" do
    before { visit signin_path }

    feature "with invalid information" do
      before { click_button 'signin_button' }

      scenario { should have_title('Sign in') }
      scenario { should have_selector('div.alert.alert-danger', text: 'Invalid') }

      feature "after visiting another page" do
        before { click_link 'Football Pool Mania' }
        scenario { should_not have_selector('div.alert.alert-danger') }
      end
    end

    feature "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in 'signin_email',    with: user.email.upcase
        fill_in 'signin_password', with: user.password
        click_button 'signin_button'
      end

      scenario { should have_title(user.name) }
      scenario { should have_link('All Users',   href: users_path) }
      scenario { should have_link('Profile',     href: user_path(user)) }
      scenario { should have_link('Settings',    href: edit_user_path(user)) }
      scenario { should have_link('Sign out',    href: signout_path) }
      scenario { should_not have_link('Sign in', href: signin_path) }

      feature "followed by signout" do
        before { click_link "Sign out" }
        scenario { should have_link('Sign in') }
      end
    end
  end

  feature "authorization" do

    feature "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      feature "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in 'signin_email',    with: user.email.upcase
          fill_in 'signin_password', with: user.password
          click_button 'signin_button'
        end

        feature "after signing in" do

          scenario "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      feature "in the Users controller" do

        feature "visiting the edit page" do
          before { visit edit_user_path(user) }
          scenario { should have_title('Sign in') }
        end

        feature "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
          it { should_not have_selector('div.alert.alert-notice', text: 'Need to be logged in') }
        end

        feature "visiting the user index" do
          before { visit users_path }
          scenario { should have_title('Sign in') }
        end
      end
    end

    feature "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      feature "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        scenario { should_not have_title(full_title('Edit user')) }
      end

      feature "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    feature "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      feature "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end


