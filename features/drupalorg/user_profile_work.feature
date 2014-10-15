@user @profile
Feature: Work information in user profile
  In order to share information about my current and past jobs
  As an authenticated user
  I should be able to edit my profile and fill in work information

  @failing
  Scenario: Update work information
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
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

  @failing
  Scenario: View work information as Trusted User
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Your Dashboard"
    And I follow "Profile"
    Then I should see the heading "Trusted User"
    And I should see the heading "Work"
    And I should see the random "Job title" text
    And I should see the random "Industries worked in" link
    And I should see the random "Companies worked for" link
    And I should see the random "Current company or organization" link
    And I should see the random "Company or organization size" text

  @failing
  Scenario Outline: Visit the links in work information
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Your Dashboard"
    And I follow "Profile"
    When I visit the random link for "<fields>"
    Then I should see "<texts>"
    And I should see the random "<fields>" text
    And I should see the link "Trusted User"
  Examples:
    | fields                          | texts                          |
    | Industries worked in            | People that have worked in the |
    | Companies worked for            | People that have worked for    |
    | Current company or organization | People who currently work for  |

  @failing
  Scenario: Reset work information
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
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
