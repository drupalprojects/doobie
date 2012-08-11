Feature: To view an individual commit
  In order to see the commit information
  As a user
  I should got to the commit log page and click on any commit date

  Scenario: View the commit information
    Given I am on "/commitlog"
    When I click on "date" of a commit
    Then I should see "Author date:"
    And I should see "Custom text:"
    And I should see "Commit"
    And I should see at least "1" files in the list
    And I should see at least "1" "plus" symbol
    And I should see at least "1" "minus" symbol
    And I should see the commit message

  Scenario: Click link on commit information page
    Given I am on "/commitlog"
    When I click on "date" of a commit
    And I click on "commit info" of a commit
    Then I should see "summary"
    And I should see "committer"

  Scenario: Click link on user name
    Given I am on "/commitlog"
    When I click on "date" of a commit
    And I click on "user name" of a commit
    Then I should see the heading "Personal information"
    And I should see "Full name"

  Scenario: Click link on file name
    Given I am on "/commitlog"
    When I click on "date" of a commit
    And I click on "file name" of a commit
    Then I should see "blob"
    And I should see "For more information about this repository"
