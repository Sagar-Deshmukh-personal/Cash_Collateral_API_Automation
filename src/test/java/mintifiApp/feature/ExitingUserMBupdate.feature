@upm
Feature: To demonstarte update mobile for alrady exiting user

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
@upm
Scenario: [TC-UPMEU-01] Verify updatemobile for alrady exiting user.
        
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

                # Verification of Message node in  Alrady Existing User mobile no api
                * def expectedMessage = getResponseBodyLogin.verifyExistingUserMobileNoResponse.message
                * print expectedMessage
                * def actualMessage = response.message
                * print actualMessage

                # Verification of Status Code node in  Alrady Existing User mobile no api
                * def expectedStatusCode = getResponseBodyLogin.verifyExistingUserMobileNoResponse.statusCode
                * print expectedStatusCode
                * def actualStatusCode = response.statusCode
                * print actualStatusCode

                # Verification ofFiled Name node in  Alrady Existing User mobile no api
                * def expectedfieldName = getResponseBodyLogin.verifyExistingUserMobileNoResponse.fieldName
                * print expectedfieldName
                * def actualfieldName = response.fieldName
                * print actualfieldName
