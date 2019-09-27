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
    And match response == { type: 'AudioListView', contents: '#notnull' }

Scenario: update audiolist
    Given path '/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access created AudioListEdit
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'AudioListEdit', view_facet: '#notnull', update: '#notnull', contents: '#notnull' }
    And def updateUrl = response.update

    # Create Audio
    Given url 'http://localhost:' + port + '/api/audio'
    And multipart field audio = read('audios/applause.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access created AudioEdit
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'AudioEdit', view_facet: '#notnull', path: '#notnull', delete: '#notnull' }
    And def audioViewUrl = response.view_facet

    # Add AudioView to AudioListEdit
    Given url updateUrl
    And request { data: { audios: [ { ocap: '#(audioViewUrl)' } ] } }
    When method put
    Then status 200
    And match response == { type: 'AudioListEdit', view_facet: '#notnull', update: '#notnull', contents: [{ type: 'ocap', ocapType: 'AudioView', url: '#(audioViewUrl)' }] }
