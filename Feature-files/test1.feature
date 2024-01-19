
Feature: feature for testing a graphQL application to retrieve account details

  Background:
    * def baseUrl = karate.properties['baseUrl']
    * url baseUrl
    * configure proxy = karate.properties['proxyUrl']

  Scenario Outline: #get account details based on ID for regional
    * def JwtCreationClass = Java.type('demo.JwtCreation')
    * def JwtObject = new JwtCreationClass()
    * def JwtToken = JwtObject.jwtToken("regional");
    * karate.configure('headers',{authorization : 'Bearer '+JwtToken })
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
    Given url baseUrl
    And request { query: '#(query)' }
    When method Post
    Then status 200
    And match response.data.getAccountById.accountId == <id>

    Examples:
    |id |
    |101|
    |102|

  Scenario Outline: #get account details based on ID for national
    * def JwtCreationClass = Java.type('demo.JwtCreation')
    * def JwtObject = new JwtCreationClass()
    * def JwtToken = JwtObject.jwtToken("national");
    * karate.configure('headers',{authorization : 'Bearer '+JwtToken })
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
    Given url baseUrl
    And request { query: '#(query)' }
    When method Post
    Then status 200
    And match response.data.getAccountById.accountId == <id>

    Examples:
      |id |
      |101|
      |102|



