@project @anon
Feature: Project Development Block
  In order to get the information about code development
  As a visitor
  I need to be able to access links in the Development block

  Background:
    Given I am on "/project/views"

  @failing
  Scenario: View links in Development block
    Then I should see the heading "Development"
    And I should see the following <links>
      | links                   |
      | View pending patches    |
      | Browse code repository  |
      | View commits            |
      | Report a security issue |
      | View change records     |
    And I should not see the link "Sandbox security policy"

  @failing
  Scenario: View pending patches
    When I follow "View pending patches"
    Then I should see the heading "Issues for Views"

  @failing
  Scenario: View Repository
    When I follow "Browse code repository"
    Then I should not see "Page not found"
    And I should see the following <links>
      | links      |
      | shortlog   |
      | log        |
      | commit     |
      | commitdiff |
      | tree       |
      | snapshot   |
      | tags       |
      | heads      |
    And I should see the following <texts>
      | texts       |
      | description |
      | owner       |
      | drupal-git  |
      | last change |
      | search:     |
      | summary     |

  @failing
  Scenario: View Commits
    When I follow "View commits"
    Then I should see "Commits for"
    And I should see at least "2" records
    And I should see the following <texts>
      | texts              |
      | Commit             |
      | commits            |
      | Issue #            |
      | Subscribe with RSS |
    And I should see the link "next"
    And I should not see the link "first"
    And I should not see the link "previous"

  @changerecords
  Scenario: View change records
    When I follow "View change records"
    Then I should see "Change records"
    And I should see the following <texts>
      | texts                |
      | Keywords             |
      | Introduced in branch |
      | Impacts              |
