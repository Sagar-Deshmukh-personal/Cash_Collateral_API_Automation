@drawdown
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
Scenario: [TC-LO-01] To verify the drawdown API
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthSendOtpAPI
    * headers getHeaders
    And request getRequestBodyLogin.verifySendOtp
    When method post
    Then print response
    And assert responseStatus == 200
    * def storedRequestidValues = response.requestId
    * print storedRequestidValues

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthVerifyOtpAPI
    * headers getHeaders
    And  def requestBody = getRequestBodyLogin.verifyOtp
    * requestBody.requestId = storedRequestidValues
    * request requestBody
    Then print requestBody
    When method post
    Then print response
    And assert responseStatus == 200
    
    * def tokenvalue = response.token
    * print tokenvalue
    * karate.set('Authorization', 'Bearer ' + tokenvalue)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateDrawdown
    * headers getHeaders
    And header Authorization = Authorization
    And request getRequestBodyLogin.verifyDrawdownRequest
    When method post
    Then print response