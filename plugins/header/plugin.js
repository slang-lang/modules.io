
mHeader = {

    // consts
    HEADER: "header",

    // instance members
    pluginName: "header",

    OnLoadReady: function() {
        mElHeader = $( "#header" );
        mElLogin  = $( "#login" );
        mElSearch = $( "#search" );

        this.Refresh();
    },

    Login: function() {
        Redirect( "/login" );
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
    },

    Username: function() {
        var elLogin = $( "#login" );

        if ( elLogin.innerText == "LOGIN" ) {
            mHeader.Login();
        }
        else {
            LoadPluginWithHistory( "settingsView" );
        }
    },

};

