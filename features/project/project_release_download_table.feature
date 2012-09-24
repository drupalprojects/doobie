Feature: To view and download a release package from the download table
  In order to view/download the release package
  As a user
  I should select a release from the download table

  Scenario: View the list of available releases
    Given that I am on the homepage
    When I follow "Get Started with Drupal"
    And I follow "Download Drupal 7."
    Then I should see the heading "Download & Extend"
    And I should see the following <texts>
    | texts                |
    | Downloads            |
    | Recommended releases |
    | Development releases |
    | Version              |
    | Downloads            |
    | Date                 |
    | Links                |
    And I should see the following <links>
    | links   |
    | 7.      |
    | 6.      |
    | Notes   |
    | tar.gz  |
    | zip     |
    | 7.x-dev |
    | 6.x-dev |

  Scenario: To navigate into a release: Recommended
    Given I am on "/project/drupal"
    When I follow "7."
    Then I should see "drupal 7."
    And I should see the following <texts>
    | texts                         |
    | Posted by                     |
    | Download                      |
    | Size                          |
    | md5 hash                      |
    | Official release from tag: 7. |
    And I should not see "Development snapshot from branch: 7"

  Scenario: To navigate into a release: Development
    Given I am on "/project/drupal"
    When I follow "6.x-dev"
    Then I should see "Drupal 6.x-dev"
    And I should see the following <texts>
    | texts                                 |
    | Posted by                             |
    | Development snapshot from branch: 6.x |
    | Download                              |
    | Size                                  |
    | md5 hash                              |
    | Release notes                         |
    And I should not see "Official release from tag: 6."

  Scenario: To see the notes of a release: Recommended
    Given I am on "/project/drupal"
    When I follow "Notes" for version "6.26"
    Then I should see "drupal 6.26"
    And I should see the following <texts>
    | texts                           |
    | Posted by                       |
    | Official release from tag: 6.26 |
    | Download                        |
    | Size                            |
    | md5 hash                        |
    | Release notes                   |
    And I should not see "Development snapshot from branch: 6.x"

  Scenario: To see the notes of a release: Development
    Given I am on "/project/drupal"
    When I follow "Notes" for version "7.x-dev"
    Then I should see "drupal 7.x"
    And I should see the following <texts>
    | texts                                                             |
    | Posted by                                                         |
    | Development snapshot from branch: 7.x                             |
    | Download                                                          |
    | Size                                                              |
    | md5 hash                                                          |
    | This is not stable, and production sites should not run this code |
    And I should not see "Official release from tag: 7."

  @wip
  Scenario: Download a release: Recommended - tar
    Given I am on "/project/drupal"
    When I download the "tar" file for version "7.15"
    Then the downloaded file name should be "drupal-7.15.tar.gz"

  @wip
  Scenario: Download a release: Recommended - zip
    Given I am on "/project/drupal"
    When I download the "zip" file for version "6.26"
    Then the downloaded file name should be "drupal-6.26.zip"

  @wip
  Scenario: Download a release: Recommended - tar
    Given I am on "/project/drupal"
    When I download the "tar" file for version "6.x-dev"
    Then the downloaded file name should be "drupal-6.x-dev.tar.gz"

  @wip
  Scenario: Download a release: Development - zip
    Given I am on "/project/drupal"
    When I download the "zip" file for version "7.x-dev"
    Then the downloaded file name should be "drupal-7.x-dev.zip"
