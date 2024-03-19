Feature: Add 2 more fields accountNumber and balance to the type Account in fetch-account-details API schema.

  Background:
    * url 'http://localhost:3000/graphql'
    * configure proxy = { uri: '#(karate.properties["proxyUrl"])', username: '#(karate.properties["proxyUsername"])', password: '#(karate.properties["proxyPassword"])' }
    * def JwtCreationClass = Java.type('demo.JwtCreation')
    * def JwtObject = new JwtCreationClass()
    * def JwtToken = JwtObject.jwtToken("regional");
    * karate.configure('headers', { authorization: 'Bearer ' + JwtToken })
    * text query =
    """
    query{
    Results:getAccountById(id : 1) {
        accountId
        firstName
        lastName
        accountType
        accountNumber
        balance
    }
    }
    """

  Scenario: #Add accountNumber field to the type Account in the schema.
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    * def results = get[0] response..Results
    And match results contains {accountNumber : '#present'}

  Scenario: #Add balance field to the type Account in the schema.
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    * def results = get[0] response..Results
    And match results contains {balance : '#present'}

  Scenario: #validate that the accountNumber is not null and contains alphanumeric characters.
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    * def results = get[0] response..Results
    And match results contains {accountNumber: '#notnull'}
    And match response.data.Results.accountNumber == '#regex [a-zA-Z0-9]+'

  Scenario: #validate that the length of accountNumber field is 12 characters.
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    And response.data.Results.accountNumber.length() == 12

  Scenario: #validate that the balance is not negative.
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    And response.data.Results.balance>0

  Scenario: #validate that the balance does not exceed maximum balance limit.
    * def limit = 1000000
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    And response.data.Results.balance < limit

