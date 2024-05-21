@sanity @Summaries
Feature: To Check the CC Ledgers Index and show API
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@Summaries
Scenario: [TC-SM-01] Verify the CC Summaries Index API with dynamic query like "page" and "per" send in query parameter and match paremeter
          Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCSummariesApi
          And headers getHeaders
          And request { q: { cust_id_cont: '' }, page: 1, per: 10 }
          When method GET
          Then status 200
          * print response
          And match response.data[*].id contains '#[]'
          And match response.data[*].id contains '#[10]'
          And def idCount = karate.sizeOf(response.data)
          And print 'Count of id entries: ', idCount
@Summaries
Scenario: [TC-SM-02] Verify the CC Summaries Index API with dynamic query like cust_id_cont 
            send in query parameter and get specific data
            Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCSummariesApi
            And headers getHeaders
            And request { q: { cust_id_cont: 'DNT657' }, page: '', per: '' }
            When method GET
            Then status 200
            * print response
            * def responseCount = response.meta.total_count
            * print 'Response Count: ', responseCount
@Summaries
Scenario: [TC-SM-03] Verify the CC Summaries Index API without sending any parameter
             Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCSummariesApi
             And headers getHeaders
             And request { q: { cust_id_cont: '' }, page: '', per: '' }
             When method GET
             Then status 200
             * print response
             * def responseCount = response.meta.total_count
             * print 'Response Count: ', responseCount
             And def idCount = karate.sizeOf(response.data)
             And print 'Count of id entries: ', idCount
@showSummaries @Summaries
Scenario: [TC-SM-04] Verify the CC Summaries show API without sending any parameter
               Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCSummariesApi
               And headers getHeaders
               When method GET
               Then status 200
              * print response
  
@showSummaries @Summaries
Scenario: [TC-SM-05] Verify the CC Summaries show API without sending any parameter
            Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCLedgersApi + '/72'
            And headers getHeaders
            When method GET
            Then status 200
            * def response = response
            * print response
            * match response.data.id == '72'
            * match response.data.attributes.id == 72