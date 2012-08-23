Feature: Project release files
  In order to install a specific release of Drupal core
  As any user
  I should be able to download the release file

  Scenario: Navigate to core releases
    Given that I am on the homepage
    When I follow "Download & Extend"
    And I follow "Other Releases"
    Then I should see the heading "Releases for Drupal core"

  Scenario: Navigate to releases page
    Given I am on "/node/3060/release"
    And I select "6.x" from "API version"
    When I press "Apply"
    Then I should see the following <texts>
    | texts     |
    | Drupal 6. |
    | Download  |
    | Size      |
    | md5 hash  |
    And I should see the link "drupal-6.25.tar.gz"
    And I should see the link "drupal-6.25.zip"

  Scenario: Download tar file
    Given I am on "/node/3060/release"
    When I select "7.x" from "API version"
    And I press "Apply"
    And I download the "tar" file "drupal-7.7.tar.gz"
    Then the md5 hash should match "2eeb63fd1ef6b23b0a9f5f6b8aef8850"

  Scenario: Download zip file
    Given I am on "/node/3060/release"
    When I select "8.x" from "API version"
    And I press "Apply"
    And I download the "zip" file "drupal-8.x-dev.zip"
    Then the md5 hash should match "95b5798567bf9704855d95baae0e8856"
