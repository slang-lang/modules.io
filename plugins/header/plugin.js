
mHeader = {

    // consts
    HEADER: "header",

    // instance members
    pluginName: "header",

    Constructor: function() {
        this.OnLoad();
    },

    OnLoad: function() {
        mElHeader = $( "#header" );
        mElSearch = $( "#search" );
    },

    OnLoadReady: function() {
        // nothing to do here
    },

    ScrollToTop: function() {
        mElHeader.scrollIntoView();
    },

    Search: function() {
        mElSearch = $( "#search" );
        if ( !mElSearch.value ) {
            return;
        }

        LoadPluginWithHistory( "searchView" );
    }

};

