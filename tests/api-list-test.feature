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
    And def commonUrl = response.url

    # Access edit of OcapList
    Given url commonUrl
    When method get
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [] }

    # Create Media
    Given url 'http://localhost:' + port + '/api/media'
    And multipart field media = read('../media/audio2.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaEditFacet', url: '#notnull' }
    And def responseUrl = response.url

    # Add Media to OcapList
    Given url commonUrl
    And request { ocaps: [ '#(responseUrl)' ] }
    When method put
    Then status 204

    # Access edit of OcapList for updated content
    Given url commonUrl
    When method get
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [{ type: "ocap", ocapType: "MediaEditFacet", url: "#(responseUrl)" }] }

    # Remove all Media from OcapList
    Given url commonUrl
    And request { ocaps: [] }
    When method put
    Then status 204

    # Access edit of OcapList for empty content
    Given url commonUrl
    When method get
    Then status 200
    And match response == { type: 'OcapListEditFacet', view_facet: '#notnull', contents: [] }

Scenario: show unknown list
    # Access unknown edit of OcapList
    Given url 'http://localhost:' + port + '/api/obj/stringaupif'
    When method get
    Then status 404