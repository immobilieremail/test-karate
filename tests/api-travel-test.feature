Feature: TTMT Travel integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/travel'

Scenario: create travel
    # Create PI
    Given url 'http://localhost:' + port + '/api/pi'
    And request { title: 'Title', description: 'Description', address: '46 Quai Jacquoutot' }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'PIEditFacet', url: '#notnull' }
    And def piUrl = response.url

    # Access edit of PI
    Given url piUrl
    When method get
    Then status 200
    And match response == { type: 'PIEditFacet', view_facet: '#notnull', data: { title: 'Title', description: 'Description', address: '46 Quai Jacquoutot', medias: '#null' } }
    And def viewPiUrl = response.view_facet

    # Create OcapList for PI
    Given url 'http://localhost:' + port + '/api/list'
    And request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def piListUrl = response.url

    # Add PI to newly created PI OcapList
    Given url piListUrl
    And request { ocaps: [ '#(piUrl)' ] }
    When method put
    Then status 204

    # Access PI OcapList edit facet
    Given url piListUrl
    When method get
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [ { type:'ocap', ocapType: 'PIEditFacet', url: '#(piUrl)' } ] }
    And def viewPiListUrl = response.view_facet

    # Create Travel
    Given url 'http://localhost:' + port + '/api/travel'
    And request { title: 'New Travel', pis: '#(piListUrl)' }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'TravelEditFacet', url: '#notnull' }
    And def travelUrl = response.url

    # Access edit of Travel
    Given url travelUrl
    When method get
    Then status 200
    And match response == { type: 'TravelEditFacet', view_facet: '#notnull', data: { title: 'New Travel', pis: '#(viewPiListUrl)' } }