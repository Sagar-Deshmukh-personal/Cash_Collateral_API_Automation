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
Scenario: [TC-Tk-01] To verify the Create Ticket API
       # calling genrate csrf secanrio from registred.feature
       * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
       * print fetchGenrateCsrfScenario
       * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateTicket
       * headers getHeaders
       * headers fetchGenrateCsrfScenario.storedLoginTokenValues
         And header Authorization = Authorization
         And request getRequestBodyLogin.verifyTicketCreationRequest
         When method post
         Then status 200
         Then print response

       # Define the expected response
       * def expectedSuccessfulResponse = { statusCode: 200, message: 'Success' }

       # Match the actual response against the expected response
       And match response == expectedSuccessfulResponse
       Then print response
 
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateTicket
        * headers getHeaders
        * headers fetchGenrateCsrfScenario.storedLoginTokenValues
        And header Authorization = Authorization
        And request getRequestBodyLogin.verifyTicketErrorRequest
        When method post
        Then status 500
        Then print response
  
      # Define the expected response
        * def expectedSuccessfulResponse = { statusCode: 500, message: 'Ticket creation failed' }
  
      # Match the actual response against the expected response
         And match response == expectedSuccessfulResponse
         Then print response
  