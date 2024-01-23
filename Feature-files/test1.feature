Feature: feature for testing a GraphQL application to retrieve account details

  Background:
    * url 'http://localhost:3000/graphql'
    * configure proxy = { uri: '#(karate.properties["proxyUrl"])' }

  Scenario Outline: #get account details based on ID for regional
    * def JwtCreationClass = Java.type('demo.JwtCreation')
    * def JwtObject = new JwtCreationClass()
    * def JwtToken = JwtObject.jwtToken("regional");
    * karate.configure('headers', { authorization: 'Bearer ' + JwtToken })
    * text query =
    """
    query{
    getAccountById(id : <id>) {
        accountId
        firstName
        lastName
        accountType
    }
    }
    """
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    And match response.data.getAccountById.accountId == <id>

    Examples:
      | id  |
      | 101 |
      | 102 |

  Scenario Outline: #get account details based on ID for national
    * def JwtCreationClass = Java.type('demo.JwtCreation')
    * def JwtObject = new JwtCreationClass()
    * def JwtToken = JwtObject.jwtToken("national");
    * karate.configure('headers', { authorization: 'Bearer ' + JwtToken })
    * text query =
    """
    query{
    getAccountById(id : <id>) {
        accountId
        firstName
        lastName
        accountType
    }
    }
    """
    Given request { query: '#(query)' }
    When method Post
    Then status 200
    And match response.data.getAccountById.accountId == <id>

    Examples:
      | id  |
      | 101 |
      | 102 |
