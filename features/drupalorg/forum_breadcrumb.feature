@community @forums
Feature: Forum breadcrumbs
  In order to effectively navigate within the forums
  As any user
  I need to see breadcrumbs that tell me which section of the forum I am in

  Scenario: User follows link in the Support forum without logging in
    Given that I am on the homepage
    When I follow "Community"
    And I follow "Forum"
    And I follow "Post installation"
    Then I should see the breadcrumb "Support"
    And I should see "Login to post new content in the forum."

  Scenario: Logged in user follows link in Support forum
    Given I am logged in as "site user"
    When I visit "/forum/18"
    And I follow "Before you start"
    Then I should see "Post new forum topic"
    And I should see the breadcrumb "Support"
    And I should not see the breadcrumb "Before you start"

  Scenario: User follows a topic in the Post installation forum
    Given I am on "/forum/22"
    When I follow a post
    Then I should see the breadcrumb "Support"
    And I should see the breadcrumb "Post installation"
