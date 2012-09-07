@wip
Feature: To view an individual commit
  In order to see the commit information
  As a user
  I should got to the commit log page and click on any commit date

  Scenario: View the commit information
    Given I am on "/commitlog/commit/42703/1cfeb9aa07128d38d75ae2cc06587c6b97834e5b"
    Then I should see "Author date:"
    And I should see "Custom text:"
    And I should see "Commit"
    And I should see at least "1" files in the list
    And I should see at least "1" "plus" symbol
    And I should see the commit message

  Scenario: Click link on commit information page
    Given I am on "/commitlog/commit/42703/1cfeb9aa07128d38d75ae2cc06587c6b97834e5b"
    When I follow "1cfeb9a"
    Then I should see "summary"
    And I should see "committer"

  Scenario: Click link on user name
    Given I am on "/commitlog/commit/42703/1cfeb9aa07128d38d75ae2cc06587c6b97834e5b"
    When I follow "eliza411"
    Then I should see the heading "Personal information"
    And I should see "Full name"

  Scenario: Click link on file name
    Given I am on "/commitlog/commit/42703/1cfeb9aa07128d38d75ae2cc06587c6b97834e5b"
    When I follow "/tb2y8x6u8phtfypa.info"
    Then I should see "blob"
    And I should see "For more information about this repository"

  Scenario: Check for unverified commit
    Given I am on "/commitlog/commit/37412/d54c6ba4b3b04a1b05bda70dc85ad9135430e3c1"
    Then I should not see the link "eliza411"
    And I should see "Melissa Anderson"
    And I should see the heading "Commit d54c6ba4b3b04a1b05bda70dc85ad9135430e3c1"
