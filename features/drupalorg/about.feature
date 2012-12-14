@about @content @anon
Feature: About Drupal section
  In order to find out about Drupal
  As any user
  I want to find information on an About page

  Scenario: Browse to the About page
    Given I am on the homepage 
    When I follow "About"
    Then I should see the heading "About Drupal"
    And I should see the heading "Drupal is Open Source"
    And I should see the heading "Community Support"
    And I should see the heading "Drupal's History"
    And I should see the heading "Commercial Services"
    And I should see the following <links>
    | links                      |
    | About Drupal               |
    | About the Drupal project   |
    | Press releases             |
    | What's New in Drupal 7     |
    | Marketing resources        |
    | Social media directory     |
    | principles                 |
    | Drupal community           |
    | system requirements        |
    | We take security seriously |

  Scenario: Browse to About the Drupal project page
    Given I am on "/about"
    When I follow "About the Drupal project ›"
    Then I should see the heading "About the Drupal project"
    And I should see "Drupal is more than software"
    And I should see the following <links>
    | links                          |
    | Mission and principles         |
    | Core developers                |
    | Security team                  |
    | Drupal Accessibility Statement |
    | Getting support                |
    | Licensing FAQ                  |
