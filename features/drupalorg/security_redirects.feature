@security
Feature: Security redirects
  In order to ensure I can find important security information
  As any user
  I should be redirected from the old URLs to the new ones

  Scenario: Visit /security-contrib and get redirected to /security/contrib
    Given I am on "/security-contrib"
    Then I should see the heading "Security advisories"
    And the url should match "/security/contrib"

  Scenario: Visit /security-contrib/rss.xml and get redirected to /security/contrib/rss.xml
    Given I am on "/security-contrib/rss.xml"
    Then the url should match "/security/contrib/rss.xml"

  Scenario: Visit /security-psa and get redirected to /security/psa
    Given I am on "/security-psa"
    Then I should see the heading "Security advisories"
    And the url should match "/security/psa"

  Scenario: Visit security-psa/rss.xml and get redirected to /security/psa/rss.xml
    Given I am on "/security-psa/rss.xml"
    Then the url should match "/security/psa/rss.xml"
