@security @wip
Feature: Publishing new security announcement
  In order to make new security advisory public
  As a member of Security team
  I should be able to publish new forum post and see it on advisories page

  @clean_data
  Scenario Outline: Create forum topic
    Given I am logged in as "admin test"
    When I visit "/forum/1188"
    And I follow "<section>"
    And I follow "Post new Forum topic"
    And I create a forum topic
    And I see "has been created"
    And I visit "<path>"
    Then I should see the forum topic link
    Examples:
    | section                                      | path        |
    | Security advisories for Drupal core          | /forum/1852 |
    | Security advisories for contributed projects | /forum/44   |
    | Security public service announcements        | /forum/1856 |
