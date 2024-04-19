@sanity @creditscore
Feature: To demonstarte the customer Credit Score API

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

@creditscore
Scenario: [TC-CCS-01] To verify the customer Credit Score API

    # calling genrate csrf secanrio from registred.feature
       * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
       * print fetchGenrateCsrfScenario
       * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

    # After completion of Auth and login then call the Get API of Credit Score.
        Given url getUrl.mintifiBaseUrl + getUrl.typeAuthCheckCreditScore
        And headers getHeaders
        And header Authorization = Authorization
        When method GET
        Then status 200

    # Check if the score node exists and is not empty
        And match response.score != '' && response.score != null

     # Print the score after validation
        Then print 'Score:', response.score

    # Check if the type node exists and is not empty
        And match response.type != '' && response.type != null

     # Print the type after validation
        Then print 'Type:', response.type

    # Define a function to convert the numeric score to the corresponding category
        * def getScoreCategory = 
        """
       function(score) {
         if(score >= 851) return 'Excellent';
        else if(score >= 751) return 'Good';
        else if(score >= 651) return 'Fair';
        else if(score >= 300) return 'Poor';
        else return 'Very Poor';
       }
       """
    # Extract the score from the response and get its corresponding category
         * def score = response.score
         * def scoreCategory = call getScoreCategory score

    # Print the score and its corresponding category
         Then print 'Credit Score:', score
         And print 'Score Category:', scoreCategory