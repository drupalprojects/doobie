Feature: View Drupal case studies as authenticated user
  In order to add a Drupal case studies
  As an authenticated user
  I want to look for a link on the case studies page and add one

  @javascript
  Scenario: Add a new case study
    Given I am on "/case-studies"
    When I login to the site
    Then I follow "Add your case study"
    And I select "Arts" from "Sectors"
    And I fill in the following:
    | Project name | Sundar case study five |
    | Why Drupal was chosen | Sundar case study five test data |
    | Brief overview | Sundar case study five test data brief overview |
    | Completed Drupal site or project URL | google.com |
    | Why these modules/theme/distribution were chosen | Sundar case study five test data |
    And I attach the file "D:\Users\kssundar\Downloads\sample\images\plugins.jpg" to "Primary screenshot"
    And I enter "Features" for field "Key modules/theme/distribution used"
    And I press "Save"
    Then I should see "Sundar case study five"
