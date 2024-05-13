@sanity @show
Feature: To Check the CC Economic Index API
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@show
Scenario: [TC-Show-01] Verify the CC Economics show API with dynamic query
         * def requestPayload = { q: { cust_id_cont: '', loan_account_number_eq: '' }, page: '', per: '' }
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsIndex
          And headers getHeaders
          And request requestPayload
          When method GET
          Then status 200
          And match response.meta.total_count == '#number'
          Then assert response.meta.total_count >= 1
          * print 'Total count:', response.meta.total_count
          And print response
