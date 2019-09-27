Feature: TTMT AudioList integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/audiolist'

Scenario: create audiolist
    Given path '/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access created AudioListEdit
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'AudioListEdit', view_facet: '#notnull', update: '#notnull', contents: '#notnull' }
    And def responseUrl = response.view_facet

    # Access created AudioListView
    Given url responseUrl
    When method get
    Then status 200
    And match response contains { type: 'AudioListView', contents: '#notnull' }

Scenario: update audiolist
    Given path '/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }
    And def responseUrl = response.url
