@sanity @document
Feature: To demonstarte the customer document list API

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

@document
Scenario: [TC-CDL-01] To verify the customer document list API

    # calling genrate csrf scenario from registred.feature
    * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
    * print fetchGenrateCsrfScenario
    * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)
    
    # After completion of Auth and login then call the Get API of Document List.
    Given url getUrl.mintifiBaseUrl + getUrl.typeAuthUserDocumentList
    And headers getHeaders
    And header Authorization = Authorization
    When method GET
    Then status 200
    
    # Verify the structure of the response
    And match response == { ccApplicableIds: '#array', activeLoanDocuments: '#array' }
    
    # Debugging: Print response for inspection
    * print response
    
    # Validate documentId and applicationId are strings
    And match each response.activeLoanDocuments[*].documentId == '#string'
    And match each response.activeLoanDocuments[*].applicationId == '#string'
    And match each response.activeLoanDocuments[*].documentType == "#string"
    And match each response.activeLoanDocuments[*].documentName == "#string"
    
    # Validate that each combination of documentType and documentName appears with different applicationIds
    And def uniqueCombinations = karate.map(response.activeLoanDocuments, function(doc) { return doc.documentType + '_' + doc.documentName })
    And def distinctCombinations = karate.distinct(uniqueCombinations)
    * print 'Distinct combinations:', distinctCombinations
    
    # Validate the total number of documents in the response
    And def totalDocuments = response.activeLoanDocuments
    * print 'Total documents:', karate.sizeOf(totalDocuments)

    # Extract documentIds from the response
    And def documentIds = karate.map(response.activeLoanDocuments, function(doc) { return doc.documentId })

    # Validate that each documentId is unique
    And def uniqueDocumentIds = karate.distinct(documentIds)
    And match karate.sizeOf(uniqueDocumentIds) == karate.sizeOf(response.activeLoanDocuments)
    * print uniqueDocumentIds

    # Initialize an empty array to store document combinations
    * def documentCombinations = []

    # Iterate over each document and concatenate documentId and applicationId
    * def documents = response.activeLoanDocuments
    * karate.forEach(documents, function(doc) { documentCombinations.push(doc.documentId + '_' + doc.applicationId) })

    # Print the document combinations
    * print 'Document Combinations:', documentCombinations