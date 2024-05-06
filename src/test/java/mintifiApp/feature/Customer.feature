@sanity @customer
Feature: To demonstarte Customer api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 
@customer
Scenario: [TC-customer-01] To verify the customer API

    # calling genrate csrf secanrio from registred.feature

    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

     Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCustomer
     And headers getHeaders
     And header Authorization = Authorization

    #Send the GET request with form data
     When method GET
 
    # Verify the response status code
     Then status 200
 
    # Print the response for debugging
     Then print "Response: ", response

     * def loanDetails = response.loanDetails

    # Iterate over each loan detail
    * eval
      """
       loanDetails.forEach(detail => {
      var accountNumbersType = typeof(detail.accountNumbers[0]);
      karate.log('AccountNumbers type for applicationId ' + detail.applicationId + ': ' + accountNumbersType);
      });
     """

     * def loanDetails = response.loanDetails

    # Iterate over each loan detail
    * eval
      """
        loanDetails.forEach(detail => {
            var customerConsentValue = detail.customerConsent === true || detail.customerConsent === false ? detail.customerConsent : 'Invalid';
            var bnplLoanValue = detail.bnplLoan === true || detail.bnplLoan === false ? detail.bnplLoan : 'Invalid';
            var typeValue = detail.type === 'Unsecured' || detail.type === 'Secured' ? detail.type : 'Invalid';
            karate.log('Customer Consent value for applicationId ' + detail.applicationId + ': ' + customerConsentValue + '\n');
            karate.log('BNPL Loan value for applicationId ' + detail.applicationId + ': ' + bnplLoanValue + '\n');
            karate.log('Type value for applicationId ' + detail.applicationId + ': ' + typeValue + '\n');
        });        
     """

    * def loanDetails = response.loanDetails
    # Checking loan account status
    * eval
    """
        loanDetails.forEach(detail => {
            var accountStatusValue = detail.accountStatus === 'active' || detail.accountStatus === 'matured' || detail.accountStatus === 'closed' ? detail.accountStatus : 'Invalid';
            karate.log('Account Status value for applicationId ' + detail.applicationId + ': ' + accountStatusValue + '\n');
        });       
   """
    * def totalAvailableLimit = response.totalAvailableLimit
    * def totalDues = response.totalDues
    * def totalLoanAmount = response.totalLoanAmount

    # Check if totalAvailableLimit is greater than zero and then print it
       * assert totalAvailableLimit > 0
       * print 'Total Available Limit: ', totalAvailableLimit

    # Check if totalLoanAmount is greater than zero and then print it
       * assert totalLoanAmount > 0
       * print 'Total Loan Amount: ', totalLoanAmount

    # Check if totalDues is greater than zero and then print it
       * assert totalDues > 0
       * print 'Total Dues: ', totalDues