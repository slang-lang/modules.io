
import System.Collections.Vector;

public object TUserDataGithubRecord {
   public string CreateTime;
   public string Email;
   public string ExternalId;
   public string Identifier;
   public string ProfilePicture;
   public string Username;

    public void Constructor( int databaseHandle ) {
        DB = databaseHandle;
    }

    public void Constructor( int databaseHandle, string query ) {
        DB = databaseHandle;

        loadByQuery( query );
    }

    public void Constructor( int databaseHandle, int result ) {
        DB = databaseHandle;

        loadByResult( result );
    }

    public void insert() modify throws {
        var query = "INSERT INTO user_data_github ( `create_time`, `email`, `external_id`, `identifier`, `profile_picture`, `username` ) VALUES ( NULLIF('" + CreateTime + "', ''), '" + Email + "', '" + ExternalId + "', '" + Identifier + "', '" + ProfilePicture + "', '" + Username + "' )";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }
    }

    public void insertIgnore() modify throws {
        var query = "INSERT IGNORE INTO user_data_github ( `create_time`, `email`, `external_id`, `identifier`, `profile_picture`, `username` ) VALUES ( NULLIF('" + CreateTime + "', ''), '" + Email + "', '" + ExternalId + "', '" + Identifier + "', '" + ProfilePicture + "', '" + Username + "' )";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }
    }

    public void insertOrUpdate() modify throws {
        var query = "INSERT INTO user_data_github ( `create_time`, `email`, `external_id`, `identifier`, `profile_picture`, `username` ) VALUES ( NULLIF('" + CreateTime + "', ''), '" + Email + "', '" + ExternalId + "', '" + Identifier + "', '" + ProfilePicture + "', '" + Username + "' ) ON DUPLICATE KEY UPDATE `create_time` = NULLIF('" + CreateTime + "', ''), `email` = '" + Email + "', `external_id` = '" + ExternalId + "', `identifier` = '" + Identifier + "', `profile_picture` = '" + ProfilePicture + "', `username` = '" + Username + "'";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }
    }

    public void loadByQuery( string query ) modify throws {
        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        var result = mysql_store_result( DB );
        if ( !mysql_fetch_row( result ) ) {
            throw "no result found";
        }

       CreateTime = cast<string>( mysql_get_field_value( result, "create_time" ) );
       Email = cast<string>( mysql_get_field_value( result, "email" ) );
       ExternalId = cast<string>( mysql_get_field_value( result, "external_id" ) );
       Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
       ProfilePicture = cast<string>( mysql_get_field_value( result, "profile_picture" ) );
       Username = cast<string>( mysql_get_field_value( result, "username" ) );
    }

    public void loadByResult( int result ) modify {
       CreateTime = cast<string>( mysql_get_field_value( result, "create_time" ) );
       Email = cast<string>( mysql_get_field_value( result, "email" ) );
       ExternalId = cast<string>( mysql_get_field_value( result, "external_id" ) );
       Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
       ProfilePicture = cast<string>( mysql_get_field_value( result, "profile_picture" ) );
       Username = cast<string>( mysql_get_field_value( result, "username" ) );
    }

    public string =operator( string ) const {
        return "TUserDataGithubRecord { NULLIF('" + CreateTime + "', ''), '" + Email + "', '" + ExternalId + "', '" + Identifier + "', '" + ProfilePicture + "', '" + Username + "' }";
    }

    private int DB const;
}


public object TUserDataGithubCollection implements ICollection /*<TUserDataGithubRecord>*/ {
    public void Constructor( int databaseHandle, string query = "" ) {
        Collection = new Vector<TUserDataGithubRecord>();
        DB = databaseHandle;

        if ( query ) {
            loadByQuery( query );
        }
    }

    public TUserDataGithubRecord at( int index ) const throws {
        return Collection.at( index );
    }

    public bool empty() const {
        return Collection.empty();
    }

    public TUserDataGithubRecord first() const {
        return Collection.first();
    }

    public Iterator<TUserDataGithubRecord> getIterator() const {
        return Collection.getIterator();
    }

    public TUserDataGithubRecord last() const {
        return Collection.last();
    }

    public void loadByQuery( string query ) modify throws {
        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        Collection.clear();

        var result = mysql_store_result( DB );
        while ( mysql_fetch_row( result ) ) {
            var record = new TUserDataGithubRecord( DB );
            record.loadByResult( result );

            Collection.push_back( record );
        }
    }

    public void loadByResult( int result ) modify throws {
        Collection.clear();

        while ( mysql_fetch_row( result ) ) {
            var record = new TUserDataGithubRecord( DB );
            record.loadByResult( result );

            Collection.push_back( record );
        }
    }

    public void pop_back() modify {
        Collection.pop_back();
    }

    public void pop_front() modify {
        Collection.pop_front();
    }

    public int size() const {
        return Collection.size();
    }

    public void push_back( TUserDataGithubRecord item ) modify {
        Collection.push_back( item );
    }

    private Vector<TUserDataGithubRecord> Collection;
    private int DB const;
}

