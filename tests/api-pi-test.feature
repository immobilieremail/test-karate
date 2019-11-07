Feature: TTMT PI (Point of Interest) integration test

Background:
    * def port = 8000
    * def basicUrl = 'http://localhost:' + port
    * url basicUrl + '/api/pi'

Scenario: create pi
    # Create Media
    Given url basicUrl + '/api/media'
    And multipart field media = read('../media/audio2.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'MediaEditFacet', url: '#notnull' }
    And def mediaUrl = response.url

    # Create OcapList
    Given url basicUrl + '/api/list'
    And request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def listUrl = response.url

    # Add Media to OcapList
    Given url listUrl
    And request { ocaps: [ '#(mediaUrl)' ] }
    When method put
    Then status 204

    # Create PI
    Given request { data : { title: "Title", description: "Description", medias: "#(listUrl)" } }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'PIEditFacet', url: '#notnull' }
    And def piUrl = response.url

    # Access edit of PI
    Given url piUrl
    When method get
    Then status 200
    And match response == {
        type: 'PIEditFacet',
        view_facet: '#notnull',
        data: {
            title: "Title",
            description: "Description",
            medias: {
                type: 'ocap',
                ocapType: 'MediaEditFacet',
                url: '#(listUrl)'
            }
        }
    }
