Feature: TTMT PI (Point of Interest) integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/pi'

Scenario: create pi
    # Create Media
    Given url 'http://localhost:' + port + '/api/media'
    And multipart field media = read('../media/audio2.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaEditFacet', url: '#notnull' }
    And def mediaUrl = response.url

    # View created Media
    Given url mediaUrl
    When method get
    Then status 200
    And match response == { type: 'MediaEditFacet', view_facet: '#notnull', path: '#notnull' }
    And def mediaViewFacet = response.view_facet

    # Create OcapList
    Given url 'http://localhost:' + port + '/api/list'
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def listUrl = response.url

    # Access created OcapList
    Given url listUrl
    When method get
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [] }
    And def viewListUrl = response.view_facet

    # Add Media to OcapList
    Given url listUrl
    And request { ocaps: [ '#(mediaUrl)' ] }
    When method put
    Then status 204

    # Create PI
    Given url 'http://localhost:' + port + '/api/pi'
    And request { title: "Title", description: "Description", address: "46 Quai Jacquoutot", medias: "#(listUrl)" }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'PIEditFacet', url: '#notnull' }
    And def piUrl = response.url

    # Access edit of PI
    Given url piUrl
    When method get
    Then status 200
    And match response == { type: 'PIEditFacet', view_facet: '#notnull', data: { title: "Title", description: "Description", address: "46 Quai Jacquoutot", medias: "#(viewListUrl)" } }