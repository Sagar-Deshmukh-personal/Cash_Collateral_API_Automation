function fn() {
  
    var env = karate.env; // get java system property 'karate.env'
    karate.log('karate.env system property was:', env);
    if (!env) {
      env = 'dev';
    }
  
    var config = {
      //voyagerBaseUrl: 'https://api.escuelajs.co/api/v1',
      // appId: 'my.app.id',
      // appSecret: 'my.secret'
    }
  
    if (env == 'dev') {
      // over-ride only those that need to be
    } else if (env == 'live') {
        // over-ride only those that need to be
    }
    return config;

  }