
mPlugin = {

    // consts
    SEARCH_VIEW: "SEARCH",

    // instance members

    OnLoad: function() {
        mElResults       = $( "#results" );
        mElSearch        = $( "#search" );
        mElSearchResultsHeader = $( "#search_results_header" );
    },

    OnLoadReady: function() {
        this.QueryModules();
    },

    QueryModules: function() {
        Parameters.clear();
        Parameters.add( "q", mElSearch.value );

        get( "crates", ( response ) => {

            mElSearchResultsHeader.innerHTML = Templates.clone( "template-search-results-header" )
                .bind( "SEARCH", mElSearch.value )
                .str();

            mPlugin.RenderModules( response );

            LoadingFinished();
        } );
    },

    RenderModules: function( modules ) {
        var tplResult = Templates.clone( "template-search-result" );

        var listItems = "";
        for ( var idx = 0; idx < modules.crates.length; ++idx ) {
            var module = modules.crates[ idx ];

            listItems += tplResult.clone()
                            .bind( "CRATE", module.name )
                            .bind( "DESCRIPTION", module.description )
                            .bind( "DOWNLOADS_ALL_TIME", module.downloads )
                            .bind( "DOWNLOADS_RECENT", module.recent_downloads )
                            .bind( "LAST_UPDATE", module.updated_at )
                            .bind( "VERSION", module.newest_version )
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
