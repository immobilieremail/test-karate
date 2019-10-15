Feature: TTMT Media integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/media/'

Scenario: create, show and delete media
    # Create media facet store
    Given multipart field media = read('../media/audio2.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaFacetEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access media facet edit
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'MediaFacetEdit', view_facet: '#notnull', path: '#notnull' }
    And def responseUrl = response.view_facet
    And def deleteMediaUrl = response.delete

    # Access media facet show
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'MediaFacetView', path: '#notnull' }

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

Scenario: create image jpg media
    # Create media facet store
    Given multipart field media = read('../media/image.jpg')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaFacetEdit', url: '#notnull' }

Scenario: create image png media
    # Create media facet store
    Given multipart field media = read('../media/image2.png')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaFacetEdit', url: '#notnull' }

Scenario: create video mp4 media
    # Create media facet store
    Given multipart field media = read('../media/video.mp4')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaFacetEdit', url: '#notnull' }

Scenario: create video mpg media
    # Create media facet store
    Given multipart field media = read('../media/video2.mpg')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaFacetEdit', url: '#notnull' }

Scenario: create audio mp3 media
    # Create media facet store
    Given multipart field media = read('../media/audio.mp3')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaFacetEdit', url: '#notnull' }
