Feature: TTMT Audio integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/audio/'

Scenario: create audio
    Given multipart field audio = read('audios/applause.wav')
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioEdit', url: '#notnull' }
    And def responseUrl = response.url

    # Access created AudioEdit
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'AudioEdit', view_facet: '#notnull', path: '#notnull', delete: '#notnull' }
    And def responseUrl = response.view_facet
    And def deleteAudioUrl = response.delete

    # Access created AudioView
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'AudioView', path: '#notnull' }

    # Delete created Audio
    Given url deleteAudioUrl
    When method delete
    Then status 200
