@ci @git @commitlog
Feature: To view an individual commit
  In order to see the commit information of a particular commit
  As a user
  I should go to the individual commit details page

  @smoke
  Scenario: View the commit information: Few information
    Given I am on "/commitlog/commit/43232/ca9a5dca5fb6f4b34839a5bf21b44b163f060e78"
    Then I should see "on master"
    And I should see "Commit"
    And I should see at least "1" files in the list
    And I should see at least "1" "plus" symbol
    And I should see the commit message

  Scenario: View the commit information: More info
    Given I am on "/commitlog/commit/43232/a2d746d3d26f64771108aab11b4d5a75f621db3b"
    Then I should see "on master"
    And I should see "Commit"
    And I should see "by sachin2dhoni"
    And I should see the link "sachin2dhoni"
    And I should see at least "4" files in the list
    And I should see at least "4" "plus" symbol
    And I should see at least "1" "minus" symbol
    And I should see the commit message

  @failing
  Scenario: Click link on commit information page
    Given I am on "/commitlog/commit/43232/65c565d3f47412b1d37a9e47afff66e0f7dc1b70"
    When I follow "65c565d"
    Then I should see "Added new module file"
    And I should see "committer"

  Scenario: Click link on user name
    Given I am on "/commitlog/commit/43232/12766a6649db2ee24cffd3bcc0f48827956ddd12"
    When I follow "ksbalajisundar"
    Then I should see the heading "Personal information"
    And I should see "Full name"

  @failing
  Scenario: Click link on file name
    Given I am on "/commitlog/commit/43232/a5b40fb414ad9eef9dbc8e9f1360fb3d50bfdf8e"
    When I follow "/bdd_sandbox_test_project_please_do_not_delete_this.info"
    Then I should see "blob"
    And I should see "For more information about this repository"

  Scenario: View unverified commit
    Given I am on "/commitlog/commit/43232/31963037a3856da31d5e24c15d7eded32553955d"
    Then I should not see the link "ksbalajisundar"
    And I should see "by K S Sundarrajan Iyengar"
    And I should see the heading "Commit 31963037a3856da31d5e24c15d7eded32553955d"
