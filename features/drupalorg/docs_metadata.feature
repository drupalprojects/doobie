@docs
Feature:  Verify handbook metadata is displayed correctly
  In order to know the document creation/editing information
  As a community member
  I should be able to see the meta information displayed on the page in proper format

  Scenario: Create a documentation as Trusted User
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I follow "Documentation"
    And I follow "Installation Guide"
    And I follow "Add child page"
    When I create a book page
    Then I should see "has been created"

  @dependent
  Scenario: Edit the document as Git User
    Given I am logged in as the "git user"
    And I am on the document page
    And I follow "edit this page"
    When I edit the document
    Then I should see "has been updated"

  @dependent
  Scenario: Edit the document as Git Vetted User
    Given I am logged in as the "git vetted user"
    And I am on the document page
    And I follow "edit this page"
    When I edit the document
    Then I should see "has been updated"

  @dependent
  Scenario: Edit the document as docs manager
    Given I am logged in as the "docs manager"
    And I am on the document page
    And I follow "edit this page"
    When I edit the document
    Then I should see "has been updated"

  @dependent
  Scenario: Edit the document as Document Creator
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on the document page
    And I follow "edit this page"
    When I edit the document
    Then I should see "has been updated"

  @dependent
  Scenario: Edit the document again as Git User
    Given I am logged in as the "git user"
    And I am on the document page
    And I follow "edit this page"
    When I edit the document
    Then I should see "has been updated"

  @dependent
  Scenario: Edit the document as admin test user
    Given I am logged in as the "admin test"
    And I am on the document page
    And I follow "edit this page"
    When I edit the document
    Then I should see "has been updated"

  @dependent
  Scenario: Follow revisions tab and compare last updated date
    Given I am logged in as the "admin test"
    And I am on the document page
    When I follow "Revisions"
    Then the "last updated date" should match the latest revision

  @dependent
  Scenario: Follow revisions tab and view created user and created time
    Given I am logged in as the "admin test"
    And I am on the document page
    When I follow "Revisions"
    Then the "created by username" should match the first revision
    And the "created date" should match the first revision

  @clean_data @timeout @dependent
  Scenario: Edited usernames will be the latest four entries from revision tab and it doesn't include creator username or duplicates of the latest editors
    Given I am logged in as the "admin test"
    And I am on the document page
    When I follow "Revisions"
    Then the "editor usernames" should match the usernames in the revisions
    And I should not see "creator username" in editor usernames
    And I should not see "repeated usernames" in editor usernames
