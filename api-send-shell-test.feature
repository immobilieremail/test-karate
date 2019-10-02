Feature: TTMT Send Shell integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/shell'

Scenario: send ocap
# Create Shell
    Given path '/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'Shell', url: '#notnull' }
    And def responseUrl = response.url

# Acces created Shell
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'Shell', dropbox: '#notnull', update: '#notnull', contents: { audiolists_view: [], audiolists_edit: [] } }
    And def dropbox = response.dropbox

# Create ocap
    Given url 'http://localhost:' + port + '/api/audiolist/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }
    And def responseUrl = response.url
    And def responseType = response.ocapType

# Send ocap
    Given url dropbox
    And request {data: [{ocapType: '#(responseType)', ocap: '#(responseUrl)'}]}
    When method post
    Then status 200