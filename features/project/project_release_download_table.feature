@releases @anon
Feature: To view and download a release package from the download table
  In order to view/download the release package
  As a user
  I should select a release from the download table

  Scenario: View the list of available releases
    Given I am on the homepage
    When I follow "Get Started with Drupal"
    And I follow "Download Drupal"
    Then I should see the heading "Download & Extend"
    And I should see the following <texts>
      | texts                |
      | Downloads            |
      | Recommended releases |
      | Development releases |
      | Version              |
      | Download             |
      | Date                 |
      | Links                |
    And I should see the following <links>
      | links   |
      | 7.      |
      | 6.      |
      | Notes   |
      | gz      |
      | zip     |
      | 7.x-dev |
      | 6.x-dev |

  Scenario: Navigate into a release: Recommended
    Given I am on "/project/drupal"
    When I follow "7."
    Then I should see "drupal 7."
    And I should see the following <texts>
      | texts     |
      | Posted by |
      | Download  |
      | Size      |
      | md5 hash  |
    And I should not see "development snapshot from branch: 7"

  Scenario: Navigate into a release: Development
    Given I am on "/project/drupal"
    When I follow "6.x-dev"
    Then I should see "Drupal 6.x-dev"
    And I should see the following <texts>
      | texts                             |
      | Posted by                         |
      | development snapshot from branch: |
      | Download                          |
      | Size                              |
      | md5 hash                          |
      | Release notes                     |

  @content @failing
 Scenario: See the notes of a release: Recommended
    Given I am on "/project/drupal"
    When I follow "Notes" for version "6.28"
    Then I should see "drupal 6.28"
    And I should see the following <texts>
      | texts         |
      | Posted by     |
      | Download      |
      | Size          |
      | md5 hash      |
      | Release notes |

  Scenario: See the notes of a release: Development
    Given I am on "/project/drupal"
    When I follow "Notes" for version "7.x-dev"
    Then I should see "Drupal 7.x"
    And I should see the following <texts>
      | texts                                                             |
      | Posted by                                                         |
      | development snapshot from branch:                                 |
      | Download                                                          |
      | Size                                                              |
      | md5 hash                                                          |
      | This is not stable, and production sites should not run this code |

  @content @failing
 Scenario: Download a release: Recommended - zip
    Given I am on "/project/drupal"
    When I download the "zip" file for version "6.28"
    Then the downloaded file name should be "drupal-6.28.zip"

  Scenario: Download a release: Recommended - tar
    Given I am on "/project/drupal"
    When I download the "gz" file for version "6.x-dev"
    Then the downloaded file name should be "drupal-6.x-dev.tar.gz"

  Scenario: Download a release: Development - tar
    Given I am on "/project/drupal"
    When I download the "gz" file for version "7.x-dev"
    Then the downloaded file name should be "drupal-7.x-dev.tar.gz"
