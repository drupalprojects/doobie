Feature:
  In order to restrict unauthorized users from uploading files while creating a Forum Topic
  As a site admin
  I need to know that file upload is not permitted for auth users without elevated permission.

  Scenario: Check File Attachments is not available for site user
    Given I am logged in as "site user"
    When I follow "Support"
    And I follow "Forums"
    And I follow "Post new Forum topic"
    Then I should not see "File attachments"
    And I should not see "Attach new file:"