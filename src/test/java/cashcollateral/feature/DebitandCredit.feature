@calldebitcredit
Feature: To Check the CC ECO and Credit API. 
# In this API we have check the Debit and Credit cashcollateral database.
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json')
@calldebitcredit
Scenario:[TC-EH-01] To verify the CC Economics API genrating random loanaccount no,cust id
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCEconomicsApi
        And headers getHeaders
    # Create a deep copy of the request body
        And def requestBody = getRequestBodyLogin.validcc_economicsgeneraterandomvalue
    # Generate a random number
        And def randomNumber = Math.floor(Math.random() * (999999 - 100000 + 1)) + 100000
    # Use the random number for loan_account_number
        And def loanAccountNumber = 'OD' + randomNumber
        And requestBody.cc_economic.loan_account_number = loanAccountNumber
     # Use the same random number for loan_application_id
        And requestBody.cc_economic.loan_application_id = randomNumber
    # Helper function to generate random customer ID
        And def generateRandomCustomerId =
        """
        function() {
          var letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          var result = '';
          for (var i = 0; i < 3; i++) {
            result += letters.charAt(Math.floor(Math.random() * letters.length));
          }
          var numbers = Math.floor(Math.random() * 900) + 100; // ensures a 3-digit number
          return result + numbers;
        }
        """
    # Generate a random customer ID
        And def randomCustomerId = generateRandomCustomerId()
    # Use the random customer ID in the request body
        And requestBody.cc_economic.cust_id = randomCustomerId
    # Set a specific backdated date (one day back)
        And def backDate = java.time.LocalDate.now().minusDays(1)
        And def formattedBackDate = backDate.toString()
    # Set the updated disbursement date in the request
        And requestBody.cc_economic.disbursement_date = formattedBackDate
        And request requestBody
        When method post
        Then status 200
        And print response
        And assert responseStatus == 200
    # Save cc_amount amd loan account no in response
        * def ccamount = response.data.attributes.cc_amount
        * print ccamount
        * def loanaccountnumber = response.data.attributes.loan_account_number
        * print loanaccountnumber
        * def interestrate = response.data.attributes.interest_rate
        * print interestrate

    # Create credit entry
        Given url getUrl.mintifiBaseUrl + getUrl.typeCreateCreditApi
        And headers getHeaders
        And def requestBody = getRequestBodyLogin.validateccentryforadjustment
        And requestBody.cc_credit.loan_account_number =loanaccountnumber
        And requestBody.cc_credit.amount =ccamount
    # Set a specific backdated date (one day back)
       And def backDate = java.time.LocalDate.now().minusDays(1)
       And def formattedBackDate = backDate.toString()

    # Set the updated disbursement date in the request to the backdated date
       And requestBody.cc_credit.date = formattedBackDate
       And request requestBody
       When method post
       Then status 200
       And print response