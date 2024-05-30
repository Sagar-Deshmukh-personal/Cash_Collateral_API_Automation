Feature: To Check the CC Adjustment API. 
# In this API we have check the customer Adjustment amount entry come for cashcollateral database.
Background:
    #Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of "json" request body
        * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    #Declarations and file read of 'json' response body
        * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
    
@Adjustment
Scenario: [TC-CAD-01] To verify the CC Adjustment API success response.

# Call the feature file to fetch stored loan account number
    * def fetch_value = call read('DebitandCredit.feature@calldebitcredit')
    * print 'fetchvalue:', fetch_value
    * def daily_cron = call read('DailyInterestcron.feature@dailycron')
    * print 'dailycron:', daily_cron
    * def daily_summery = call read('DailyInterestsummary.feature@dailysummary')
    * print 'dailysummery:', daily_summery
  
# Extract necessary attributes from the response
    * def loan_account_no = fetch_value.response.data.attributes.loan_account_number
    * print 'Loan Account Number:', loan_account_no
    * def loan_amount = fetch_value.response.data.attributes.amount
    * print 'Loan Amount:', loan_amount
    * def interest_rate = fetch_value["interestrate"]
    * print 'Interest Rate',interest_rate

# Ensure loanamount and interest_rate are numbers
     * def loan_amount = Number(loan_amount)
     * def interest_rate = Number(interest_rate)
# Calculate the daily interest rate
     * def daily_interest_rate = interest_rate / 365
     * print 'Daily Interest Rate:', daily_interest_rate

# Calculate the interest amount for one day
     * def interest_amount = loan_amount * (daily_interest_rate / 100)
     * def interest_amount =  Math.round(interest_amount * 100) / 100
     * print 'Interest Amount for One Day:', interest_amount

# Calculate the total amount ensuring proper precision
     * def total_amount = loan_amount + interest_amount
     * print total_amount

# Prepare the request
     Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCCAdjustmentApi
     And headers getHeaders
     And def requestBody = getRequestBodyLogin.validateadjustmentrequest

# Set the values in the request body
     And requestBody.cc_adjustment.from_loan_account_number = loan_account_no
     And requestBody.cc_adjustment.to_loan_account_number = loan_account_no
     And requestBody.cc_adjustment.principal = loan_amount
     And requestBody.cc_adjustment.total_amount = total_amount
     And requestBody.cc_adjustment.interest = interest_amount

# Get the current date
     And def currentDate = java.time.LocalDate.now()
# Format the date to yyyy-MM-dd
     And def formattedDate = currentDate.toString()

# Set the updated disbursement date in the request
     And requestBody.cc_adjustment.adjustment_date = formattedDate

# Set Remark value
     * def remark = loan_account_no + ' adjustment'
     And requestBody.cc_adjustment.remark = remark
     * print remark

# Send the request
     And request requestBody
     When method post
     Then status 200
     And print response