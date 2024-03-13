To run the following project on your local machine please follow below instructions:

1. Installtion - https://www.udemy.com/course/karate-dsl-api-automation-and-performance-from-zero-to-hero/learn/lecture/22174564#overview
2. Git Clone - https://github.com/sagar-docsuggest/WEB_APP_API.git
   For understanding purpose I have kept target folder consisting of reports but in ideal use case when committing code 'target/' folder is excluded

3. Use following command in terminal:
    - mvn clean install
    - mvn test "-Dkarate.options=--tags @sanity"
4. Test reports will be generated inside folder '/target' open the same in browser to review
    - Cucumber report - /target/cucumber-html-reports/overview-features.html
    - Basic karate report - /target/karate-reports/karate-summary.html
5. The report will demonstarte table 'Scenarios' - Pass/Fail v/s the Feature and it will aslo display the same for 'No. of steps for those scenarios'
   Click on the feature file to read detailed steps and execution output

If any doubts please contact me on below details:
    - Owner: Deshmukh Sagar
    - Email: sagar.deshmukh@mintifi.com