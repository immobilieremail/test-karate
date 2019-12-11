Feature: TTMT Shell integration test

Background:
    * def port = 8000
    * def basicUrl = 'http://localhost:' + port

Scenario: create travel
    # Create new travel OcapList
    Given url basicUrl + '/api/list'
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def travelListUrl = response.url

    # Create new contact OcapList
    Given url basicUrl + '/api/list'
    Given request {}
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'OcapListEditFacet', url: '#notnull' }
    And def contactListUrl = response.url

    # Create new User
    Given url basicUrl + '/api/user'
    Given request { name: 'Billy', email: 'billy.thekid@example.com' }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'UserProfileFacet', url: '#notnull' }
    And def userUrl = response.url

    # Create new shell
    Given url 'http://localhost:' + port + '/api/shell'
    Given request { user: '#(userUrl)', travels: '#(travelListUrl)', contacts: '#(contactListUrl)' }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'ShellUserFacet', url: '#notnull' }
    And def shellUrl = response.url

    # Access shell user facet
    Given url shellUrl
    When method get
    Then status 200
    And match response ==
    """
        {
            type: 'ShellUserFacet',
            data: {
                user: '#(userUrl)',
                travels: '#(travelListUrl)',
                contacts: '#(contactListUrl)'
            }
        }
    """

    # Update shell travels & contacts list
    Given url shellUrl
    Given request { travels: '#(contactListUrl)', contacts: '#(travelListUrl)' }
    When method put
    Then status 204

    # Access updated shell user facet
    Given url shellUrl
    When method get
    Then status 200
    And match response ==
    """
        {
            type: 'ShellUserFacet',
            data: {
                user: '#(userUrl)',
                travels: '#(contactListUrl)',
                contacts: '#(travelListUrl)'
            }
        }
    """