@sanity @invoice
Feature: To demonstarte invoice api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
        
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 

@invoice
Scenario: [TC-DDR-01] To verify the invoice API

calling genrate csrf secanrio from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateInvoice
    And header Content-Type = 'multipart/form-data'
    And header Authorization = Authorization

    # Generate dynamic values for gstInvoiceId, invoiceDate, and dueDate
    * def dynamicGstInvoiceId = 'gstId_' + Math.floor(Math.random() * 1000)  // Example dynamic GST Invoice ID
    * def LocalDate = Java.type('java.time.LocalDate')
    * def dynamicInvoiceDate = LocalDate.now().toString() // Current date as invoice date
    * def dynamicDueDate = LocalDate.now().plusDays(7).toString() // Due date 7 days now


    # Define the invoice form data
    And multipart field anchorId = '38'
    And multipart field loanApplicationId = '66131'
    And multipart field invoiceDate = dynamicInvoiceDate
    And multipart field dueDate = dynamicDueDate
    And multipart field total = '500'
    And multipart field gstInvoiceId = dynamicGstInvoiceId
    And multipart field qrInvoice = false

# Send the POST request with form data
    When method post
 # Verify the response status code
    Then status 200

# Print the response for debugging
    Then print "Response: ", response