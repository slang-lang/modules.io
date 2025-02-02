#!/usr/local/bin/webscript

// library imports

// project imports
import libs.API.Utils;
import libs.Consts.Pagination;
import libs.Database.Tables.Modules;
import libs.MainProcessJsonDB;


public void Process( int, string )
{
    var name    = API.retrieve( "crate", "" );
    var page    = API.retrieve( "page", 1 );
    var perPage = API.retrieve( "per_page", Consts.NUM_ITEMS_PER_PAGER );
    var query   = API.retrieve( "q", "" );

    if ( name ) {
        retrieveSingleModule( name );
    }
    else if ( query ) {
        searchModule( query, page, perPage );
    }
    else {
        retrieveAllModules( page, perPage );
    }
}

private void retrieveAllModules( int page, int perPage ) throws
{
    var query = "SELECT * FROM v_modules GROUP BY name ORDER BY name ASC, version DESC LIMIT " + ( page - 1 ) * perPage + ", " + perPage;
    // print( query );
    var collection = new TModulesCollection( Database.Handle, query );

    provideModules( collection );
}

private void retrieveSingleModule( string name ) throws
{
    var query = "SELECT * FROM modules WHERE name = '" + name + "' ORDER BY name ASC, version DESC LIMIT 1";
    // print( query );
    var collection = new TModulesCollection( Database.Handle, query );

    provideModules( collection );
}

private void searchModule( string name, int page, int perPage ) throws
{
    var query = "SELECT * FROM v_modules WHERE name LIKE '%" + name + "%' GROUP BY name ORDER BY name ASC, version DESC LIMIT " + ( page - 1 ) * perPage + ", " + perPage;
    // print( query );
    var collection = new TModulesCollection( Database.Handle, query );

    provideModules( collection, true );
}

private void provideModules( TModulesCollection collection, bool queryVersions = false ) throws
{
    Json.BeginArray( "crates" );
    foreach ( TModulesRecord record : collection ) {
        Json.BeginObject();
            Json.AddElement( "architecture", record.Architecture );
            Json.AddElement( "badges", "[]" );
            Json.AddElement( "categories", "null" );
            Json.AddElement( "created_at", record.Added );
            Json.AddElement( "default_version", record.Version );
            Json.AddElement( "description", record.Description );
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

            if ( queryVersions ) {
                var query = "SELECT version FROM modules WHERE name = '" + record.Name + "' ORDER BY version DESC";

                var error = mysql_query( Database.Handle, query );
                if ( !error ) {
                    Json.BeginArray( "versions" );

                    var result = mysql_store_result( Database.Handle );
                    while ( mysql_fetch_row( result ) ) {
                        Json.AddValue( mysql_get_field_value( result, "version" ) );
                    }

                    Json.EndArray();
                }
            }

            Json.AddElement( "yanked", "false" );
        Json.EndObject();
    }
    Json.EndArray();

    Json.BeginObject( "meta" );
        Json.AddElement( "total", collection.size() );
        Json.AddElement( "next_page", "null" );
        Json.AddElement( "prev_page", "null" );
    Json.EndObject();
}

