function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'reg2';
  }
  var config = {
    env: env
  }
  if(env == 'dev'){
    config.apigeeurl= "https://dev1-api.cvshealth.com/";
  }
  if (env == 'uat') {
    config.uatUrl = "https://www-uat4.cvs.com/";
    config.apigeeurl= "https://dev1-api.cvshealth.com/";
  } 
   if (env == 'reg2') {
   config.regUrl = "https://www-reg2.cvs.com/";
  }
  
  karate.configure('ssl',true)
  return config;
}