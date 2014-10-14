@community @forums
Feature:
  In order to restrict unauthorized users from uploading files while creating a Forum Topic
  As a site admin
  I need to know that file upload is only permitted to users with Administer content.

  Scenario: File Attachments is not available for regular Trusted User
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    When I follow "Support"
    And I follow "Forums"
    And I follow "Post installation"
    And I follow "Add new Forum topic"
    Then I should not see "File attachments"
    And I should not see "Add a new file"

  Scenario: File Attachments is available for admin
    Given users:
      | name                | pass     | mail                                    | roles         |
      | Administrative User | password | qa+administrator@association.drupal.org | administrator |
    And I am logged in as "Administrative User"
    And I am on "/forum"
    And I follow "Post installation"
    When I follow "Add new Forum topic"
    Then I should see "File attachments"
    And I should see "Add a new file"
