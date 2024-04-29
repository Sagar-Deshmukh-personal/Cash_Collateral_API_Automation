@sanity @invoicedrawdown
Feature: To demonstarte Drawdown api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
@invoicedrawdown
Scenario: [TC-invoice-01] To verify the invoice and create drawdown API

    # calling genrate csrf secanrio from registred.feature

    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateInvoice
    And header Content-Type = 'multipart/form-data'
    And header Authorization = Authorization

    # Generate dynamic values for gstInvoiceId, invoiceDate, and dueDate
    * def dynamicGstInvoiceId = 'gstId_<img>' + Math.floor(Math.random() * 5000)  // Example dynamic GST Invoice ID
    * def LocalDate = Java.type('java.time.LocalDate')
    * def dynamicInvoiceDate = LocalDate.now().toString() // Current date as invoice date
    * def dynamicDueDate = LocalDate.now().plusDays(10).toString() // Due date 7 days now
    * print dynamicGstInvoiceId
    * def StoreInvoiceValue = dynamicGstInvoiceId


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

# Store the some data to use another request
    * def distributorCompanyId = response.data.attributes.distributor_company_id
    * print 'Distributor Company ID:', distributorCompanyId
    * def anchorId = response.data.attributes.anchor_id
    * print 'Anchor ID:', anchorId
    * def invoice_id = response.data.attributes.id
    * print invoice_id

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCreateDrawdown // Here DDR API get call
    And headers getHeaders
    And header Authorization = Authorization
                                                                    
    Given def requestPayload =
    """
    {
        "drawdown_invoice": [
            {
                "invoice_details": [
                    {
                        "id": "#(invoice_id)",
                        "user_requested_amount": "500"  
                    }
                ],
                "bank_account_id": "30684"   
            }
        ],
        "distributor_company_id":  "#(distributorCompanyId)", 
        "anchor_id": "#(anchorId)" 
    }
    """
   And request requestPayload
   When method post
   Then status 200
