@community @forums
Feature:
  In order to restrict unauthorized users from uploading files while creating a Forum Topic
  As a site admin
  I need to know that file upload is only permitted to users with Administer content.

  Scenario: File Attachments is not available for regular site user
    Given I am logged in as "site user"
    When I follow "Support"
    And I follow "Forums"
    And I follow "Add new Forum topic"
    Then I should not see "File attachments"
    And I should not see "Add a new file"

  Scenario: File Attachments is available for admin
    Given I am logged in as "admin test"
    When I follow "Support"
    And I follow "Forums"
    And I follow "Add new Forum topic"
    Then I should see "File attachments"
    And I should see "Add a new file"
