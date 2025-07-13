
mPlugin = {

    // consts
    OVERVIEW_VIEW: "overviewView",

    // instance members
    pluginName: "overviewView",

    OnLoad: function() {
        this.mElModules = $( "#modules" );
        this.mElPlugin  = $( "plugin" );

        this.mElJustUpdated            = $( "#just_updated" );
        this.mElMostDownloaded         = $( "#most_downloaded" );
        this.mElMostRecentlyDownloaded = $( "#most_recently_downloaded" );
        this.mElNewCrates              = $( "#new_crates" );
        this.mElPopularCategories      = $( "#popular_categories" );
        this.mElPopularKeywords        = $( "#popular_keywords" );
    },

    OnLoadReady: function() {
        this.QueryModules();

        LoadingFinished();
    },

    QueryModules: function() {
        Parameters.clear();
        
        get( "summary/", ( response ) => {

            mPlugin.RenderModules( response );

        } );
    },

    RenderModules: function( data ) {
        var tplModule = Templates.clone( "template-crate-list-item" );

        {   // just updated
            var listItems = "";
    
            for ( idx = 0; idx < data.just_updated.length; idx++ ) {
                var entry = data.just_updated[ idx ];
    
                listItems += tplModule.clone()
                                .bind( "CRATE", entry.name )
                                .bind( "VERSION", entry.newest_version )
                                .str();
            }
    
            var elElement = $( "#just_updated" );
    
            elElement.innerHTML = listItems;
        }
        {   // most downloaded
            var listItems = "";
    
            for ( idx = 0; idx < data.most_downloaded.length; idx++ ) {
                var entry = data.most_downloaded[ idx ];
    
                listItems += tplModule.clone()
                                .bind( "CRATE", entry.name )
                                .bind( "VERSION", entry.newest_version )
                                .str();
            }
    
            var elElement = $( "#most_downloaded" );
    
            elElement.innerHTML = listItems;
        }
        {   // most recently downloaded
            var listItems = "";
    
            for ( idx = 0; idx < data.most_recently_downloaded.length; idx++ ) {
                var entry = data.most_recently_downloaded[ idx ];
    
                listItems += tplModule.clone()
                                .bind( "CRATE", entry.name )
                                .bind( "VERSION", entry.newest_version )
                                .str();
            }
    
            var elElement = $( "#most_recently_downloaded" );
    
            elElement.innerHTML = listItems;
        }
        {   // new modules
            var listItems = "";
    
            for ( idx = 0; idx < data.new_crates.length; idx++ ) {
                var entry = data.new_crates[ idx ];
    
                listItems += tplModule.clone()
                                .bind( "CRATE", entry.name )
                                .bind( "VERSION", entry.newest_version )
                                .str();
            }
    
            var elElement = $( "#new_crates" );
    
            elElement.innerHTML = listItems;
        }
        {   // popular categories
            var listItems = "";
    
            for ( idx = 0; idx < data.popular_categories.length; idx++ ) {
                var entry = data.popular_categories[ idx ];
    
                listItems += tplModule.clone()
                                .bind( "CRATE", entry.name )
                                .bind( "VERSION", entry.newest_version )
                                .str();
            }
    
            var elElement = $( "#popular_categories" );
    
            elElement.innerHTML = listItems;
        }
        {   // popular keywords
            var listItems = "";
    
            for ( idx = 0; idx < data.popular_keywords.length; idx++ ) {
                var entry = data.popular_keywords[ idx ];
    
                listItems += tplModule.clone()
                                .bind( "CRATE", entry.name )
                                .bind( "VERSION", entry.newest_version )
                                .str();
            }
    
            var elElement = $( "#popular_keywords" );
    
            elElement.innerHTML = listItems;
        }
    },

    ViewCrate: function( crate ) {
        Parameters.clear();
        Parameters.add( "crate", crate );

        LoadPluginWithHistory( "crateView" );
    }

};

mCurrentPlugin = mPlugin;
