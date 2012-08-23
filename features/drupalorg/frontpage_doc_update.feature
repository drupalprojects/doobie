Feature: Verify document list update on homepage
  In order to see the newly created document on home page
  As a site user
  I should create a book page document

  Background:
    Given I am logged in as "site user"
    And I follow "Documentation"
    And I follow "Understanding Drupal"

    Scenario: Add a child page: Minimal input
      When I follow "Add child page"
      And I fill in "Title:" with "Site user test page - 1"
      And I fill in "Body:" with "Site user test page body content goes here. Site user test page body content goes here."
      And I press "Save"
      And I follow "Drupal Homepage"
      And I follow "Docs Updates"
      Then I should see the link "Site user test page - 1"
      And I should see "Posted by site user"

    Scenario: Add a child page: Fill all the fields
      When I follow "Add child page"
      And I fill in "Title:" with "Site user test page - 2"
      And I select "Drupal 6.x" from "Drupal version"
      And I select "Advanced" from "Level"
      And I select "Site users" from "Audience"
      And I fill in "Keywords" with random text
      And I select "No known problems" from "Page status"
      And I fill in "Body" with "Site user test page body content goes here. Site user test page body content goes here."
      And I press "Save"
      And I follow "Drupal Homepage"
      And I follow "Docs Updates"
      Then I should see the link "Site user test page - 2"
      And I should see "Posted by site user"
