@other @anon
Feature: Drupal CMS benefits page
  In order to find out about Drupal benefits
  As any user
  I should be able to view benefits page

  Scenario: View the page and links
    Given I am on "/features"
    Then I should see the heading "Drupal CMS Benefits"
    And I should see the following <texts>
    | texts                                   |
    | Drupal is a publishing platform created |
    | content management features             |
    | Build internal and external-facing      |
    And I should see the following <links>
    | links               |
    | Drupal CMS Benefits |
    | ORGANIZE & FIND     |
    | CREATIVE CONTENT    |
    | ADMINISTER          |
    | COLLABORATE         |
    | BUILD               |
    | DESIGN AND DISPLAY  |
    | Create              |
    | EXTEND              |
    | CONNECT             |
