@sanity @cceco
Feature: To Check the CC Economic API
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    @cceco
    Scenario:[TC-TLG-01] To verify the CC Ecomices API
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsApi
        And headers getHeaders
        # Create a deep copy of the request body
        And def requestBody = getRequestBodyLogin.validcc_economics
        # Set the starting random number
        And def startingRandomNumber = 132233
        # Increment the random number by 1
        And def incrementedRandomNumber = startingRandomNumber + 1
        # Use the incremented random number for loan_account_number
        And requestBody.cc_economic.loan_account_number = 'OD' + incrementedRandomNumber
        # Use the same incremented random number for loan_application_id
        And requestBody.cc_economic.loan_application_id = incrementedRandomNumber
        And request requestBody
        When method post
        Then status 200
        And print response
        And assert responseStatus == 200
        