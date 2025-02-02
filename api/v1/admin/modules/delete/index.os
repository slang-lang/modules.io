#!/usr/local/bin/webscript

// library imports

// project imports
import libs.API.Utils;
import libs.Database.Tables.Modules;
import libs.Modules.Modules;
import libs.MainProcessJsonDB;


public void Process( int, string )
{
    var module = new TModulesRecord() {
        module.Architecture = API.retrieve( "architecture" );
        module.Keywords     = API.retrieve( "keywords", "" );
        module.Name         = API.retrieve( "name" );
        module.Owner        = API.retrieve( "identifier" );
        module.Repository   = API.retrieve( "repository", "" );
        module.Version      = API.retrieve( "version", "" );
    }

    Modules.Delete( module );
}

