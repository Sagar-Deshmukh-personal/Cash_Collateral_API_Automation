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
* def fetchGenrateCsrfScenario = call read('ExecutionHelper/Register.feature@generateToken')
* print fetchGenrateCsrfScenario
* karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedTokenValues.token)

Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateInvoice
And headers getHeaders
And headers { 'Content-Type': 'application/x-www-form-urlencoded' } // Setting content type to form-urlencoded
And header Authorization = Authorization


# Define the invoice form data
* def invoiceFormData = { anchorId: '38', loanApplicationId: '65974', invoiceDate: '2024-03-21', dueDate: '2024-04-21', total: '100', file:'',  gstInvoiceId: 'trtyy66', qrInvoice: 'false'}
* karate.log('Request Body:', invoiceFormData)

# Encode the form data into a string
* def formDataString = 'anchorId=' + invoiceFormData.anchorId + '&loanApplicationId=' + invoiceFormData.loanApplicationId + '&invoiceDate=' + invoiceFormData.invoiceDate + '&dueDate=' + invoiceFormData.dueDate + '&total=' + invoiceFormData.total + '&gstInvoiceId=' + invoiceFormData.gstInvoiceId + '&qrInvoice=' + invoiceFormData.qrInvoice + '&file=' + invoiceFormData.file 
* karate.log('Form Data String:', formDataString)

# Send the POST request with form data
When method post
And request formDataString  // Sending the invoiceFormData directly as request body

# Print the response for debugging
Then print "Response: ", response