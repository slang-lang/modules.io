
mPlugin = {

    // consts
    TEMPLATE_VIEW: "TEMPLATE",

    // instance members

    OnLoad: function() {
        mElModules = $( "#modules" );
    },

    OnLoadReady: function() {
        QueryModules();

        LoadingFinished();
    },

    QueryModules: function() {
        executeExternal( "https://slang-lang.org/repo/stable/" );
    }

};

mCurrentPlugin = mPlugin;
