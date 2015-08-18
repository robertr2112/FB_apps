require 'rails_helper'

feature "User pages" do

  subject { page }

  feature "index" do
    let (:user){ FactoryGirl.create(:user) }

    before do
      signin_login user
      visit users_path
    end

    scenario { should have_title('All users') }
    scenario { should have_content('All users') }

    feature "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      scenario { should have_selector('div.pagination') }

      scenario "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    feature "delete links" do
      let (:user2) { FactoryGirl.create(:user) }

      scenario { expect(page).not_to have_link('delete', href: user_path(user2)) }

      feature "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          signin_login admin
          visit users_path
        end

        scenario { expect(page).to have_link('delete', href: user_path(user)) }
        scenario "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        scenario { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  feature "index" do
    before do
      signin_login FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    scenario { should have_title('All users') }
    scenario { should have_content('All users') }

    scenario "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
  end

  feature "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    scenario { should have_content(user.name) }
    scenario { should have_title(user.name) }
  end

  feature "signup page" do
    before { visit signup_path }

    scenario { should have_content('Sign up') }
    scenario { should have_title(full_title('Sign up')) }
  end
  feature "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    feature "with invalid information" do
      scenario "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      feature "after submission" do
        before { click_button submit }

        scenario { should have_title('Sign up') }
        scenario { should have_content('error') }
      end
    end

    feature "with valid information" do
      before do
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      scenario "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      feature "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        scenario { should have_title(user.name) }
        scenario { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  feature "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      signin_login(user)
      visit edit_user_path(user)
    end

    feature "page" do
      scenario { should have_content("Update your profile") }
      scenario { should have_title("Edit user") }
      scenario { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    feature "with invalid information" do
      before { click_button "Save changes" }

      scenario { should have_content('error') }
    end

    feature "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      scenario { should have_title(new_name) }
      scenario { should have_selector('div.alert.alert-success') }
      scenario { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end

