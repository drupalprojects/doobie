@docs
Feature: Handbook comment directions
  In order to help keep documentation accurate
  As a community member
  I need to be able to leave comments on handbook pages

  Background:
    Given I am logged in as "site user"
    And I am on "/documentation/install"

  Scenario: A note with specific directions should appear above the comment form
    When I follow "Add new comment"
    Then I should see "Note:"
    And I should see "Is your comment an addition, problem report, or example?"
    And I should see "Is your comment a question or request for support?"

  Scenario: Submit a comment
    When I follow "Add new comment"
    And I fill in "Subject:" with random text
    And I fill in "Comment:" with random text
    And I press "Save"
    Then I should see the random "Comment:" text
