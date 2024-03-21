@sanity @loginotp
Feature: To demonstarte login with otp testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
@loginotp
Scenario: [TC-LO-01] To verify the validation for 'statusLoginAPI' of mobile no via otp
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthSendOtpAPI
    * headers getHeaders
    And request getRequestBodyLogin.verifySendOtp
    When method post
    Then print response
    And assert responseStatus == 200

    
# In response message node is been verified.    
* def expectedOtpMessage = getResponseBodyLogin.verificationStatusResponseOtp.message
* print expectedOtpMessage
* def actualOtpMessage = response.message
* print actualOtpMessage

#Account lock response node is been verified
* def expectedOtpAccLock = getResponseBodyLogin.verificationStatusResponseOtp.accountLocked
* print expectedOtpAccLock
* def actualOtpAccLock = response.accountLocked
* print actualOtpAccLock

# In response Request id node is been verified
* def expectedOtpRequestId = getResponseBodyLogin.verificationStatusResponseOtp.requestId
* print expectedOtpRequestId
* def actualOtpRequestId = response.requestId
* print actualOtpRequestId

# In response blockedTime node is been verified
* def expectedOtpBlocktime = getResponseBodyLogin.verificationStatusResponseOtp.blockedTime
* print expectedOtpBlocktime
* def actualOtpBlocktime = response.blockedTime
* print actualOtpBlocktime

# In response status code node is been verified
* def expectedOtpStatusCode = getResponseBodyLogin.verificationStatusResponseOtp.statusCode
* print expectedOtpStatusCode
* def actualOtpStatusCode = response.statusCode
* print actualOtpStatusCode

    * def storedRequestidValues = response.requestId
    * print storedRequestidValues

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthVerifyOtpAPI
    * headers getHeaders
    * def requestBody = getRequestBodyLogin.verifyOtp
    * requestBody.requestId = storedRequestidValues
    * request requestBody
    Then print requestBody
    When method post
    Then print response
    And assert responseStatus == 200

# Verification of message node in verify otp API
* def expectedOtpMessage = getResponseBodyLogin.verifyStatusSucessOtpResponse.message
* print expectedOtpMessage
* def actualOtpMessage = response.message
* print actualOtpMessage

# In response Token node is been verified
* def expectedOtpRequestId = getResponseBodyLogin.verifyStatusSucessOtpResponse.token
* print expectedOtpRequestId
* def actualOtpRequestId = response.token
* print actualOtpRequestId

# In response showMpin node is been verified
* def expectedOtpRequestId = getResponseBodyLogin.verifyStatusSucessOtpResponse.showMpin
* print expectedOtpRequestId
* def actualOtpRequestId = response.showMpin
* print actualOtpRequestId

# In response showMpin node is been verified
* def expectedOtpRequestId = getResponseBodyLogin.verifyStatusSucessOtpResponse.statusCode
* print expectedOtpRequestId
* def actualOtpRequestId = response.statusCode
* print actualOtpRequestId

@loginotp @fuzzyOTP
Scenario: [TC-LO-02] To verify 'Fuzzy Match' for OTP verification Api for response body with correct data
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthSendOtpAPI
    * headers getHeaders
    And request getRequestBodyLogin.verifySendOtp
    When method post
    Then print response
    
    And assert responseStatus == 200
    
    #FuzzyMatcing 
    * def expectedResponseDataTypes =
    """
      getResponseBodyLogin.verifyStatusResponseFuzzyMatchOfOtp 
    """
    * print expectedResponseDataTypes
    * def actualResponseDataTypes = response
    * print actualResponseDataTypes
    And match actualResponseDataTypes == expectedResponseDataTypes