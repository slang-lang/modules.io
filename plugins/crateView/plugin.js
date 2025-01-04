
mPlugin = {

    // consts
    CRATE_VIEW: "CRATE",

    // instance members

    OnLoad: function() {
        mElModule = $( "#module" );
    },

    OnLoadReady: function() {
        this.QueryModule( Parameters.get( "crate" ) );

        LoadingFinished();
    },

    QueryModule: function( crate, version ) {
        Parameters.clear();
        Parameters.add( "crate", crate );
        Parameters.add( "version", version );

        get( "crates/", ( response ) => {

            if ( response.crates.length == 1 ) {
                mPlugin.RenderModule( response.crates[ 0 ] );
            }
            else {
                notifyError( "MODULE_NOT_FOUND" );
            }

        } );
    },

    RenderModule: function( module ) {
        {   // keywords
            var tplKeyword = Templates.clone( "template-keyword" );

            var keywords = "";
            for ( var idx = 0; idx < module.keywords.length; ++idx ) {
                var keyword = module.keywords[ idx ];

                keywords += tplKeyword.clone()
                                .bind( "KEYWORD", keyword)
                                .str();
            }
        }

        mElModule.innerHTML = Templates.clone( "template-module" )
            .bind( "CATEGORY", null )
            .bind( "CRATE", module.name )
            .bind( "DESCRIPTION", module.description )
            .bind( "DOWNLOADS_ALL_TIME", module.downloads )
            .bind( "DOWNLOAD_SIZE", null )
            .bind( "KEYWORDS", keywords )
            .bind( "LAST_UPDATE", module.updated_at )
            .bind( "LICENSE", null )
            .bind( "LINK_DOCUMENTATION", null )
            .bind( "LINK_REPOSITORY", null )
            .bind( "MAINTAINER", null )
            .bind( "MAX_VERSION", module.max_version )
            .bind( "NUM_VERSIONS", module.versions.length )
            .bind( "README", null )
            .bind( "VERSION", module.newest_version )
            .str();
    
        Translations.translate( mElModule );
    }

};

mCurrentPlugin = mPlugin;
