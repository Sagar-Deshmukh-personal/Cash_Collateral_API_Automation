@sanity @cccredit
Feature: To Check the CC Credits API. 
# In this API we have check the customer credit amount entry come for cashcollateral database
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@cccredit
Scenario: [TC-CCC-01] To verify the CC cedits API success response

    # Call the feature file to fetch stored loan account number
        * def fetchvalue = call read('CreateCCEconomices.feature@passvalue')
        * def loanaccountno = fetchvalue.response.data.attributes.loan_account_number
        * print loanaccountno
        * def loanamount = fetchvalue.response.data.attributes.cc_amount
        * print loanamount

        Given url getUrl.mintifiBaseUrl + getUrl.typeCreateCreditApi
        And headers getHeaders
    # Rest of the steps
        And def requestBody = getRequestBodyLogin.validatecreatecredit
        And requestBody.cc_credit.loan_account_number = loanaccountno
        And requestBody.cc_credit.amount = loanamount
    
    # Get the current date
        And def currentDate = java.time.LocalDate.now()
    
    # Format the date to yyyy-MM-dd
        And def formattedDate = currentDate.toString()
    
    # Set the updated disbursement date in the request
        And requestBody.cc_credit.date = formattedDate
        And request requestBody
        When method POST
        Then status 200
        And print response
    # Validate that every node is either a string or an integer
        # Validate the 'data' node
        * match response.data.id == '#string'
        * match response.data.type == '#string'
        # Validate the 'attributes' node under 'data' node
        * match response.data.attributes.id == '#number'
        * match response.data.attributes.loan_account_number == '#string'
        * match response.data.attributes.amount == '#string'
        * match response.data.attributes.date == '#string'

@cccredit
Scenario: [TC-CCC-02] To verify the CC cedits API error response for empty loan account no and amount zero
        Given url getUrl.mintifiBaseUrl + getUrl.typeCreateCreditApi
        And headers getHeaders
        And request getRequestBodyLogin.emptycreditrequest
        When method post
        Then status 422
        And print response
        * def expectedResponse = getResponseBodyLogin.verifyerrorcreditResponse
        * print expectedResponse
    # Validate error response message
        And match response == expectedResponse

@cccredit
Scenario: [TC-CCC-03] To verify the CC cedits API error response for amount node
        Given url getUrl.mintifiBaseUrl + getUrl.typeCreateCreditApi
         And headers getHeaders
         And request getRequestBodyLogin.invalidamountcreditrequest
         When method post
        Then status 422
        And print response
        * def expectedResponse = getResponseBodyLogin.verifyerrorcreditResponseamount
        * print expectedResponse
    # Validate error response message
        And match response == expectedResponse
@ccccredit
Scenario: [TC-CCC-04] To verify the CC cedits API error response for date node
        Given url getUrl.mintifiBaseUrl + getUrl.typeCreateCreditApi
         And headers getHeaders
         And request getRequestBodyLogin.emptydatecreditrequest
         When method post
        Then status 500
        And print response
        * def expectedResponse = getResponseBodyLogin.verifyerrorcreditResponsedate
        * print expectedResponse
    # Validate error response message
        And match response == expectedResponse
