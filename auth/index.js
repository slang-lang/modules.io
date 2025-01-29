"use strict";

function OnLoad()
{
    var login = GetURLParameter( "login" );
    var token = GetURLParameter( "token" );

    if ( login ) {

        alert( "login: " + login + "\n"
             + "token: " + token );
   
    }
}
