@user @wip
Feature: Content I posted
  In order to keep track of responses to my posts
  As an authenticated user
  I want to find all different pieces of content I posted listed in a single place

  @failing
  Scenario: Create test data for the following scenarios
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I am at "/node/add/project-project"
    And I follow "Module project"
    When I create a "full" project
    And I see project data
    And I follow "open"
    And I follow "Create a new issue"
    And I create a new issue
    And I see "has been created"
    And I add a comment to the issue
    And I add one more comment to the issue
    Then I should see the random "Description" text

  @dependent @failing
  Scenario: Comment on a specific post as git user
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    And I am on the project page
    When I follow "open"
    Then I should see the issue link
    And I follow an issue of the project
    And I add a comment to the issue
    And I add one more comment to the issue

  @dependent @failing
  Scenario: Navigate to your posts page
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    When I follow "Your Posts"
    Then I should see the following <texts>
      | texts        |
      | Type         |
      | Post         |
      | Author       |
      | Replies      |
      | Last updated |
    And I should see at least "1" reply for the post
    And I should see at least "1" new reply for the post
    And I should see updated for the post

  @clean_data @dependent @failing
  Scenario: Navigate to the specific post and check for the new post.
    Given users:
      | name            | pass     | mail                                | roles           |
      | Git Vetted User | password | qa+gitvetted@association.drupal.org | Git vetted user |
    And I am logged in as "Git Vetted User"
    And I follow "Your Posts"
    And I follow an issue of the project
    When I move backward one page
    Then I should see at least "4" replies for the post
    And I should not see updated for the post

  @clean_data
  Scenario: Create a case study and view the same
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I visit "/node/add/casestudy"
    And I create a case study
    And I see the case study page
    And I follow "Logged in as Confirmed User"
    And I follow "Your Posts"
    Then I should see the random "Project name" link

  @clean_data @failing
  Scenario: Create and view a book page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I visit "/node/add/book?parent=3264"
    And I create a book page
    And I see "has been created"
    And I follow "Logged in as Confirmed User"
    And I follow "Your Posts"
    Then I should see the random "Document title" link

  @clean_data
  Scenario: Create and view an Organization page
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Confirmed User | password | ryan+siteuser@association.drupal.org | confirmed |
    And I am logged in as "Confirmed User"
    When I visit "/node/add/organization"
    And I create a new organization
    And I see "has been created"
    And I follow "Logged in as Confirmed User"
    And I follow "Your Posts"
    Then I should see the random "Organization name" link
