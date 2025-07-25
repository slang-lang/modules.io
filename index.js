
const cachedEntities = {
    languages: [],
    plugin: null,
    renderComponent: true,
    settings: null,
    stats: {
        pageLoadedAt: null,
    },
    template: null,
};

///////////////////////////////////////////////////////////////////////////////
// User event handling

function OnLoadReady()
{
    Globals.Admin = false;
    Globals.Debug = false;

    API.Constructor( "", "api", "https", "v1" );

    var token = GetURLParameter( "token" );
    if ( token ) {
        Cache.token = token;
        Cache.Store();

        Redirect( "" );
        return;
    }
    else if ( Cache.token && !Account.IsLoggedIn() ) {
        Cache.FetchUserInfo( () => {
            Account.GithubLogin( () => {
                Redirect( "" );
            } );
        } );

        return;
    }
}

function OnLoginFailed( event )
{
    //alert( "OnLoginFailed()" );

    // your code goes here...

    notifyError( "LOGIN_FAILED" );
}

function OnLoginSuccess( event )
{
    //alert( "OnLoginSuccess()" );

    // your code goes here...

    LoadPlugin( "start" );
}

function OnLogout( event )
{
    //alert( "OnLogout()" );

    // your code goes here...

    notifySuccess( "LOGOUT_SUCCESS" );
}

function OnLogoutFailed( event )
{
    //alert( "OnLogoutFailed()" );

    // your code goes here...
}

function OnLogoutSuccess( event )
{
    //alert( "OnLogoutSuccess()" );

    // your code goes here...
    Redirect( "/" );

    //LoadPlugin( "loginView" );
}

// User event handling
///////////////////////////////////////////////////////////////////////////////

function RefreshUserName()
{
    var elLogin = $( "#login" );
    if ( elLogin ) {
        elLogin.innerHTML = Templates.clone("template-user-login")
            .bind("USERNAME", Cache.userInfo ? Cache.userInfo.name : "LOGIN")
            .str();
    }
}

function Search()
{
    mHeader.Search();
}
