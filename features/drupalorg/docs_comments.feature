@docs
Feature: Handbook comment directions
  In order to help keep documentation accurate
  As a community member
  I need to be able to leave comments on handbook pages

  Background:
    Given users:
      | name         | pass     | mail                                 | roles         |
      | Trusted User | password | ryan+siteuser@association.drupal.org | Not a spammer |
    And I am logged in as "Trusted User"
    And I am on "/documentation/install/download"

  Scenario: A note with specific directions should appear above the comment form
    When I follow "Add new comment"
    Then I should see "Note:"
    And I should see "Is your comment an addition, problem report, or example?"
    And I should see "Is your comment a question or request for support?"

    # This story has to run as a javascript because the redirect after post includes
    # the #anchor and drupal cannot figure out how to route when that is there.
    # Libcurl is out of date on staging, which is what is causing that problem.
  @javascript
  Scenario: Submit a comment
    When I follow "Add new comment"
    And I wait until the page loads
    And I fill in "Subject" with random text
    And I fill in "Comment" with random text
    And I press "Save"
    And I wait until the page loads
    Then I should see the random "Comment" text
