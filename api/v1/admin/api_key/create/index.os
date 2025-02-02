#!/usr/local/bin/webscript

// library imports

// project imports
import libs.Accounts.AccountTools;
import libs.API.Utils;
import libs.MainProcessJsonDB;


public void Process( int, string )
{
    var identifier = API.retrieve( "identifier" );

    Accounts.GenerateApiKey( identifier );
}

