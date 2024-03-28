
@mobileno
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
         Then print response

         # Verification of Status Code node in update mobile no api
         * def expectedStatusCode = getResponseBodyLogin.verifyUpdateMobileresponse.statusCode
         * print expectedStatusCode
         * def actualStatusCode = response.statusCode
         * print actualStatusCode 
         
         # Verification of Message node in update mobile no api
         * def expectedMessage = getResponseBodyLogin.verifyUpdateMobileresponse.message
         * print expectedMessage
         * def actualMessage = response.message
         * print actualMessage

         # Verification of Block time node in update mobile no api
         * def expectedBlockTime = getResponseBodyLogin.verifyUpdateMobileresponse.blockedTime
         * print expectedBlockTime
         * def actualBlockTime = response.blockedTime
         * print actualBlockTime

         # Verification of Account Lock node in update mobile no api
         * def expectedAccountLocked = getResponseBodyLogin.verifyUpdateMobileresponse.accountLocked
         * print expectedAccountLocked
         * def actualAccountLocked = response.accountLocked
         * print actualAccountLocked

         # Verification of Block time node in update mobile no api
         * def expectedrequestId = getResponseBodyLogin.verifyUpdateMobileresponse.requestId
         * print expectedrequestId
         * def actualrequestId = response.requestId
         * print actualrequestId
      
    # Here Storing request id and useing this value to another API   
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

          # Verification of Status code node in  verify update mobile no api
          * def expectedStatusCode = getResponseBodyLogin.verifySuccessMobileUpdateResponse.statusCode
          * print expectedStatusCode
          * def actualStatusCode = response.statusCode
          * print actualStatusCode

           # Verification of Message node in  verify update mobile no api
           * def expectedMessage = getResponseBodyLogin.verifySuccessMobileUpdateResponse.message
           * print expectedMessage
           * def actualMessage = response.message
           * print actualMessage