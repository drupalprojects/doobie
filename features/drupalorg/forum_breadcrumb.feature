Feature: Forum breadcrumbs
  In order to effectively navigate within the forums
  As any site user
  I need to use breadcrumbs that place me in the support section forum topic

  Scenario: User follows link in the Support forum without logging in
    Given I am not logged in
    And I am on the homepage
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
    

  Scenario: User follows a topic in the Post installation forum
    Given I am on "/forum/22"
    When I follow a post
    Then I should see the breadcrumb "Support"
    And I should see the breadcrumb "Post Installation"