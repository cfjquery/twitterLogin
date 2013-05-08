<cfcomponent displayname="Application" output="true" hint="Handle the application.">
    <cfscript>
        this.Name               = "twitterLogin";
        this.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 );
        this.SessionManagement  = true;
        this.SetClientCookies   = true;
        this.TargetPage = 'index.cfm';
    </cfscript> 
    <cfsetting requesttimeout="20" showdebugoutput="true" enablecfoutputonly="false" />
    <cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Fires when application created.">
        <cfscript>
            //USED FOR ALL REDIRECTS BACK TO LOCAL PAGE
            application.redirect_uri = "http://localhost/twitterLogin/processLogin.cfm?loginType=twitter";
            //TWITTER
            session.twitter_access_token = '';
            session.twitter_access_token_secret = '';
            application.twitter_consumer_key = 'YOUR_CONSUMER_KEY';
            application.twitter_consumer_secret = 'YOUR_CONSUMER_KEY_SECRET';
            return true;
        </cfscript>
    </cffunction>   
    <cffunction name="onrequestStart">
        <cfscript>
        if(structKeyExists(url, 'reinit')) {
            onApplicationStart();
        }
        </cfscript>
    </cffunction>
    <cffunction name="OnError" access="public" returntype="void" output="true" hint="Fires when exception occurs not caught by try/catch.">
        <cfargument name="Exception" type="any" required="true" />
        <cfargument name="EventName" type="string" required="false" default="" />
        <cfsavecontent variable="theError">
            #now()#
            <cfdump var="#arguments.Exception#" />
        </cfsavecontent>
        <cffile action="write" file="C:\Program Files (x86)\Apache Software Foundation\Apache2.2\htdocs\twitterLogin\err.html" output="#theError#">
        <cfreturn />
    </cffunction>
</cfcomponent>
