@sanity @dailycron
Feature: To Check the daily interest accrued cron API(calculate_daily_accrued_interest). 
# In this API, we need to calculate the daily accrued interest amount and store that entry in the cashcollateral database.
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
@dailycron
Scenario: [TC-DC-01] To verify the daily interest accrued cron(calculate_daily_accrued_interest) 
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthdailyinterestcron
        And headers getHeaders
        When method post
        Then status 200
        And print response
        * def expectedResponse = getResponseBodyLogin.verifydailycronresponse
        * print expectedResponse
    # Validate error response message
        And match response == expectedResponse