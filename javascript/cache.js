
var Cache = {

    // CONSTS

    // instance members
    // here you can add your instance members that you want to fetch and cache
    summary: null,
    validated: false,

    Constructor: function() {
        this.Retrieve();
    },

    FetchSummary: function( callback ) {
        get( "summary", ( response ) => {

            Cache.summary = response;

            if ( callback ) {
                callback();
            }

        } );
    },

    Reload: function( OnProgress ) {
        // fetch data which does not depend on anything loaded yet

        this.FetchSummary( OnProgress );   // this is an example of asynchronous data loading during startup
    },

    Retrieve: function() {
        if ( !localStorage.cache ) {
            return;
        }

        var cache = JSON.parse( localStorage.cache );
        if ( !cache ) {
            return;
        }

        this.summary   = cache.summary;
        this.validated = true;
    },

    Store: function() {
        localStorage.cache = JSON.stringify( this );
    }

};
