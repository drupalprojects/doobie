@user @profile
Feature: Drupal information in user profile
  In order to let everyone know what I am doing in Drupal
  As an authenticated user
  I should be able to edit my profile and fill in Drupal information

  @failing
  Scenario: Trusted User sets Drupal information
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    And I follow "Edit"
    And I follow "Drupal" tab
    When I fill in "Drupal contributions" with random text
    And I fill in "Roles in working with Drupal" with random text
    And I press "Save"
    Then I should see "The changes have been saved"

  @dependent @failing
  Scenario: View Drupal information on profile page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    When I follow "Logged in as Trusted User"
    Then I should see the heading "Trusted User"
    And I should see "Drupal contributions"
    And I should see the random "Drupal contributions" text
    And I should see "Roles in working with Drupal"
    And I should see the random "Roles in working with Drupal" text

  @failing
  Scenario: Trusted User sets Drupal contribution checkboxes
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    And I follow "Edit"
    And I follow "Drupal" tab
    When I check the box "I contributed Drupal modules"
    And I check the box "I give support on IRC"
    And I check the box "I attended DrupalCon Boston 2008"
    And I press "Save"
    Then I should see "The changes have been saved"
    And the "I contributed Drupal modules" checkbox should be checked
    And the "I contributed Drupal patches" checkbox should not be checked
    And the "I attended DrupalCon Boston 2008" checkbox should be checked
    And the "I give support on IRC" checkbox should be checked

  @dependent @failing
  Scenario: View checked Drupal contribution on profile page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    When I follow "Logged in as Trusted User"
    Then I should see the heading "Trusted User"
    And I should see "Roles in working with Drupal"
    And I should see the following <links>
      | links                            |
      | I contributed Drupal modules     |
      | I give support on IRC            |
      | I attended DrupalCon Boston 2008 |

  @dependent @timeout @failing
  Scenario Outline: Follow Drupal contribution links from profile page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    When I follow "<link>"
    Then I should be on "<path>"
    And I should see the heading "<text>"
    And I should see the link "Trusted User"

  Examples:
    | link                             | path                                    | text                                      |
    | I contributed Drupal modules     | profile/profile_drupal_module_developer | People who contributed Drupal modules     |
    | I give support on IRC            | profile/profile_drupal_support_irc      | People who give support on IRC            |
    | I attended DrupalCon Boston 2008 | profile/conference-boston-2008          | People who attended DrupalCon Boston 2008 |
