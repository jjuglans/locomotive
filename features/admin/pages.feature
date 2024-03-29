@site_up
@authenticated
Feature: Manage Skills
	In order to manage pages
	As an administrator
	I want to add/edit/delete pages of my site
	
Scenario: Pages list is not accessible for non authenticated accounts
  Given I am not authenticated
  When I go to pages
  Then I should see "Log in"

Scenario: Creating a valid page
  When I go to pages
  And I follow "new page"
  And I fill in "Title" with "Test"
  And I fill in "Slug" with "test"
  And I select "Home page" from "Parent"
  And I fill in "page_parts_attributes_0_value" with "Lorem ipsum...."
  And I press "Create"
  Then I should see "Page was successfully created."
  And I should have "Lorem ipsum...." in the test page layout

Scenario: Updating a valid page
  When I go to pages
  And I follow "Home page"
  And I fill in "Title" with "Home page !"
  And I fill in "page_parts_attributes_0_value" with "My new content is here"
  And I press "Update"
  Then I should see "Page was successfully updated."
  And I should have "My new content is here" in the index page layout