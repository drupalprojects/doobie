@javascript
Feature: Selectively display case studies
  In order to choose which case studies appear where
  As a site administrator
  I need to be able to set their status

  Scenario Outline: User cannot feature own case study
    Given I am logged in as "<user>"
    And I visit "case-studies"
    And I click "Add your case study"
    When I fill in "Project name" with random text
    And I attach the file "koala.jpg" to "Primary screenshot" 
    And I fill in "Why Drupal was chosen" with random text
    And I fill in "http://example.com" for "Completed Drupal site or project URL"
    And I fill in "Views" for "edit-field-module-0-nid-nid"
    And I fill in "Why these modules/theme/distribution were chosen" with random text
    And I press "Save"
    And I click "Edit"
    Then I should not see "edit-field-status-value-Community"
    And I should not see "edit-field-status-value-Featured"
    And I should not see "edit-field-status-value-Hidden"
    
    Examples:
    | user       |
    | admin test |
    | site user  |
 

   Scenario: Admin user can feature other people's case study
     Given I am logged in as "admin test"
     When I visit "/node/1726722/edit"
     And I check "Featured"
     And I press "Save"
     And I follow "Featured showcase"
     Then I should see "Under.me"
     
   Scenario: Admin user can hide a case study
     Given I am logged in as "admin test"
     When I visit "/node/1726722/edit"
     And I check "Hidden"
     And I press "Save"
     And I follow "Featured showcase"
     Then I should not see "Under.me"

   @wip
   Scenario: Admin user can put study on community showcase
     Given I am logged in as "admin test"
     When I visit "/node/1726722/edit"
     And I check "edit-field-status-value-Community"
     And I press "Save"
     And I follow "Community showcase" 
     Then I should see "Under.me"

