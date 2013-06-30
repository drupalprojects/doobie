@casestudies 
Feature: Adding new case study
  In order to share the story of the site I built with Drupal
  As an authenticated user
  I should be able to create new case study

  Background:
    Given I am logged in as "site user"
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

  @javascript @wip
  Scenario: Add a new case study
    When I follow "Add your case study"
    And I see "Describe the project"
    And I attach the local file "koala.jpg" to "Primary screenshot"
    And I select "Arts" from "Sectors"
    And I additionally select "Education" from "Sectors"
    And I additionally select "Community" from "Sectors"
    And I fill in "Project name" with random text
    And I fill in the following:
    | Why Drupal was chosen                            | Test data one test case study                  |
    | Brief overview                                   | Test data two brief overview test case study   |
    | Completed Drupal site or project URL             | example.com                                    |
    | Why these modules/theme/distribution were chosen | Test data three test case study                |
    And I enter "Features" for field "Key modules/theme/distribution used"
    And I select "Features" from the suggestion "Key modules/theme/distribution used"
    And I press "Save"
    Then I should see "has been created"
    And I should see that the tab "Community showcase" is highlighted
    And I should see the following <texts>
    | texts           |
    | Test data one   |
    | Test data two   |
    | Test data three |
    And I should see the following <links>
    | links           |
    | Arts            |
    | Education       |
    | Community       |
    | Features        |
    | example.com     |
    | site user       |
    | Add new comment |
    And I should see "Edit"

  @wip // This does not seem valuable
  Scenario: Edit own case study
    When I follow "Community showcase"
    And I click on a case study
    And I follow "Edit"
    Then I should not see "Access denied"
    And I should see the following <texts>
    | texts                 |
    | Project name          |
    | Primary screenshot    |
    | Sectors               |
    | Why Drupal was chosen |
    | Brief overview        |

  Scenario: Comment on a case study
    When I click on a case study
    And I follow "Add new comment"
    And I fill in "Subject" with random text
    And I fill in "Comment" with random text
    And I press "Save"
    Then I should see the random "Subject" text
    And I should see the random "Comment" text
    And I should see "Posted by site user"
    And I should see the link "Add new comment"

  Scenario: View case study guidelines
    When I follow "Case Study guidelines"
    Then I should see the heading "Case Study guidelines"
    And I should see "How to write a case study"
    And I should see the following <links>
    | links                  |
    | View                   |
    | Edit                   |
    | Revisions              |
    | Drupal Case Studies    |
    | Getting Involved Guide |

  Scenario: View Add case study link in Community showcase
    When I visit "/case-studies/all"
    Then I should see the heading "Drupal Case Studies"
    And I should see the link "Add your case study"
    And I should see the link "Case Study guidelines"
