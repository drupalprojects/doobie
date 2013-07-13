Feature:
  Scenario:
    # Given I am on the homepage
    Given I am on "/node/2038303"
    Then I should see "xUnassigned" in the "Assigned" field
