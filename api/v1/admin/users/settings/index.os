#!/usr/local/bin/webscript

// Library imports

// Project imports
import libs.API;
import libs.Database.Utils;
import libs.MainProcessJsonDB;


public void Process( int argc, string args ) throws {
    var identifier = API.retrieve( "identifier" );
    
    var query = "SELECT *
                   FROM users u
                   JOIN user_data ud ON ( u.identifier = ud.identifier )
                 WHERE u.identifier = '" + identifier + "'";

    var error = mysql_query( Database.Handle, query );
    if ( error ) {
        throw mysql_error( error );
    }

    var result = mysql_store_result( Database.Handle );
    if ( mysql_fetch_row( result ) ) {
        Json.BeginObject( "settings" );
        Json.AddElement( "apiKey", mysql_get_field_value( result, "api_key" ) );
        Json.AddElement( "email", mysql_get_field_value( result, "email" ) );
        Json.AddElement( "language", mysql_get_field_value( result, "language" ) );
        Json.AddElement( "sendLoginNotifications", mysql_get_field_value( result, "send_login_notifications" ) );
        Json.AddElement( "sendMailNotifications", mysql_get_field_value( result, "send_mail_notifications" ) );
        Json.AddElement( "userName", mysql_get_field_value( result, "username" ) );
        Json.EndObject();
    }
}

