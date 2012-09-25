Feature: Selectively display case studies
  In order to choose which case studies appear where
  As a site administrator
  I need to be able to set their status

  @javascript
  Scenario: Create a case study as a site user
    Given I am logged in as "site user"
    And I visit "/node/add/casestudy"
    When I create a case study
    And I see the case study page
    And I visit "/case-studies/all"
    Then I should see the random "Project name" text

  @dependent
  Scenario: Edit the case study created and status field should not be present
    Given I am logged in as "site user"
    And I visit the case study page
    When I follow "Edit"
    Then I should not see "Status:"
    And I should not see "Choose \"Featured\" to promote case study to \"Featured showcase\" section."

  @dependent
  Scenario: Admin user can feature other people's case study
    Given I am logged in as "admin test"
    And I am on the case study page
    When I follow "Edit"
    And I check "Featured" radio button
    And I press "Save"
    And I follow "Featured showcase"
    Then I should see the random "Project name" text

  @dependent
  Scenario: Admin user can hide a case study
    Given I am logged in as "admin test"
    And I am on the case study page
    When I follow "Edit"
    And I check "Hidden" radio button
    And I press "Save"
    And I follow "Featured showcase"
    Then I should not see the random "Project name" text

  @dependent @clean_data
  Scenario: Admin user can put case study on community showcase
    Given I am logged in as "admin test"
    And I am on the case study page
    When I follow "Edit"
    And I check "Community" radio button
    And I press "Save"
    And I follow "Community showcase"
    Then I should see the random "Project name" text
