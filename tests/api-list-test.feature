Feature: TTMT OcapList integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/list'

Scenario: create, update and clean list
    # Create OcapList
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def responseUrl = response.url

    # Access edit of OcapList
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [] }
    And def updateUrl = response.update

    # Create Media
    Given url 'http://localhost:' + port + '/api/media'
    And multipart field media = read('../audios/applause.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaEditFacet', url: '#notnull' }
    And def responseUrl = response.url

    # Add Media to OcapList
    Given url updateUrl
    And request { data: { medias: [ { ocap: '#(responseUrl)' } ] } }
    When method put
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [{ type: 'ocap', ocapType: 'MediaViewFacet', url: '#(responseUrl)' }] }

    # Remove all Media from OcapList
    Given url updateUrl
    And request { data: { medias: [] } }
    When method put
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [] }

Scenario: show unknown list
    # Access unknown edit of OcapList
    Given url 'http://localhost:' + port + '/api/obj/stringaupif'
    When method get
    Then status 404