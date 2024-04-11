@sanity @paidinvoice
Feature: To demonstarte the customere Paid invoice API

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
        * header sec-ch-ua-mobile = '?0'
        * header Accept = 'application/json, text/plain, */*'
    
    #Declarations and file read of 'Login.json' request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 

@paidinvoice
Scenario: [TC-PI-01] To verify the Paid Invoice API

    # calling genrate csrf scenario from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)
    
    # After completion of Auth and login then call the Get API of  customer profile.
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCheckPaidInvoice
    And headers getHeaders
    And header Authorization = Authorization
    When method GET
    Then status 200

    # Capture the initial value of noOfInvoices
    * def initialNoOfInvoices = response.noOfInvoices

    # Ensure noOfInvoices remains the same as the initial value
    * def newNoOfInvoices = response.noOfInvoices
    * assert newNoOfInvoices == initialNoOfInvoices