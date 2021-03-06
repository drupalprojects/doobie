@casestudies
Feature: Adding new case study
  In order to share the story of the site I built with Drupal
  As an authenticated user
  I should be able to create new case study

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    And I visit "/case-studies"

  Scenario: View the texts and links on the page
    Then I should see the heading "Drupal Case Studies"
    And I should see the link "Add your case study"
    And I should see the link "Case Study guidelines"

  Scenario: Add a new case study: Required field validation
    When I follow "Add your case study"
    And I press "Save"
    Then I should see the following <texts>
      | texts                                                              |
      | Project name field is required                                     |
      | Why Drupal was chosen field is required                            |
      | URL field is required                                              |
      | Why these modules/theme/distribution were chosen field is required |
      | Primary screenshot field is required                               |
    And the field "Project name" should be outlined in red
    And the field "Why Drupal was chosen" should be outlined in red
    And I should not see "has been created"

  @javascript @failing
  Scenario: Add a new case study
    When I follow "Add your case study"
    And I wait until the page loads
    And I see "Describe the project"
    And I fill in "Project name" with random text
    And I attach the local file "koala.jpg" to "edit-field-mainimage-und-0-upload"
    And I select "Arts" from "Sectors"
    And I additionally select "Education" from "Sectors"
    And I additionally select "Community" from "Sectors"
    And I fill in "URL" with "example.com"
    And I fill in the following:
      | Why Drupal was chosen                            | Test data one test case study                |
      | Brief overview                                   | Test data two brief overview test case study |
      | Why these modules/theme/distribution were chosen | Test data three test case study              |
    And I enter "Features" for field "Key modules/theme/distribution used"
    And I wait for the suggestion box to appear
    And I select "Features" from the suggestion "Key modules/theme/distribution used"
    And I press "Save"
    Then I should see "has been created"
    And I should see that the tab "Community showcase" is highlighted
    And I should see the following <texts>
      | texts           |
      | Test data one   |
      | Test data two   |
      | Test data three |
    And I should see "Edit"

  Scenario: Comment on a case study
    When I click on a case study
    And I follow "Add new comment"
    And I fill in "Subject" with random text
    And I fill in "Comment" with random text
    And I press "Save"
    Then I should see the random "Subject" text
    And I should see the random "Comment" text
    And I should see "Confirmed User commented"
    And I should see the link "Add new comment"

  @content
  Scenario: View case study guidelines
    When I follow "Case Study guidelines"
    Then I should see the heading "Case Study guidelines"
    And I should see "How to write a case study"
    And I should see the following <links>
      | links                     |
      | View                      |
      | Edit                      |
      | Revisions                 |
      | How to write a case study |
      | Getting involved          |

  Scenario: View Add case study link in Community showcase
    When I visit "/case-studies/all"
    Then I should see the heading "Drupal Case Studies"
    And I should see the link "Add your case study"
    And I should see the link "Case Study guidelines"
