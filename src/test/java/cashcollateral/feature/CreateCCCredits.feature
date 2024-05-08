
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
Scenario: [TC-CCE-01] To verify the CC cedits API

    # Call the feature file to fetch stored loan account number
        * def fetchvalue = call read('CreateCCEconomices.feature@token')
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