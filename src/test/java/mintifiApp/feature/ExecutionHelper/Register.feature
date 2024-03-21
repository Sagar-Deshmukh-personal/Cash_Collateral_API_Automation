@generateToken
Feature: To demonstarte store and feed resposne data of a request in other feature file and request as a pre-requisite
# We have NOT added @sanity annotation for the feature file as this will only act as feeded for other request and we do not want the same in cucumber report 

Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    @generateToken
    Scenario: To verify 'Login with Mobile no" with using Mpin
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthStatusApi
        * headers getHeaders
        And request getRequestBodyLogin.validMobileNumber
        When method post
        Then status 200
        And print response
        And print responseHeaders
        And print responseCookies
    
        And assert responseStatus == 200
    
    @generateToken
    Scenario: To verify 'Mpin' for login with mobile no
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthVerifyApi
        * headers getHeaders
        And request getRequestBodyLogin.verifyMobileNumberUseingMpin
        * def tempbody = getRequestBodyLogin.verifyMobileNumberUseingMpin
        * print tempbody
        When method post
        Then status 200
        And print response
    
        * fetchDataFromPrerequisiteFile.actualToken.token = response.token
        * fetchDataFromPrerequisiteFile.actualToken.refreshToken = response.refreshToken
    
        * def storedTokenValues = fetchDataFromPrerequisiteFile.actualToken
        * print storedTokenValues