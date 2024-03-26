@sanity @ticket
Feature: To demonstarte create Ticket api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@ticket
Scenario: [TC-DDR-01] To verify the Create Ticket API
    # calling genrate csrf secanrio from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateTicket
    * headers getHeaders
    #* headers fetchGenrateCsrfScenario.storedLoginTokenValues
     And header Authorization = Authorization
    And request getRequestBodyLogin.VerifyTicketCreationrequest
    When method post
    Then print response