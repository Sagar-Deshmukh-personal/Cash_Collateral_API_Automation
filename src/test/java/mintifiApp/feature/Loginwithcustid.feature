@sanity @logincustid
Feature: To demonstarte login for Cust id testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 

@logincustid
Scenario: [TC-LO-01] To verify the validation for 'statusLoginAPI' of Custid
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthStatusCustidApi
    * headers getHeaders
    And request getRequestBodyLogin.validCustid
    When method post
    Then print response

    And assert responseStatus == 200

# MPIN mandate response node is been verified.
* def expectedMpinMadate = getResponseBodyLogin.verifyStatusResponse.mpinRequired
* print expectedMpinMadate
* def actualMpinMandate = response.mpinRequired
* print actualMpinMandate

And assert actualMpinMandate == expectedMpinMadate

# Account Lock  response node is been verified.
* def expectedAccountLocked = getResponseBodyLogin.verifyStatusResponse.accountLocked
* print expectedAccountLocked
* def actualAccountLocked = response.accountLocked
* print actualAccountLocked

And assert actualAccountLocked == expectedAccountLocked

@logincustid @fuzzyStatus
Scenario: [TC-LO-02] To verify 'Fuzzy Match' for Status verification for valid data
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthStatusCustidApi
    * headers getHeaders
    And request getRequestBodyLogin.validCustid
    When method post
    Then print response

    And assert responseStatus == 200

#FuzzyMatcing 
    * def expectedResponseDataTypes =
    """
       getResponseBodyLogin.verifyStatusResponseFuzzyMatch 
    """
    * print expectedResponseDataTypes
    * def actualResponseDataTypes = response
    * print actualResponseDataTypes
    And match actualResponseDataTypes == expectedResponseDataTypes
   
@logincustid
Scenario: [TC-LO-03] To verify Mpin verification for valid data of Custid Api
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthVerifyCustidApi
    * headers getHeaders
    And request getRequestBodyLogin.verifyCustidUseingMpin
    When method post
    Then print response

    And assert responseStatus == 200

    * fetchDataFromPrerequisiteFile.actualToken.token = response.token
    * fetchDataFromPrerequisiteFile.actualToken.refreshToken = response.refreshToken

    * def storedTokenValues = fetchDataFromPrerequisiteFile.actualToken
    * print storedTokenValues

# Message  response Node is been verified
* def expectedMpinMessage = getResponseBodyLogin.verifyMpinLogin.message
* print expectedMpinMessage
* def actualMpinMessage = response.message
* print actualMpinMessage

 And assert actualMpinMessage == expectedMpinMessage

# Showpin response Node is been verified
* def expectedShowMpin = getResponseBodyLogin.verifyMpinLogin.showMpin
* print expectedShowMpin
* def actualShowMpin = response.showMpin
* print actualShowMpin

And assert actualShowMpin == expectedShowMpin

@logincustid @fuzzyMPIN
Scenario: [TC-LO-04] To verify 'Fuzzy Match' for MPIN verification Api for response body with correct data
Given url getUrl.mintifiBaseUrl + getUrl.typeAuthVerifyCustidApi
* headers getHeaders
And request getRequestBodyLogin.verifyCustidUseingMpin
When method post
Then print response

And assert responseStatus == 200

#FuzzyMatcing 
* def expectedResponseDataTypes =
"""
  getResponseBodyLogin.verifyMpinLoginFuzzyMatch 
"""
* print expectedResponseDataTypes
* def actualResponseDataTypes = response
* print actualResponseDataTypes
And match actualResponseDataTypes == expectedResponseDataTypes


