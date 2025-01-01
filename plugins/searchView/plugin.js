
mPlugin = {

    // consts
    SEARCH_VIEW: "SEARCH",

    // instance members

    OnLoad: function() {
        mElResults = $( "#results" );
        mElSearch  = $( "#search" );
    },

    OnLoadReady: function() {
        this.QueryModules();

        LoadingFinished();
    },

    QueryModules: function() {
        Parameters.clear();
        Parameters.add( "q", mElSearch.value );

        get( "crates", ( response ) => {

            mPlugin.RenderModules( response );
            
        } );
    },

    RenderModules: function( modules ) {
        var tplResult = Templates.clone( "template-search-result" );

        var listItems = "";
        for ( var idx = 0; idx < modules.crates.length; ++idx ) {
            var entry = modules.crates[ idx ];

            listItems += tplResult.clone()
                            .bind( "CRATE", entry.name )
                            .bind( "DESCRIPTION", entry.description )
                            .bind( "VERSION", entry.max_version )
                            .str();
        }

        mElResults.innerHTML = listItems;
    },

    ViewCrate: function( crate ) {
        Parameters.clear();
        Parameters.add( "crate", crate );

        LoadPluginWithHistory( "crateView" );
    }

};

mCurrentPlugin = mPlugin;
