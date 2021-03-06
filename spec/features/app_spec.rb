require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_on "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "As a user, I can click on the edit button" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_on "Submit"


    click_on "Edit"

    expect(page).to have_content("Edit")

    fill_in "Message", :with => "Hello how are you?"

    click_on "Edit Message"

    expect(page).to have_content("Hello how are you?")
  end

  scenario "User cannot update with more thean 140 carachters" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    click_on "Edit"

    fill_in "Message", :with => "a" * 141

    click_button "Edit Message"

    expect(page).to have_content("Message must be less than 140 characters.")


  end

  scenario "User can delete messages" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_on "Submit"

    expect(page).to have_content("Delete")

    click_on "Delete"

    expect(page).to_not have_content("Hello Everyone!")
  end

  scenario "User can comment on messages" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_on "Submit"

    click_on "Comment"

    expect(page).to have_content("Leave a comment")

    fill_in "Comment", :with => "Good one!"

    click_on "Leave Comment"

    expect(page).to have_content("Good one!")


  end
end
