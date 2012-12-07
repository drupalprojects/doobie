@user @wip
Feature: Work information in user profile
  In order to share information about my current and past jobs
  As an authenticated user
  I should be able to edit my profile and fill in work information

  Scenario: Update work information
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Profile"
    And I follow "Edit"
    And I follow "Work"
    When I fill in "Job title" with random text
    And I fill in "Industries worked in" with random text
    And I fill in "Companies worked for" with random text
    And I fill in "Current company or organization" with random text
    And I fill in "Company or organization size" with random text
    And I press "Save"
    Then I should see "The changes have been saved"

  Scenario: View work information as site user
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Profile"
    Then I should see the heading "site user"
    And I should see the heading "Work"
    And I should see the random "Job title" text
    And I should see the random "Industries worked in" link
    And I should see the random "Companies worked for" link
    And I should see the random "Current company or organization" link
    And I should see the random "Company or organization size" text

  Scenario Outline: Visit the links in work information
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Profile"
    When I visit the random link for "<fields>"
    Then I should see "<texts>"
    And I should see the random "<fields>" text
    And I should see the link "site user"
    Examples:
    | fields                          | texts                           | 
    | Industries worked in            | People that have worked in the  |
    | Companies worked for            | People that have worked for     |
    | Current company or organization | People who currently work for   |

  Scenario: Reset work information
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Profile"
    And I follow "Edit"
    And I follow "Work"
    When I fill in "Job title" with ""
    And I fill in "Industries worked in" with ""
    And I fill in "Companies worked for" with ""
    And I fill in "Current company or organization" with ""
    And I fill in "Company or organization size" with ""
    And I press "Save"
    Then I should see "The changes have been saved"