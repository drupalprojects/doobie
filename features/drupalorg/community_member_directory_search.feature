@community @anon
Feature: Search members in drupal community
  In order to find members of the community
  As any user
  I should be able to search for members in the member directroy

  Scenario: View search block in the right sidebar region
    Given I am on "/community"
    When I follow "Member Directory"
    Then I should see the text "Search Users" in the "right sidebar" region
    And I should see the text "Find Groups Near You" in the "right sidebar" region
    And I should see the text "Username" in the "right sidebar" region

  Scenario: Search for member: Blank
    Given I am on "/profile"
    When I press "Search" in the "right sidebar" region
    Then I should see "Please enter some keywords"
    And I should see the heading "Search"
    And I should see "Enter your keywords"
    And I should not see "Your search yielded no results"

  Scenario: Search for member: Invalid user
    Given I am on "/profile"
    When I fill in "a long username here" for "Username:"
    And I press "Search" in the "right sidebar" region
    Then I should see "Your search yielded no results"
    And I should not see "Please enter some keywords"
    And I should see the heading "Users"
    And I should see "Enter your keywords"

  Scenario: Search for member: Valid user
    Given I am on "/profile"
    When I fill in "site user" for "Username"
    And I press "Search" in the "right sidebar" region
    Then I should see at least "1" record
    And I should see "results containing the words: site user"
    But I should not see "Your search yielded no results"
    And I should not see "Please enter some keywords"

  Scenario: Search for members: Valid user
    Given I am on "/profile"
    When I fill in "peter" for "Username"
    And I press "Search" in the "right sidebar" region
    Then I should see at least "15" records
    And I should see the link "next"
    And I should see the link "last"
    But I should not see "Your search yielded no results"
