@docs @wip
Feature: Prevent users from editing certain pages
  In order to limit changes to certain important documentation pages
  As a site user
  I should not be able to edit pages that were locked by a privileged user  

  Background:
    Given I am logged in as "site user"

  Scenario:Site user tries to find the Edit link
    When I visit "/coding-standards"
    Then I should not see the link "Edit" 

  Scenario: Site user tries to edit a page directly
    When I go to "/node/318/edit"
    Then I should see "Access Denied"
    And I should see "You are not authorized to access this page"
    And I should not get a "200" HTTP response
    But I should get a "403" HTTP response

