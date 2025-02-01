
// library imports
import libJsonBuilder.StructuredBuilder;

// project imports
import libs.Database.Tables.UserData;
import libs.Database.Tables.UserDataGithub;
import libs.Database.Tables.Users;


public namespace Accounts {

    public bool ChangeLanguage( string identifier, string language ) throws {
        Database.Execute(
            "UPDATE user_data SET language = '" + language + "' WHERE identifier = '" + identifier + "'"
        );

        return true;
    }

    public bool Delete( string identifier ) throws {
        Database.begin();

        // set user to deleted to that he cannot log in anymore
        Database.Execute(
            "UPDATE users SET deactivated = Now(), deleted = TRUE, username = CONCAT( username, '~', NOW() ) WHERE identifier = '" + identifier + "'"
        );

        Database.commit();

        return true;
    }

    public bool GenerateApiKey( string identifier ) throws {
        var apiKey = Database.prepareEncrypt( identifier, strftime( "%Y-%m-%dT%H:%M:%S" ) );

        Database.begin();

        Database.Execute( "UPDATE user_data SET api_key = " + apiKey + " WHERE identifier = '" + identifier + "'" );

        Database.Query( "SELECT api_key FROM user_data WHERE identifier = '" + identifier + "'" );
        Database.FetchRow();

        Json.AddElement( "apiKey", Database.GetFieldValue( "api_key" ) );
        Json.AddElement( "result", "success" );

        Database.commit();

        return true;
    }

    public bool Login( string userId, string username, string email, string userProfileUrl ) throws {
        var query = "SELECT ud.api_key, ud.language, udg.*
                       FROM users u
                       JOIN user_data_github udg ON ( u.identifier = udg.identifier )
                       JOIN user_data ud ON ( u.identifier = udg.identifier )
                      WHERE external_id = '" + userId + "'
                        AND udg.username = '" + username + "'";
        //print( query );

        var result = Database.Query( query );

        if ( mysql_fetch_row( result ) ) {
            var apiKey     = mysql_get_field_value( result, "api_key" );
            var identifier = mysql_get_field_value( result, "identifier" );
            var language   = mysql_get_field_value( result, "language" );
            var username   = mysql_get_field_value( result, "username" );

            Json.AddElement( "result", "success" );
            Json.BeginObject( "data" );
            Json.AddElement( "apiKey", apiKey );
            Json.AddElement( "identifier", identifier );
            Json.AddElement( "language", language );
            Json.AddElement( "username", username );
            Json.EndObject();

            return true;
        }
        else {
            Database.begin();
            var identifier = Register( username, email );

            InsertUser( identifier, userId, username, email, userProfileUrl );

            Database.commit();

            return true;
        }

        Json.AddElement( "message", "invalid user or password" );
        return false;
    }

    public string Register( string username, string email ) throws {
        Database.begin();

        var userhash = Database.prepareEncrypt( username, strftime( "%Y-%m-%dT%H:%M:%S" ) );

        Database.Execute(
            "INSERT INTO users ( identifier, username ) VALUES ( " + userhash + ", '" + username + "' )"
        );

        Database.Execute(	// by default new users have the professional user profile assigned (this should be changed after Go-Live)
            "INSERT INTO user_data ( identifier, email, send_login_notifications, send_mail_notifications )
                            VALUES ( '" + userhash + "', '" + username + "', FALSE, TRUE )"
        );

        // we need the user's identifier to send him a notification
        Database.Query( "SELECT identifier FROM users WHERE username = '" + username + "'" );
        Database.FetchRow();

        var identifier = Database.GetFieldValue( "identifier" );

        if( !GenerateApiKey( identifier ) ) {
            throw "failed to generate API key";
        }

        Database.commit();

        return identifier;
    }

    public bool UpdateUser( TUserDataRecord user ) modify throws {
        var query = "UPDATE user_data
                        SET language                 = '" + user.Language + "',
                            send_login_notifications = " + user.SendLoginNotifications + ",
                            send_mail_notifications  = " + user.SendMailNotifications + ",
                      WHERE identifier               = '" + user.Identifier + "'";
        //print( query );

        try {
            return Database.Execute( query );
        }

        return false;
    }

    private void InsertUser( string identifier, string userId, string username, string email, string userProfileUrl ) throws {
        var query = "INSERT INTO user_data_github ( identifier, external_id, username, email, profile_picture )
                                           VALUES ( '" + identifier + "', '" + userId + "', '" + username + "', '" + email + "', '" + userProfileUrl + "' )";

        Database.Execute( query );
    }

}
