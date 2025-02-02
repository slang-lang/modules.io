#!/usr/local/bin/webscript

// library imports

// project imports
import libs.API.Utils;
import libs.Consts.Pagination;
import libs.Database.Tables.Modules;
import libs.MainProcessJsonDB;


public void Process( int, string )
{
    var owner   = API.retrieve( "identifier" );

    retrieveAllModulesByOwner( owner );
}

private void retrieveAllModulesByOwner( string owner ) throws
{
    var query = "SELECT *
                   FROM v_modules
                  WHERE owner = '" + owner + "'
                  GROUP BY name ORDER BY name ASC, version DESC";
    // print( query );
    var collection = new TModulesCollection( Database.Handle, query );

    provideModules( collection );
}

private void provideModules( TModulesCollection collection ) throws
{
    Json.BeginArray( "crates" );
    foreach ( TModulesRecord record : collection ) {
        Json.BeginObject();
            Json.AddElement( "architecture", record.Architecture );
            Json.AddElement( "badges", "[]" );
            Json.AddElement( "categories", "null" );
            Json.AddElement( "created_at", record.Added );
            Json.AddElement( "default_version", record.Version );
            Json.AddElement( "description", "null" );
            Json.AddElement( "documentation", "null" );
            Json.AddElement( "downloads", record.Downloads );
            Json.AddElement( "exact_match", "false" );
            Json.AddElement( "homepage", "https://www.slang-lang.org/" );
            Json.AddElement( "id", record.Name );
            Json.AddElement( "keywords", "null" );
            Json.AddElement( "max_stable_version", record.Version );
            Json.AddElement( "max_version", record.Version );
            Json.AddElement( "name", record.Name );
            Json.AddElement( "newest_version", record.Version );
            Json.AddElement( "recent_downloads", record.Downloads );
            Json.AddElement( "repository", record.Repository );
            Json.AddElement( "updated_at", record.LastUpdate );
            Json.AddElement( "yanked", "false" );
        Json.EndObject();
    }
    Json.EndArray();
}

