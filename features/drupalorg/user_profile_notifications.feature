@user @content @wip
Feature: Manage email notification settings
  In order to choose which notifications I want to receive
  As an authenticated user
  I should be able to update my notification settings

  Background:
    Given I am logged in as "site user"
    And I follow "Notifications"

  Scenario: View Notifications tab contents
    Then I should see the heading "Issue e-mail notifications"
    And I should see the following <texts>
    | texts                                   |
    | Project                                 |
    | Send e-mail                             |
    | Operations                              |
    | Default notification                    |
    | Customize for individual projects below |
    And I should see the option "None" selected in "Default notification" dropdown

  Scenario: Subscribe to project: Invalid project title
    When I enter "doobie" for field "Project title"
    And I press "Save"
    Then I should see "The name you entered (doobie) is not a valid project"
    But I should not see "Your notification settings have been updated"

  Scenario: Subscribe to project and delete it
    When I enter "Drupal.org BDD" for field "Project title"
    And I press "Save"
    And I see "Your notification settings have been updated"
    And I follow "delete"
    Then I should see "Deleted notification settings for Drupal.org BDD."
    But I should not see "Your notification settings have been updated"
    And I should not see "The name you entered (Drupal.org BDD) is not a valid project"
