@user @wip
Feature: User contact form
  In order to allow or stop other people from contacting me
  As an authenticated user
  I should be able to enable or disable my contact form

  Scenario: Site user enables contact form
    Given I am logged in as "site user"
    When I follow "Edit"
    And I check the box "Personal contact form"
    And I press "Save"
    Then I should see "The changes have been saved"
    And I should not see the link "Contact"

  @anon
  Scenario: Anonymous user doesn't have access to contact form
    Given I am not logged in
    When I visit "/search/user_search"
    And I fill in "Enter your keywords" with "site user"
    And I press "Search" in the "content" region
    And I see "Search results"
    And I follow "site user"
    Then I should not see the link "Contact"

  Scenario: Git user accesses site user's contact form and sends message
    Given I am logged in as "git user"
    When I visit "/search/user_search"
    And I fill in "Enter your keywords" with "site user"
    And I press "Search" in the "content" region
    And I see "Search results"
    And I follow "site user"
    And I follow "Contact"
    And I see the heading "site user"
    And I see the following <tabs>
    | tabs    |
    | Profile |
    | Posts   |
    | Commits |
    And I see the following <links>
    | links     |
    | View      |
    | Contact   |
    | git user  |
    | site user |
    And I see the following <texts>
    | texts   |
    | From    |
    | To      |
    And I fill in "Subject" with random text
    And I fill in "Message" with random text
    And I check the box "Send yourself a copy"
    And I press "Send e-mail"
    Then I should see "The message has been sent"

  Scenario: Site user disables contact form
    Given I am logged in as "site user"
    When I follow "Edit"
    And I uncheck the box "Personal contact form"
    And I press "Save"
    Then I should see "The changes have been saved"

  Scenario: Git user doesn't have access to site user's contact form
    Given I am logged in as "git user"
    When I visit "/search/user_search"
    And I fill in "Enter your keywords" with "site user"
    And I press "Search" in the "content" region
    And I see "Search results"
    And I follow "site user"
    Then I should not see the link "Contact"