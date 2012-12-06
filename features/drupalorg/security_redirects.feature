@security
Feature: Security redirects
  In order to ensure I can find important security information
  As any user
  I should be redirected from the old URLs to the new ones

  Scenario: Visit /security-contrib and get redirected to /security/contrib
    Given I am on "/security"
    When I follow "Contributed projects"
    Then I should see the heading "Security advisories"
    And the url should match "/security/contrib"

  Scenario: Visit /security-contrib/rss.xml and get redirected to /security/contrib/rss.xml
    Given I am on "/security"
    And I follow "Contributed projects"
    When I click on the feed icon
    Then the url should match "/security/contrib/rss.xml"

  Scenario: Visit /security-psa and get redirected to /security/psa
    Given I am on "/security"
    When I follow "Public service announcements"
    Then I should see the heading "Security advisories"
    And the url should match "/security/psa"

  Scenario: Visit security-psa/rss.xml and get redirected to /security/psa/rss.xml
    Given I am on "/security"
    And I follow "Public service announcements"
    When I click on the feed icon
    Then the url should match "/security/psa/rss.xml"
