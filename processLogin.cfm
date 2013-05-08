<cfscript>
	if(IsDefined("url.loginType") and url.loginType eq "twitter"){
		//CONFIGURE twitter4j
		configBuilder = createObject("java", "twitter4j.conf.ConfigurationBuilder");
		configBuilder.setOAuthConsumerKey(#application.twitter_consumer_key#);
		configBuilder.setOAuthConsumerSecret(#application.twitter_consumer_secret#);
		config = configBuilder.build();
		twitterFactory = createObject("java", "twitter4j.TwitterFactory").init(config);
		twitter = twitterFactory.getInstance();
		// PROCESS THE LOGIN
		if(NOT structKeyExists(url, "oauth_verifier")){
			//REDIRECT THE USER TO THE TWITTER SITE FOR AUTHENTICATION
			session.requestToken = twitter.getOAuthRequestToken("#application.redirect_uri#");
			location(url="#session.requestToken.getAuthorizationURL()#" addtoken="No");
		}
		else{
			//WHEN USER RETURNS BACK FROM AUTHENTCATION, SET THE SESSION VARIABLES
			getAccessToken = twitter.getOAuthAccessToken(session.requestToken, url.oauth_verifier);
			session.twitter_access_token = getAccessToken.getToken();
			session.twitter_access_token_secret =  getAccessToken.getTokenSecret();
			//GET THE USERS ID
			session.twitter_user_id = twitter.verifyCredentials().getID();
			//GET THE USERS SCREEN NAME
			userDetails = twitter.showUser(#session.twitter_user_id#).getScreenName();
			writedump(var=userDetails);
		}
	}
</cfscript>
