@sanity @Ecoindex
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
    
@Ecoindex
Scenario: [TC-In-01] Verify the CC Economics Index API with dynamic query like "page" and "per" send in query parameter
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsIndex
          And headers getHeaders
          And request { q: { cust_id_cont: '', loan_account_number_eq: '' }, page: 1, per: 10 }
          When method GET
          Then status 200
@Ecoindex
Scenario: [TC-In-02] Verify the CC Economics Index API with dynamic query like loan_account_number_eq send in query parameter
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsIndex
          And headers getHeaders
          And request { q: { cust_id_cont: '', loan_account_number_eq: 'OD667907' }, page: '' , per: '' }
          When method GET
          Then status 200
          
@Ecoindex
Scenario: [TC-In-03] Verify the CC Economics Index API with dynamic query like loan_account_number_eq and cust_id_cont send 
          in query parameter and get specific data
          * def requestPayload = { q: { cust_id_cont: 'DNT657', loan_account_number_eq: 'OD667907' }, page: '', per: '' }
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsIndex
          And headers getHeaders
          And request requestPayload
          When method GET
          Then status 200
          And match response.data[0].attributes.loan_account_number == requestPayload.q.loan_account_number_eq
          And match response.data[0].attributes.cust_id == requestPayload.q.cust_id_cont
          And print response
@Ecoindex
Scenario: [TC-In-04] Verify the CC Economics Index API with dynamic query like cust_id_cont send into query parameter and get specific data
        * def requestPayload = { q: { cust_id_cont: 'DNT657', loan_account_number_eq: '' }, page: '', per: '' }
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsIndex
        And headers getHeaders
        And request requestPayload
        When method GET
        Then status 200
        And match response.data[0].attributes.cust_id == requestPayload.q.cust_id_cont
        And print response
@Ecoindex
Scenario: [TC-In-05] Verify the CC Economics Index API with dynamic query like cust_id_cont and page/per value send into query parameter and get specific data
        * def requestPayload = { q: { cust_id_cont: 'DNT657', loan_account_number_eq: '' }, page: 1, per: 10 }
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsIndex
        And headers getHeaders
        And request requestPayload
        When method GET
        Then status 200
        And match response.data[0].attributes.cust_id == requestPayload.q.cust_id_cont
        And print response