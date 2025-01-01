
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
        LoadingFinished();
    },

    ScrollToTop: function() {
        mElHeader.scrollIntoView();
    },

    Search: function() {
        var elSearch = $( "#search" );
        if ( !elSearch.value ) {
            return;
        }

        LoadPluginWithHistory( "searchView" );
    },

    // ShowNavigation: function() {
    //     Navigation.Show();
    // },

    // ToggleNavigation: function() {
    //     Navigation.Toggle();
    // }

};

