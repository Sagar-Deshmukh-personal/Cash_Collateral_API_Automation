@mticket
Feature: To demonstrate create Ticket API test cases

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 

@mticket
Scenario Outline: Verify successful/error ticket creation
     # Call the login scenario once to get the authentication token
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateTicket
    * headers getHeaders
    * headers fetchGenrateCsrfScenario.storedLoginTokenValues
    And header Authorization = Authorization
    And request <requestBody>
    When method post
    Then status <responseCode>
    And print response

    * def expectedResponse = getResponseBodyLogin.<responseErrorMessage>
    * print expectedResponse
    * def actualResponse = response
    * print actualResponse
    And match actualResponse == expectedResponse

Examples:
| Test Case |          requestBody          | responseCode | responseErrorMessage |
| TC-TK-01  | getRequestBodyLogin.verifyTCSRequest |  200      | verifyTCSResponse   |
| TC-TK-02  | getRequestBodyLogin.verifyTCErrorRequest |  500  | verifyTCEResponse  |