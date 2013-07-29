@anon @content @changerecords
Feature: List and search change records
  In order to see the list of change records
  As anonymous/guest user
  I should be able to filter the list

  Scenario: Navigate to change list page see the default list
    Given I am on "/project/drupal"
    When I follow "View change records"
    Then I should see the heading "Change records for Drupal core"
    And I should see at least "40" records
    And I should see the following <texts>
    | texts                |
    | 1                    |
    | 2                    |
    | next                 |
    | last                 |
    | Keywords             |
    | Introduced in branch |
    And I should not see the following <texts>
    | texts    |
    | previous |
    | first    |

  Scenario: Search by keyword
    Given I am on "/list-changes/drupal"
    When I fill in "jquery" for "Keywords"
    And I press "Apply"
    Then I should see at least "1" record
    And I should see "Jquery"
    And I should not see "Invalid project or no changes found"

  Scenario: Search, filtering by 6.x version
    Given I am on "/list-changes/drupal"
    When I fill in "6.x" for "Introduced in version"
    And I press "Apply"
    Then I should see "Invalid project or no changes found"
    And I should not see the following <texts>
    | texts |
    | 6.x   |
    | 7.x   |
    | 8.x   |

  Scenario: Search, filtering by 7.x branch
    Given I am on "/list-changes/drupal"
    When I fill in "7.x" for "Introduced in branch"
    And I press "Apply"
    Then I should see "7.x"
    And I should not see the following <texts>
    | texts |
    | 6.x   |
    | 8.x   |
    And I should see at least "1" record

  Scenario: Search, filtering by 8.x version
    Given I am on "/list-changes/drupal"
    When I fill in "8.x" for "Introduced in version"
    And I press "Apply"
    Then I should see "8.x"
    And I should not see "7.x"

  Scenario: Search by entering values for Change node created dropdown: Is greater than
    Given I am on "/list-changes/drupal"
    When I select "Is greater than" from field "Change node created"
    And I enter "08-Jul-2012" for field "created date"
    And I press "Apply"
    Then I should not see "08-Jul-2012"
    And I should see at least "1" record

  @javascript
  Scenario: Search by entering values for Change node created dropdown: Is between
    Given I am on "/list-changes/drupal"
    When I select "Is between" from field "Change node created"
    And I enter "1-Jul-2012" for field "start date"
    And I enter "15-Jul-2012" for field "end date"
    And I press "Apply"
    Then I should see at least "1" record
    And I should not see "Invalid project or no changes found"

  Scenario Outline: Search by selecting for Impacts dropdown
    Given I am on "/list-changes/drupal"
    When I select "<value>" from "Impact"
    And I press "Apply"
    Then I should see at least "10" records
    And I should not see "Invalid project or no changes found"
    Examples:
    | value                                  |
    | Site builders, administrators, editors |
    | Module developers                      |
    | Themers                                |

  Scenario: Navigate through pagination links: Third page
    Given I am on "/list-changes/drupal?page=2"
    Then I should see at least "40" records
    And I should see the following <texts>
    | texts    |
    | 1        |
    | 2        |
    | first    |
    | previous |
    | next     |
    | last     |
    But I should not see "Invalid project or no changes found"

  Scenario: Navigate through pagination links: Last page
    Given I am on "/list-changes/drupal?page=2"
    When I click on page "last"
    Then I should see at least "10" records
    And I should see the following <texts>
    | texts    |
    | 1        |
    | 2        |
    | previous |
    | first    |
    And I should not see the following <texts>
    | texts    |
    | next     |
    | last     |

  Scenario: Enter values in all the fields and search
    Given I am on "/list-changes/drupal"
    When I fill in "language" for "Keywords"
    And I fill in "8.x" for "Introduced in branch"
    And I fill in "8.x" for "Introduced in version"
    And I select "Is greater than or equal to" from field "Change node created"
    And I enter "01-Jun-2012" for field "created date"
    And I select "Themers" from "Impact"
    And I additionally select "Site builders, administrators, editors" from "Impact"
    And I additionally select "Module developers" from "Impact"
    And I press "Apply"
    Then I should see at least "2" records
    But I should not see "Invalid project or no changes found"

  Scenario: Add new change record as anonymous user
    Given I am on "/list-changes/drupal"
    When I follow "Add new change record"
    Then I should see "You are not authorized to access this page"
    And I should see the heading "Access denied"
    But I should not see "Create Change record"

  Scenario Outline: Search by entering words to get no results
    Given I am on "/list-changes/drupal"
    When I fill in "<fieldname>" with "blahblah"
    And I press "Apply"
    Then I should see "Invalid project or no changes found"
    Examples:
    | fieldname             |
    | Introduced in branch  |
    | Introduced in version |
    | Keywords              |

  Scenario: Search by entering words to get no results: date
    Given I am on "/list-changes/drupal"
    When I fill in "" for "Keywords"
    And I select "Is equal to" from field "Change node created"
    And I enter "1-Jun-2012" for field "created date"
    And I press "Apply"
    Then I should see "Invalid project or no changes found"

  Scenario: Sort by Notice created
    Given I am on "/list-changes/drupal"
    When I click the table heading "Notice created"
    Then I should see "Notice created" sorted in "ascending" order
    And I click the table heading "Notice created"
    Then I should see "Notice created" sorted in "descending" order
