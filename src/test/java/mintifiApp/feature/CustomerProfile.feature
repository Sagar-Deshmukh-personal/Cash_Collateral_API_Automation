@sanity @profile
Feature: To demonstarte2 the customer profile API

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

@profile
Scenario: [TC-CP-01] To verify the customer profile API

    # calling genrate csrf scenario from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)
    
    # After completion of Auth and login then call the Get API of  customer profile.
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCustomerProfile
    And headers getHeaders
    And header Authorization = Authorization
    When method GET
    Then status 200

   # Match and print User details
    And match response.mobile == '#regex \\d{10}'
    And def mobile = response.mobile
    And print mobile

    And match response.dateOfBirth == '#regex \\d{4}-\\d{2}-\\d{2}'
    And match response.dateOfBirth == '#string'
    And def dateOfBirth = response.dateOfBirth
    And print dateOfBirth

    And match response.email == '#regex [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'
    And match response.email == '#string'
    And def email = response.email
    And print 'Email:', email

    And match response.custId == '#string'
    And def custId = response.custId
    And print 'Customer ID:', custId

    And def panPattern = '^\\*{6}\\d{3}[A-Z]$'
     # Check if PAN is masked
    And def isMaskedPan = response.pan.startsWith('***') 
    And def isValidPan = isMaskedPan || karate.match(response.pan, panPattern).pass
    And print 'Is PAN Number Valid:', isValidPan
    And print 'PAN Number:', response.pan

    And def aadhaarPattern = '^\\*{6}\\d{4}$'
     # Check if Aadhaar is masked
    And def isMaskedAadhaar = response.aadhaar.startsWith('***') 
    And def isValidAadhaar = isMaskedAadhaar || karate.match(response.aadhaar, aadhaarPattern).pass
    And print 'Is Aadhaar Number Valid:', isValidAadhaar
    And print 'Aadhaar Number:', response.aadhaar

  # Match and print company details
   And def companyDetails = response.companyDetailResponse[0]
   And match companyDetails.compId == '#string'
   And print 'Company ID:', companyDetails.compId

   And match companyDetails.name == '#string'
   And print 'Company Name:', companyDetails.name

   And match companyDetails.mobile == '#regex \\d{10}'
   And def companyMobile = companyDetails.mobile
   And print 'Company Mobile:', companyMobile

   # Define the regex pattern for PAN validation
   And def companyPanPattern = '^\\*{6}\\d{3}[A-Z]$' 
   # Check if the company's PAN number is masked
   And def isMaskedPan = companyDetails.pan.startsWith('***')  
   # Validate the PAN number against the pattern if it's not masked
   And def isValidPan = isMaskedPan || karate.match(companyDetails.pan, companyPanPattern).pass
   # Print whether the company's PAN number is valid according to the pattern
   And print 'Is Company PAN Number Valid:', isValidPan
   # Print the company's PAN number (masked or actual)
   And print 'Company PAN Number:', companyDetails.pan
   
   And match companyDetails.email == '#regex [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'
   And def companyEmail = companyDetails.email
   And print 'Company Email:', companyEmail

   And match companyDetails.address == '#string'
   And print 'Company Address:', companyDetails.address

   And match companyDetails.type == '#string'
   And print 'Company Type:', companyDetails.type

   And def companyGstPattern = '^\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[A-Z\\d]{1}[Z]{1}[A-Z\\d]{1}$'
   # Check if GST is masked
   And def isMaskedGst = companyDetails.gstNumber.startsWith('***')
   And def isValidGst = isMaskedGst || karate.match(companyDetails.gstNumber, companyGstPattern).pass
   And print 'Is Company GST Number Valid:', isValidGst
   And print 'Company GST Number:', companyDetails.gstNumber