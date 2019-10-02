Feature: TTMT shell integration test

Background:
    * def port = 8000
    * url 'http://localhost:' + port + '/api/shell'

Scenario: create, update and clean shell
# Create Shell
    Given path '/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'Shell', url: '#notnull' }
    And def responseUrl = response.url

# Acces show of Shell
    Given url responseUrl
    When method get
    Then status 200
    And match response == { type: 'Shell', dropbox: '#notnull', update: '#notnull', contents: { audiolists_view: [], audiolists_edit: [] } }
    And def update = response.update

# Create ocap
    Given url 'http://localhost:' + port + '/api/audiolist/create'
    When method get
    Then status 200
    And match response == { type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }
    And def responseUrl = response.url
    And def responseType = response.ocapType

# Add ocap to Shell
    Given url update
    And request { data: { audiolists: [ { ocap: '#(responseUrl)', ocapType: '#(responseType)' } ] } }
    When method put
    Then status 200
    And match response == { type: 'Shell', dropbox: '#notnull', update: '#notnull', contents: { audiolists_view: [], audiolists_edit: [{ type: 'ocap', ocapType: 'AudioListEdit', url: '#notnull' }] } }

# Remove all ocap from shell
    Given url update
    And request { data: { audiolists: [] } }
    When method put
    Then status 200
    And match response == { type: 'Shell', dropbox: '#notnull', update: '#notnull', contents: { audiolists_view: [], audiolists_edit: [] } }
