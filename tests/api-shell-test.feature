Feature: TTMT Shell integration test

Background:
    * def port = 8000
    * def basicUrl = 'http://localhost:' + port

Scenario: create travel
    # Create new travel OcapList
    Given url basicUrl + '/api/list'
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def travelListUrl = response.url

    # Create new contact OcapList
    Given url basicUrl + '/api/list'
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def contactListUrl = response.url

    # Create new shell
    Given url 'http://localhost:' + port + '/api/shell'
    Given request { travels: '#(travelListUrl)', contacts: '#(contactListUrl)' }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'ShellUserFacet', url: '#notnull' }
    And def shellUrl = response.url

    # Access shell user facet
    Given url shellUrl
    When method get
    Then status 200
    And match response == { type: 'ShellUserFacet', data: { travels: '#(travelListUrl)', contacts: '#(contactListUrl)' } }