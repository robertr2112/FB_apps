require 'rails_helper'

feature "Static pages" do

  subject { page }

  feature "Home page" do
    before { visit root_path }

    scenario { should have_content('Football Pool Mania') }
    scenario { should have_title(full_title('')) }
  end

  feature "Help page" do
    before { visit help_path }

    scenario { should have_content('Help') }
    scenario { should have_title(full_title('Help')) }
  end

  feature "About page" do
    before { visit about_path }

    scenario { should have_content('About') }
    scenario { should have_title(full_title('About Us')) }
  end

  feature "Contact page" do
    before { visit contact_path }

    scenario { should have_selector('h1', text: 'Contact') }
    scenario { should have_title(full_title('Contact')) }
  end
end
