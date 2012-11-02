@other @anon
Feature: Drupal.org privacy policy
  In order to find out about Drupal.org privacy policy
  As any user
  I should be able to view the page

  Scenario: View the page
    Given I am on "/privacy"
    Then I should see the heading "Drupal.org's Privacy Policy"
    And I should see "This policy covers"
    And I should see "All information that you disclose"
    And I should see "This policy may change"
