@git
Feature: Choose git username
  In order to start using Git
  As an authenticated user
  I need to choose my git username and agree to Git access agreement

  @clean_data @failing
  Scenario: Choose git username
    Given I am logged in as a new user
    And I am on "/user"
    When I click "Edit"
    And I click "Git access"
    And I see "You will not be able to use Git"
    And I fill in "Desired Git username" with random text
    And I press "Save"
    And I press "Confirm"
    Then I should see "Git access agreement"
    And I should see "Your Git username"
    And I should see the random "Desired Git username" text
    And the checkbox "I agree to these terms" should be unchecked
