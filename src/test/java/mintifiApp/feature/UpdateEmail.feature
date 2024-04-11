@sanity @uemail
Feature: To demonstarte update email id api testcases 

Background:
    Declarations and file read of headers/ cookies
        * def fetchDataFromPrerequisiteFile = read('../other/prerequsite.json')
        * def getUrl = fetchDataFromPrerequisiteFile.config
        * def getHeaders = fetchDataFromPrerequisiteFile.actualHeaders
    
    #Declarations and file read of 'Login.json' request body
    * def getRequestBodyLogin = read('../request/requestBodyLogin.json')
    
    #Declarations and file read of 'Login.json' response body
    * def getResponseBodyLogin = read('../response/responseBodyLogin.json') 

@uemail
Scenario: [TC-UPM-01] Verify updatemobile no for the customer

    # calling genrate csrf secanrio from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

   # Function to generate a random email address
    * def generateRandomEmail =
    """
    function() {
    var uuid = java.util.UUID.randomUUID().toString();
    return 'admire' + uuid.substring(0, 8) + '@gmail.com';
    }
    """ 
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthUpdateMobile
        * headers getHeaders
        * headers fetchGenrateCsrfScenario.storedLoginTokenValues
         And header Authorization = Authorization
         And def updateEmailRequest = getRequestBodyLogin.verifyUpdateEmail
         And updateEmailRequest.email = generateRandomEmail()  // Generate new email
         And request updateEmailRequest
         When method post
         Then print response

    # Here Storing request id and useing this value to another API   
    * def storedRequestidValues = response.requestId
    * print storedRequestidValues

    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthConfirmMobile
         * headers getHeaders
         * header Authorization = 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token
         * def requestBody = getRequestBodyLogin.verifyconfirmEmail
         * requestBody.requestId = storedRequestidValues
         * request requestBody
         Then print requestBody
         When method PUT
         Then print response
         And assert responseStatus == 200