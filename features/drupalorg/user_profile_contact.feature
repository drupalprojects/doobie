@user @profile
Feature: User contact form
  In order to allow or stop other people from contacting me
  As an authenticated user
  I should be able to enable or disable my contact form

  @failing
  Scenario: Trusted User enables contact form
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    When I follow "Edit"
    And I check the box "Personal contact form"
    And I press "Save"
    Then I should see "The changes have been saved"
    And I should not see the link "Contact" in the "content" region

  @anon @failing
  Scenario: Anonymous user doesn't have access to contact form
    Given I am not logged in
    When I visit "/search/user"
    And I fill in "Enter your keywords" with "Trusted User"
    And I press "Search" in the "content" region
    And I follow "Trusted User"
    Then I should not see the link "Contact" in the "content" region

  @failing
  Scenario: Git user accesses Trusted User's contact form and sends message
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    When I visit "/search/user"
    And I fill in "Enter your keywords" with "Trusted User"
    And I press "Search" in the "content" region
    And I follow "Trusted User"
    And I follow "Contact"
    And I see the heading "Contact Trusted User"
    And I see the following <tabs>
      | tabs    |
      | Profile |
      | Posts   |
      | Commits |
    And I see the following <links>
      | links        |
      | View         |
      | Contact      |
      | Trusted User |
    And I see the following <texts>
      | texts               |
      | Your name           |
      | Your e-mail address |
      | To                  |
    And I fill in "Subject" with random text
    And I fill in "Message" with random text
    And I check the box "Send yourself a copy"
    And I press "Send message"
    Then I should see "Your message has been sent"

  @failing
  Scenario: Trusted User disables contact form
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | trusted |
    And I am logged in as "Trusted User"
    When I follow "Edit"
    And I uncheck the box "Personal contact form"
    And I press "Save"
    Then I should see "The changes have been saved"

  @failing
  Scenario: Git user doesn't have access to Trusted User's contact form
    Given users:
      | name     | pass     | mail                              | roles    |
      | Git User | password | qa+gituser@association.drupal.org | Git user |
    And I am logged in as "Git User"
    When I visit "/search/user"
    And I fill in "Enter your keywords" with "Trusted User"
    And I press "Search" in the "content" region
    And I follow "Trusted User"
    Then I should not see the link "Contact" in the "content" region
