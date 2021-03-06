@project @sandbox @anon
Feature: Sandbox Project Development Block
  In order to get the information about code development
  As a visitor
  I need to be able to access links in the Development block

  Background:
    Given I am on "/sandbox/eliza411/1663360"

  @failing
  Scenario: View links in Development block
    Then I should see the heading "Development"
    And I should see the following <links>
      | links                   |
      | View pending patches    |
      | Browse code repository  |
      | View commits            |
      | Sandbox security policy |
      | View change records     |
    And I should not see the link "Report a security issue"

  @failing
  Scenario: View pending patches
    When I follow "View pending patches"
    Then I should see the text "Search issues for"

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
      | heads      |
    And I should not see the link "tags"
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
    And I should see the link "››"
    And I should not see the link "‹‹"

  @content
  Scenario: View Sandbox security policy
    When I follow "Sandbox security policy"
    Then I should see the heading "Security advisories process and permissions policy"
    And I should see the following <links>
      | links                        |
      | Security team                |
      | report the issue to the team |

  Scenario: View change records
    When I follow "View change records"
    Then I should see "Change records for"
    And I should see the following <texts>
      | texts                |
      | Keywords             |
      | Introduced in branch |
      | Impacts              |
