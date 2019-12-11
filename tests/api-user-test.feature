Feature: TTMT User integration test

Background:
    * def port = 8000
    * def basicUrl = 'http://localhost:' + port

Scenario: create travel
    # Create user
    Given url basicUrl + '/api/user'
    Given request { name: 'Billy', email: 'billy.thekid@example.com', phone: '+4 (981) 264-9370', password: 'psswd' }
    When method post
    Then status 200
    And match response == { type: 'ocap', ocapType: 'UserProfileFacet', url: '#notnull' }
    And def userUrl = response.url

    # Access created user via UserProfileFacet
    Given url userUrl
    When method get
    Then status 200
    And match response ==
    """
    {
        type: 'UserProfileFacet',
        data: {
            name: 'Billy',
            email: 'billy.thekid@example.com',
            phone: '+4 (981) 264-9370',
            password: 'psswd'
        }
    }
    """