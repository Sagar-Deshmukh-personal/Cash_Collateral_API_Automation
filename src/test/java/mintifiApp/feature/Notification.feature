@sanity @notification
Feature: To demonstarte the customer Notification API

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

@notification
Scenario: [TC-NF-01] To verify the Notification API

    # calling genrate csrf scenario from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)
    
    # After completion of Auth and login then call the Get API of  customer profile.
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthNofification
    And headers getHeaders
    And header Authorization = Authorization
    When method GET
    Then status 200

    # Capture the initial value of noOfInvoices
    * def initialNoOfNotification = response.totalCount

    # Ensure noOfInvoices remains the same as the initial value
    * def newNoOfNotification = response.totalCount
    * assert newNoOfNotification == initialNoOfNotification

    * def notifications = response.notifications
    # Loop through each notification and validate the category
    * def expectedCategories = ["INVOICE_UPLOAD_SUCCESS", "REPAYMENT_SUCCESS", "DRAWDOWN_SUCCESS", "INVOICE_UPLOAD_SUCCESS", "REPAYMENT_SUCCESS", "REPAYMENT_SUCCESS", "REPAYMENT_SUCCESS", "REPAYMENT_SUCCESS", "REPAYMENT_SUCCESS", "REPAYMENT_SUCCESS", "INVOICE_UPLOAD_SUCCESS", "REPAYMENT_SUCCESS"]
    * def actualCategories = karate.map(notifications, function(x){ return x.category })
    * karate.forEach(actualCategories, function(category){ karate.log('Actual Category: ', category) })
    * karate.forEach(expectedCategories, function(category){ karate.log('Expected Category: ', category) })
    * match actualCategories == expectedCategories