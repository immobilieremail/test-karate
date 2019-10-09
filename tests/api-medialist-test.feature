Feature: TTMT MediaList integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/medialist'

Scenario: create, update and clean medialist
    # Create MediaList
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaListEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access edit of MediaList
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'MediaListEdit', view_facet: '#notnull', update: '#notnull', contents: [] }
    And def updateUrl = response.update

    # Create Media
    Given url 'http://localhost:' + port + '/api/media'
    And multipart field media = read('../audios/applause.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access edit of Media
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'MediaEdit', view_facet: '#notnull', path: '#notnull', delete: '#notnull' }
    And def mediaViewUrl = response.view_facet

    # Add view Media to MediaList
    Given url updateUrl
    And request { data: { medias: [ { ocap: '#(mediaViewUrl)' } ] } }
    When method put
    Then status 200
    And match response == { type: 'MediaListEdit', view_facet: '#notnull', update: '#notnull', contents: [{ type: 'ocap', ocapType: 'MediaView', url: '#(mediaViewUrl)' }] }

    # Remove all Media from MediaList
    Given url updateUrl
    And request { data: { medias: [] } }
    When method put
    Then status 200
    And match response == { type: 'MediaListEdit', view_facet: '#notnull', update: '#notnull', contents: [] }

Scenario: show unknown medialist
    # Access unknown edit of MediaList
    Given path "/stringaupif/edit"
    When method get
    Then status 404
    
    Given path "/stringaupif"
    When method get
    Then status 404

