Feature:
  In order to allow authorized users to upload files while creating a Forum Topic
  As a user with content admin permissions
  I need to be able to check file upload is permitted

  Scenario: Check File Attachments is not available for site user
    Given I am logged in as "admin test"
    When I follow "Support"
    And I follow "Forums"
    And I follow "Post new Forum topic"
    Then I should see "File attachments"
    And I should see "Attach new file:"