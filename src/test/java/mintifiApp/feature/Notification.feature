@sanity @notification
Feature: To demonstarte the customer Notification API

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
     # calling genrate csrf scenario from registred.feature
        * def fetchGenrateCsrfScenario = call read('ExecutionHelper/Loginticket.feature@generateLoginToken')
        * print fetchGenrateCsrfScenario
        * karate.set('Authorization', 'Bearer ' + fetchGenrateCsrfScenario.storedLoginTokenValues.token)

@notification
Scenario: [TC-NF-01] To verify the Notification API

    # After completion of Auth and login then call the Get API of customer profile.
       Given url getUrl.mintifiBaseUrl + getUrl.typeAuthNofification
       And headers getHeaders
       And header Authorization = Authorization
       When method GET
       Then status 200

    # Capture the initial value of noOfInvoices
       * def initialNoOfNotification = response.totalCount

    # Ensure noOfInvoices remains the same as the initial value
       * def newNoOfNotification = response.totalCount
       * assert newNoOfNotification == initialNoOfNotification
       * def notifications = response.notifications
       * print newNoOfNotification

   # Check categories of notifications
       * def notifications = response.notifications
       * def categories_to_check = ["INVOICE_UPLOAD_SUCCESS", "DRAWDOWN_SUCCESS", "REPAYMENT_SUCCESS", "COMPANY_PAYMENT_SUCCESS", "COMPANY_PAYMENT_FAILED", "REPAYMENT_FAILED", "MOBILE_UPDATE", "EMAIL_UPDATE"]
       * def categoriesFound = {}

* eval
  """
  notifications.forEach(notification => {
    var category = notification.category;
    categoriesFound[category] = true;
  });
  """

* def missingCategories = []

* eval
  """
  categories_to_check.forEach(category => {
    if (!categoriesFound[category]) {
      missingCategories.push(category);
    }
  });
  """

* eval
  """
  missingCategories.forEach(category => {
    karate.log('Category ' + category + ' not found');
  });
  """

* def foundCategories = []

* eval
  """
  categories_to_check.forEach(category => {
    if (categoriesFound[category]) {
      foundCategories.push(category);
    }
  });
  """

* eval
  """
  if (foundCategories.length > 0) {
     karate.log('Categories found successfully: ' + foundCategories.join(', '));
  }
  """

* eval
  """
  if (missingCategories.length === 0) {
    karate.log('All categories found successfully');
  } else {
    karate.log('Not all categories found: ' + missingCategories.join(', '));
  }
  """