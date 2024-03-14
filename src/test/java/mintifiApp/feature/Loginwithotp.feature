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

    * def storedRequestidValues = response.requestId
    * print storedRequestidValues

# In response message node is been verified.    
* def expectedOtpMadate = getResponseBodyLogin.verificationStatusResponseOtp.message
* print expectedOtpMadate
* def actualOtpMandate = response.message
* print actualOtpMandate

And assert actualOtpMandate == expectedOtpMadate

#Account lock response node is been verified
* def expectedOtpMadate = getResponseBodyLogin.verificationStatusResponseOtp.accountLocked
* print expectedOtpMadate
* def actualOtpMandate = response.accountLocked
* print actualOtpMandate

And assert actualOtpMandate == expectedOtpMadate

# In response Request id node is been verified
* def expectedOtpMadate = getResponseBodyLogin.verificationStatusResponseOtp.requestId
* print expectedOtpMadate
* def actualOtpMandate = response.requestId
* print actualOtpMandate

And assert actualOtpMandate != expectedOtpMadate

# In response blockedTime node is been verified
* def expectedOtpMadate = getResponseBodyLogin.verificationStatusResponseOtp.blockedTime
* print expectedOtpMadate
* def actualOtpMandate = response.blockedTime
* print actualOtpMandate

And assert actualOtpMandate == expectedOtpMadate

# In response status code node is been verified
* def expectedOtpMadate = getResponseBodyLogin.verificationStatusResponseOtp.statusCode
* print expectedOtpMadate
* def actualOtpMandate = response.statusCode
* print actualOtpMandate

And assert actualOtpMandate == expectedOtpMadate
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
      
@loginotp @otpverify  
Scenario: [TC-LO-03] To verify the validation for 'Snd and verify Otp verify API' of mobile no via otp
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
    * def requestBody = getRequestBodyLogin.verifyOtp
    * requestBody.requestId = storedRequestidValues
    * request requestBody
    Then print requestBody
    When method post
    Then print response
    
    And assert responseStatus == 200

