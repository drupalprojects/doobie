@docs @wip
Feature: Prevent users from editing certain pages
  In order to limit changes to certain important documentation pages
  As a site user
  I should not be able to edit pages that were locked by a privileged user

  Scenario: Docs manager creates a document
    Given I am logged in as "docs manager"
    When I visit "/documentation/install"
    And I follow "Add child page"
    And I create a book page with full html
    Then I should see "has been created"

  @dependent
  Scenario: Site user tries to find the Edit link on the above book page
    Given I am logged in as "site user"
    When I visit "/documentation/install"
    And I follow the book page
    Then I should not see the link "Edit"

  @dependent @clean_data
  Scenario: Site user tries to edit a page directly
    Given I am logged in as "site user"
    When I go to the document edit page
    Then I should see "Access Denied"
    And I should see "You are not authorized to access this page"
    And I should not get a "200" HTTP response
    But I should get a "403" HTTP response
