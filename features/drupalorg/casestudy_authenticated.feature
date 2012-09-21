Feature: View Drupal case studies as authenticated user
  In order to add a Drupal case studies
  As an authenticated user
  I want to look for a link on the case studies page and add one

  Background:
    Given I am logged in as "site user"
    And I visit "/case-studies"

  Scenario: Verify this page
    Then I should see the heading "Drupal Case Studies"
    And I should see the heading "Browse by category"
    And I should see the link "Add your case study"
    And I should see the link "Case Study guidelines"

  @javascript
  Scenario: Add a new case study
    When I follow "Add your case study"
    And I wait "3" seconds
    And I attach the file "koala.jpg" to "Primary screenshot:"
    And I select "Arts" from "Sectors"
    And I additionally select "Education" from "Sectors"
    And I additionally select "Community" from "Sectors"
    And I fill in "Project name" with random text
    And I fill in the following:
    | Why Drupal was chosen                            | Test case study seven test data                |
    | Brief overview                                   | Test case study seven test data brief overview |
    | Completed Drupal site or project URL             | google.com                                     |
    | Why these modules/theme/distribution were chosen | Test case study seven test data                |
    And I enter "Features" for field "Key modules/theme/distribution used"
    And I select "Features" from the suggestion "Key modules/theme/distribution used"
    And I press "Save"
    Then I should see "has been created"

  Scenario: Case study guidelines link
    When I follow "Case Study guidelines"
    Then I should see the heading "Case Study guidelines"
    And I should see the following <links>
    | links                  |
    | View                   |
    | Edit                   |
    | Revisions              |
    | Drupal Case Studies    |
    | Getting Involved Guide |

  Scenario: Case study - All
    When I visit "/case-studies/all"
    Then I should see the heading "Drupal Case Studies"
    And I should see the heading "Browse by category"
    And I should see the link "Add your case study"
    And I should see the link "Case Study guidelines"
