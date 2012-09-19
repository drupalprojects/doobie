@javascript
Feature: Verify home page preference functionality
  In order to have quick access to dashboard and its related links
  As an authenticated user
  I need to be able to use my dashboard as my home page

  Background:
    Given I am logged in as "site user"
    And I follow "Your Dashboard"

  Scenario: Select dashboard as homepage and check dashboard has become the homepage
    When I click "Make this your Homepage" link
    And I click the drupal banner in the header
    Then I should see the heading "site user"
    And I should see the link "Add a block"
    And I should see the link "Use Default Homepage"
    And I should not see the link "Make this your Homepage"

  @revert_homepage_setting
  Scenario: Select default home page and check homepage is reverted to default homepage
    When I click "Use Default Homepage" link
    And I click the drupal banner in the header
    Then I should see the link "Why Choose Drupal?"
    And I should see the link "Sites Made with Drupal"
    And I should not see the link "Add a block"
