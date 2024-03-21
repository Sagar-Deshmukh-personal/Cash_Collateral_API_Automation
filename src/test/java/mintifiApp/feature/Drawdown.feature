@sanity @drawdown 
Feature: To demonstarte Drawdown api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@drawdown
Scenario: [TC-DDR-01] To verify the drawdown API
    # calling genrate csrf secanrio from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Register.feature@generateToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedTokenValues.token)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateDrawdown
    * headers getHeaders
    #* headers fetchGenrateCsrfScenario.storedTokenValues
     And header Authorization = Authorization
    And request getRequestBodyLogin.verifyDrawdownRequest
    When method post
    Then print response