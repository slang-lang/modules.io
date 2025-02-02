#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Accounts.AccountTools;
import libs.API.Utils;
import libs.MainProcessJsonDB;


public void Process( int, string )
{
    var email          = API.retrieve( "email", "" );
    var username       = API.retrieve( "username" );
    var userId         = API.retrieve( "userId" );
    var userProfileUrl = API.retrieve( "userProfileUrl", "" );

    Accounts.Login( userId, username, email, userProfileUrl );
}
