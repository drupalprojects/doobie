@user
Feature: Display additional information on my comments
  In order to add some information to all my comments
  As an authenticated user
  I should be able to enter my signature and see it on my comments

  Scenario: Enter signature and save
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Profile"
    And I follow "Edit"
    And I see the heading "site user"
    And I see "Signature settings"
    When I fill in "Signature" with random text
    And I press "Save"
    Then I should see "The changes have been saved"

  Scenario: Create a forum, reply and view signature
    Given I am logged in as "site user"
    And I follow "Community"
    And I follow "Forum"
    And I follow "News and announcements"
    And I follow "Add new Forum topic"
    And I created a forum topic
    When I follow "Add new comment"
    And I fill in "Subject" with random text
    And I fill in "Comment" with random text
    And I press "Save"
    Then I should see the random "Subject" text
    And I should see the random "Comment" text
    And I should see the random "Signature" text

  @dependent @anon
  Scenario: View siganature in reply anonymously
    Given I am not logged in
    And I am on the forum topic page
    Then I should see the random "Subject" text
    And I should see the random "Comment" text
    And I should see the random "Signature" text

  Scenario: Reset signature and save
    Given I am logged in as "site user"
    And I follow "Your Dashboard"
    And I follow "Profile"
    And I follow "Edit"
    When I fill in "Signature" with ""
    And I press "Save"
    Then I should see "The changes have been saved"

  @dependent
  Scenario: Siganature doesn't appear in reply any more for site user
    Given I am logged in as "site user"
    And I am on the forum topic page
    Then I should see the random "Subject" text
    And I should see the random "Comment" text
    And I should not see the random "Signature" text

  @dependent @anon @clean_data
  Scenario: Siganature doesn't appear in reply any more for anonymous user
    Given I am not logged in
    And I am on the forum topic page
    Then I should see the random "Subject" text
    And I should see the random "Comment" text
    And I should not see the random "Signature" text
    
