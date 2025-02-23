var Cache = {
    // CONSTS

    // instance members
    // here you can add your instance members that you want to fetch and cache
    languages: [],
    settings: null,
    summary: null,
    token: null,
    userInfo: null,
    validated: false,

    Constructor: function () {
        this.Retrieve();
    },

    FetchSettings: function( callback ) {
        Parameters.clear();

        get( "admin/users/settings/", ( json ) => {

            this.settings = json.settings;

            if ( callback ) {
                callback();
            }

        }, OnError, OnAbortIgnored );
    },

    FetchSummary: function( callback ) {
        get( "summary", ( response ) => {
            Cache.summary = response;

            if ( callback ) {
                callback();
            }
        } );
    },

    FetchUserInfo: function( callback ) {
        if ( Cache.token ) {
            fetch( "https://api.github.com/user", {
                method: "GET",
                headers: {
                    "Content-type": "application/json; charset=UTF-8",
                    Authorization: "Bearer " + Cache.token,
                    "User-Agent": "modules.slang-lang.org",
                },
            } )
            .then( ( response ) => response.json() )
            .then( ( json ) => {
                console.log( json );

                Cache.userInfo = json;

                if ( callback ) {
                    callback();
                }
            } );
        }
    },

    Reload: function( OnProgress ) {
        // fetch data which does not depend on anything loaded yet

        this.FetchSummary( OnProgress );

        // fetch private data
        this.FetchUserInfo( OnProgress );
        this.FetchSettings( OnProgress );
    },

    Retrieve: function () {
        if ( !localStorage.cache ) {
            return;
        }

        var cache = JSON.parse( localStorage.cache );
        if ( !cache ) {
            return;
        }

        this.summary   = cache.summary;
        this.token     = cache.token;
        this.validated = true;
    },

    Store: function() {
        localStorage.cache = JSON.stringify( this );
    },
};
