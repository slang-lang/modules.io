
mPlugin = {

    // consts
    START_VIEW: "start",

    // instance members

    OnLoad: function() {
        this.mElModules = $( "#modules" );
    },

    OnLoadReady: function() {
        this.QueryModules();

        LoadingFinished();
    },

    Fetch: function( url, callbackSuccess, callbackError = OnErrorIgnored, callbackAbort = OnAbortIgnored ) {
     fetch( url, {
        Method: "GET",
        Headers: {
        //   Accept: "application.json",
          "Content-Type": "text/html"
        },
        Body: null,
        Cache: "default"
      } )
        .then( response => {
            if ( !response.ok ) {
                throw new Error( "HTTP error " + response.status );
            }

            return response.text();
        } )
        .then( data => {
            callbackSuccess( data );
        } )
        .catch( error => {
            callbackError( error );
        } );
    },

    QueryModules: function() {
        this.Fetch( "https://slang-lang.org/repo/stable/", ( response ) => {
            mPlugin.mElModules.innerText = response;
        } );
    }

};

mCurrentPlugin = mPlugin;
