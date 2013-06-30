Feature: 
    @javascript
    Scenario:
    Given I am logged in as "site user"
    And I am on "/node/add/casestudy"
    And I wait until the page loads
    And I fill in "edit-title" with "adsf"  
    # And I press "files[field_mainimage_und_0]"
    And I attach the local file "koala.jpg" to "Primary screenshot"
    And I press "Save"
    Then show last response
