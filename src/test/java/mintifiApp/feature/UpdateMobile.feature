
@sanity @mobileno
Feature: To demonstarte update mobile no api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 

@mobileno
Scenario: [TC-UPM-01] Verify updatemobile no for the customer

    # calling genrate csrf secanrio from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)
     
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthUpdateMobile
        * headers getHeaders
        * headers fetchGenrateCsrfScenario.storedLoginTokenValues
         And header Authorization = Authorization
         And request getRequestBodyLogin.verifyUpdateMobileno
         When method post
         Then status 200
         Then print response

         * def storedRequestidValues = response.requestId
         * print storedRequestidValues

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthConfirmMobile
         * headers getHeaders
         * header Authorization = 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token
         * def requestBody = getRequestBodyLogin.verifyConfirmUpdateMobileno
         * requestBody.requestId = storedRequestidValues
         * request requestBody
         Then print requestBody
         When method PUT
         Then print response
@upm
Scenario: [TC-UPM-02] Verify updatemobile for alrady exiting user.

        # calling genrate csrf secanrio from registred.feature
        * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
        * print fetchGenrateCsrfScenario
        * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)
             
         Given url getUrl.mintifiBaseUrl + getUrl.typeAuthUpdateMobile
         * headers getHeaders
         * headers fetchGenrateCsrfScenario.storedLoginTokenValues
         And header Authorization = Authorization
         And request getRequestBodyLogin.verifyExistingUserMobileNo
         When method post
         Then print response