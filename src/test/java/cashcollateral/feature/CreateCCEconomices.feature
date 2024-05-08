@sanity @cceco
Feature: To Check the CC Economic API
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@cceco @passvalue
Scenario:[TC-CCE-01] To verify the CC Ecomices API
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsApi
        And headers getHeaders
    # Create a deep copy of the request body
        And def requestBody = getRequestBodyLogin.validcc_economics
   # Generate a random number
        And def randomNumber = Math.floor(Math.random() * (999999 - 100000 + 1)) + 100000
   # Use the random number for loan_account_number
        And def loanAccountNumber = 'OD' + randomNumber
        And requestBody.cc_economic.loan_account_number = loanAccountNumber
   # Use the same random number for loan_application_id
        And requestBody.cc_economic.loan_application_id = randomNumber
    # Get the current date
        And def currentDate = java.time.LocalDate.now()
    # Format the date to yyyy-MM-dd
        And def formattedDate = currentDate.toString()
    # Set the updated disbursement date in the request
        And requestBody.cc_economic.disbursement_date = formattedDate
        And request requestBody
        When method post
        Then status 200
        And print response
        And assert responseStatus == 200
    # Storing loan application value
        * def storedloanaccountnumber = response.data.attributes.loan_account_number
        * print storedloanaccountnumber
        * def storedccamount = response.data.attributes.cc_amount
        * print storedccamount

@cceco
Scenario:[TC-CCE-02] To verify the CC Ecomices API Some request nodes send as empty or wrong(Like Negarive value)
         Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsApi
         And headers getHeaders
         And request getRequestBodyLogin.emptycc_economicsRequest
         When method post
         Then status 422
         And print response
         * def expectedResponse = getResponseBodyLogin.verifyCCEconomicsActualResponse
         * print expectedResponse
         # Validate error response message
         And match response == expectedResponse

@cceco 
Scenario:[TC-CCE-03] To verify the CC Ecomices API response for future disbursement date
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsApi
        And headers getHeaders
    # Create a deep copy of the request body
        And def requestBody = getRequestBodyLogin.validcc_economicsfuturedate
    # Generate a random number
        And def randomNumber = Math.floor(Math.random() * (999999 - 100000 + 1)) + 100000
    # Use the random number for loan_account_number
         And def loanAccountNumber = 'OD' + randomNumber
         And requestBody.cc_economic.loan_account_number = loanAccountNumber
    # Use the same random number for loan_application_id
         And requestBody.cc_economic.loan_application_id = randomNumber
    # Get the current date
         And def currentDate = java.time.LocalDate.now()
    # Set the current date as disbursement date
         And def disbursementDate = currentDate.plusDays(1) // Adding 1 day
    # Format the date to yyyy-MM-dd
         And def formattedDate = disbursementDate.toString()
    # Set the updated disbursement date in the request
         And requestBody.cc_economic.disbursement_date = formattedDate
         And request requestBody
         When method post
         Then status 422
         And print response
         And assert responseStatus == 422
    # Chcek the error response and match that response
        * def expectedResponse = getResponseBodyLogin.verifyCCEcoFuturedateResponse
        * print expectedResponse
    # Validate error response message
        And match response == expectedResponse
@cceco
Scenario:[TC-CCE-04] To verify the CC Ecomices API cust id is null
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsApi
        And headers getHeaders
        And request getRequestBodyLogin.emptycc_economicsCustid
        When method post
        Then status 422
        And print response
        * def expectedResponse = getResponseBodyLogin.verifyCCEconomicCustidNull
        * print expectedResponse
    # Validate error response message
        And match response == expectedResponse