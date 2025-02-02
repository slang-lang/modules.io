#!/usr/local/bin/webscript

// library imports

// project imports
import libs.API.Utils;
import libs.Database.Tables.Modules;
import libs.MainProcessJsonDB;


public void Process( int, string )
{
    retrieveModuleMetaData();
    retrieveJustUpdatedModules();
    retrieveMostDownloadedModules();
    retrieveMostRecentlyDownloadedModules();
    retrieveNewModules();

    Json.BeginArray( "popular_keywords" );
    Json.EndArray();

    Json.BeginArray( "popular_categories" );
    Json.EndArray();
}

private void retrieveJustUpdatedModules() throws
{
    var query = "SELECT * FROM v_modules ORDER BY last_update DESC LIMIT 10";
    var collection = new TModulesCollection( Database.Handle, query );

    Json.BeginArray( "just_updated" );
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
            Json.AddElement( "homepage", "https://slang-lang.org" );
            Json.AddElement( "id", record.Name );
            Json.AddElement( "keywords", "null" );
            Json.AddElement( "max_stable_version", record.Version );
            Json.AddElement( "max_version", record.Version );
            Json.AddElement( "name", record.Name );
            Json.AddElement( "newest_version", record.Version );
            Json.AddElement( "recent_downloads", record.Downloads );
            Json.AddElement( "repository", record.Repository );
            Json.AddElement( "updated_at", record.LastUpdate );
            Json.AddElement( "versions", record.Version );
            Json.AddElement( "yanked", "false" );
        Json.EndObject();
    }
    Json.EndArray();
}

private void retrieveModuleMetaData() throws
{
    var query = "SELECT COUNT(*) as num_modules, SUM(downloads) as num_downloads FROM v_modules";
    Database.Query( query );
    Database.FetchRow();

    Json.AddElement( "num_crates", Database.GetFieldValue( "num_modules" ) );
    Json.AddElement( "num_downloads", Database.GetFieldValue( "num_downloads" ) );
}

private void retrieveMostDownloadedModules() throws
{
    var query = "SELECT * FROM v_modules ORDER BY downloads LIMIT 10";
    var collection = new TModulesCollection( Database.Handle, query );

    Json.BeginArray( "most_downloaded" );
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
            Json.AddElement( "homepage", "https://slang-lang.org" );
            Json.AddElement( "id", record.Name );
            Json.AddElement( "keywords", "null" );
            Json.AddElement( "max_stable_version", record.Version );
            Json.AddElement( "max_version", record.Version );
            Json.AddElement( "name", record.Name );
            Json.AddElement( "newest_version", record.Version );
            Json.AddElement( "recent_downloads", record.Downloads );
            Json.AddElement( "repository", record.Repository );
            Json.AddElement( "updated_at", record.LastUpdate );
            Json.AddElement( "versions", record.Version );
            Json.AddElement( "yanked", "false" );
        Json.EndObject();
    }
    Json.EndArray();
}

private void retrieveMostRecentlyDownloadedModules() throws
{
    var query = "SELECT * FROM v_modules ORDER BY downloads LIMIT 10";
    var collection = new TModulesCollection( Database.Handle, query );

    Json.BeginArray( "most_recently_downloaded" );
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
            Json.AddElement( "homepage", "https://slang-lang.org" );
            Json.AddElement( "id", record.Name );
            Json.AddElement( "keywords", "null" );
            Json.AddElement( "max_stable_version", record.Version );
            Json.AddElement( "max_version", record.Version );
            Json.AddElement( "name", record.Name );
            Json.AddElement( "newest_version", record.Version );
            Json.AddElement( "recent_downloads", record.Downloads );
            Json.AddElement( "repository", record.Repository );
            Json.AddElement( "updated_at", record.LastUpdate );
            Json.AddElement( "versions", record.Version );
            Json.AddElement( "yanked", "false" );
        Json.EndObject();
    }
    Json.EndArray();
}

private void retrieveNewModules() throws
{
    var query = "SELECT * FROM v_modules ORDER BY added LIMIT 10";
    var collection = new TModulesCollection( Database.Handle, query );

    Json.BeginArray( "new_crates" );
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
            Json.AddElement( "homepage", "https://slang-lang.org" );
            Json.AddElement( "id", record.Name );
            Json.AddElement( "keywords", "null" );
            Json.AddElement( "max_stable_version", record.Version );
            Json.AddElement( "max_version", record.Version );
            Json.AddElement( "name", record.Name );
            Json.AddElement( "newest_version", record.Version );
            Json.AddElement( "recent_downloads", record.Downloads );
            Json.AddElement( "repository", record.Repository );
            Json.AddElement( "updated_at", record.LastUpdate );
            Json.AddElement( "versions", record.Version );
            Json.AddElement( "yanked", "false" );
        Json.EndObject();
    }
    Json.EndArray();
}

