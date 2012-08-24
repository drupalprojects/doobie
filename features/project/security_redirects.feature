Feature: 
  In order to confirm the changes in URLs
  As any user 
  I should be redirected to the new URLs

  Scenario: Check /security-contrib is redirected to /security/contrib
    Given I am on "/security-contrib"
    Then I should see the heading "Security advisories"
    And the url should match "/security/contrib"

  Scenario: Check security-contrib/rss.xml is redirected to /security/contrib/rss.xml
    Given I am on "/security-contrib/rss.xml"
    Then the url should match "/security/contrib/rss.xml"

  Scenario: Check security-psa is redirected to /security/psa
    Given I am on "/security-psa"
    Then I should see the heading "Security advisories"
    And the url should match "/security/psa"

  Scenario: Check security-psa/rss.xml is redirected to /security/psa/rss.xml
    Given I am on "/security-psa/rss.xml"
    Then the url should match "/security/psa/rss.xml"