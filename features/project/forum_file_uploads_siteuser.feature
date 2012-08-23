Feature:
  In order to restrict unauthorized users from uploading files while creating a Forum Topic
  As a site user
  I need to be able to check file upload is not permitted

  Scenario: Check File Attachments is not available for site user
    Given I am logged in as "site user"
    When I follow "Support"
    And I follow "Forums"
    And I follow "Post new Forum topic"
    Then I should not see "File attachments"
    And I should not see "Attach new file:"