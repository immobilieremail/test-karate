Feature: TTMT Media integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/media/'

Scenario: create, show and delete media
    # Create media store
    Given multipart field media = read('../audios/applause.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access media edit
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'MediaEdit', view_facet: '#notnull', path: '#notnull', delete: '#notnull' }
    And def responseUrl = response.view_facet
    And def deleteMediaUrl = response.delete

    # Access media show
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'MediaView', path: '#notnull' }

    # Delete media
    Given url deleteMediaUrl
    When method delete
    Then status 204

Scenario: create dirty media
    # Create media dirty data
    Given multipart field media = "its un example"
    When method post
    Then status 415

Scenario: create bad request media
    # Create media dirty data
    Given multipart field cequetuveux = "its un example"
    When method post
    Then status 400