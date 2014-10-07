@casestudies @wip
Feature: Case studies moderation
  In order to moderate case studies
  As a site administrator
  I need to be able to edit any case study and change their status

  Scenario: Create a case study as a trusted user
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I visit "/node/add/casestudy"
    When I create a case study
    And I see the case study page
    And I visit "/case-studies/all"
    Then I should see the random "Project name" text

  @dependent
  Scenario: Admin user can feature other people's case study
    Given I am logged in as the "admin test"
    And I am on the case study page
    When I follow "Edit"
    And I check "Featured" radio button
    And I press "Save"
    And I see "has been updated"
    And I follow "Featured showcase"
    Then I should see the random "Project name" text

  @dependent
  Scenario: Admin user can hide a case study
    Given I am logged in as the "admin test"
    And I am on the case study page
    When I follow "Edit"
    And I check "Hidden" radio button
    And I press "Save"
    And I follow "Featured showcase"
    Then I should not see the random "Project name" text
    And I visit "/case-studies/hidden"
    Then I should see the random "Project name" text

  @dependent @clean_data
  Scenario: Admin user can put case study on community showcase
    Given I am logged in as the "admin test"
    And I am on the case study page
    When I follow "Edit"
    And I check "Community" radio button
    And I press "Save"
    And I follow "Community showcase"
    Then I should see the random "Project name" text

  @clean_data
  Scenario: Can't edit until moderated
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I visit "/node/add/casestudy"
    And I create a case study
    When I follow "Edit"
    Then I should not see "Status"
    And I should not see "Choose \"Featured\" to promote case study to \"Featured showcase\" section."
    But I should see "Project name"
    And I should see "Brief overview"
    And I should see "Community contributions"
