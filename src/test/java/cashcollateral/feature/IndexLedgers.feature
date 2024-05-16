@sanity @ledgers
Feature: To Check the CC Ledgers Index API
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@ledgers
Scenario: [TC-Ld-01] Verify the CC ledger Index API with dynamic query like "page" and "per" send in query parameter and match paremeter
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCLedgersApi
          And headers getHeaders
          And request { q: { loan_account_number_eq: '' }, page: 1, per: 10 }
          When method GET
          Then status 200
          And match response.data[*].id contains '#[]'
          And match response.data[*].id contains '#[10]'
          And def idCount = karate.sizeOf(response.data)
          And print 'Count of id entries: ', idCount

@ledgers
Scenario: [TC-Ld-02] Verify the CC ledger Index API with dynamic query like loan_account_number_eq 
          send in query parameter and get specific data
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCLedgersApi
          And headers getHeaders
          And request { q: { loan_account_number_eq: 'OD428061' }, page: '', per: '' }
          When method GET
          Then status 200
          * print response
          * def responseCount = response.meta.total_count
          * print 'Response Count: ', responseCount
@ledgers
Scenario: [TC-Ld-03] Verify the CC ledger Index API without sending any parameter
           Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCLedgersApi
           And headers getHeaders
           And request { q: { loan_account_number_eq: '' }, page: '', per: '' }
           When method GET
           Then status 200
           * print response
           * def responseCount = response.meta.total_count
           * print 'Response Count: ', responseCount
           And def idCount = karate.sizeOf(response.data)
           And print 'Count of id entries: ', idCount
