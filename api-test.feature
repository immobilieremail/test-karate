Feature: TTMT integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/audiolist/create'

Scenario: create audiolist
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }
    And def responseUrl = response.url

    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'AudioListEdit', view_facet: '#notnull', update: '#notnull', contents: '#notnull' }
    And def responseUrl = response.view_facet

    Given url responseUrl
    When method get
    Then status 200
    And match response contains { type: 'AudioListView', contents: '#notnull' }
