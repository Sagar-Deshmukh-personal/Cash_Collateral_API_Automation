@sanity @invoice
Feature: To demonstarte invoice api testcases 

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

@invoice
Scenario: [TC-DDR-01] To verify the invoice API

calling genrate csrf secanrio from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateInvoice
    And headers getHeaders
    And header Authorization = Authorization

    # Define the invoice form data
    * def anchorId = '38'
    * def loanApplicationId = '66131'
    * def invoiceDate = '2024-04-01' 
    * def dueDate = '2024-04-21'
    * def total = '100' 
    * def gstInvoiceId = 'trtyy66' 
    * def qrInvoice = 'false'

# Define the multipart form data
    * multipart field anchorId = anchorId
    * multipart field loanApplicationId = loanApplicationId
    * multipart field invoiceDate = invoiceDate
    * multipart field dueDate = dueDate
    * multipart field total = total
    * multipart field gstInvoiceId = gstInvoiceId
    * multipart field qrInvoice = qrInvoice

# Encode the form data into a string
#* def formDataString = 'anchorId=' + invoiceFormData.anchorId + '&loanApplicationId=' + invoiceFormData.loanApplicationId + '&invoiceDate=' + invoiceFormData.invoiceDate + '&dueDate=' + invoiceFormData.dueDate + '&total=' + invoiceFormData.total + '&gstInvoiceId=' + invoiceFormData.gstInvoiceId + '&qrInvoice=' + invoiceFormData.qrInvoice + '&file=' + invoiceFormData.file 
#* karate.log('Form Data String:', formDataString)

# Send the POST request with form data
    When method post
    Then status 200

# Print the response for debugging
    Then print "Response: ", response