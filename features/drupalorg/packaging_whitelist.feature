@whitelist @anon
Feature: View the list of Packaging whitelist entries
  In order to learn if an external library has already been whitelisted
  As any user
  I should be able browse the list and search for specific library

  @failing
 Scenario: View the list of items
    Given I am on "/project/drupalorg_whitelist"
    When I follow "list of existing whitelist entries"
    Then I should see the heading "Packaging whitelist URLs"
    And I should be on "/packaging-whitelist"
    And I should see at least "25" records
    And I should see the following <texts>
      | texts                                                                                          |
      | To request changes to this list, visit the Drupal.org Library Packaging Whitelist project page |
      | Search Packaging Whitelists                                                                    |
      | Whitelist name                                                                                 |
      | Allowed URL filters                                                                            |
    And I should see the link "next"
    And I should see the link "last"
    And I should not see the link "first"
    And I should not see the link "previous"

  Scenario: Navigate to one of the items
    Given I am on "/packaging-whitelist"
    When I follow "ARC2"
    Then I should see the heading "ARC2"
    And I should see "Posted by"
    And I should not see "Page not found"

  Scenario: View list of itmes: Second/Last page
    Given I am on "/packaging-whitelist"
    When I click on page "2"
    Then I should not see "Page not found"
    And I should see at least "15" records
    And I should see the heading "Packaging whitelist URLs"
    And I should see the link "first"
    And I should see the link "previous"
    And I should see the link "next"
    And I should see the link "last"

  Scenario: Search the list
    Given I am on "/packaging-whitelist"
    When I fill in "Search Packaging Whitelists" with "ARC2"
    And I press "Apply"
    Then I should see "ARC2"
    And I should not see "Aloha Editor"
    And I should not see "No whitelists have been created"
