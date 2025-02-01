
import System.Collections.Vector;

public object TUsersRecord {
   public string Created;
   public string Deleted;
   public int Id;
   public string Identifier;
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

    public void deleteByPrimaryKey( int id ) modify throws {
        var query = "DELETE FROM users WHERE id = '" + id + "'";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }
    }

    public void insert( bool reloadAfterInsert = false ) modify throws {
        var query = "INSERT INTO users ( `created`, `deleted`, `id`, `identifier`, `username` ) VALUES ( NULLIF('" + Created + "', ''), NULLIF('" + Deleted + "', ''), '" + Id + "', '" + Identifier + "', '" + Username + "' )";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        if ( reloadAfterInsert ) {
            if ( !Id ) {
                Id = getLastInsertId();
            }

            loadByPrimaryKey( Id );
        }
    }

    public void insertIgnore( bool reloadAfterInsert = false ) modify throws {
        var query = "INSERT IGNORE INTO users ( `created`, `deleted`, `id`, `identifier`, `username` ) VALUES ( NULLIF('" + Created + "', ''), NULLIF('" + Deleted + "', ''), '" + Id + "', '" + Identifier + "', '" + Username + "' )";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        if ( reloadAfterInsert ) {
            if ( !Id ) {
                Id = getLastInsertId();
            }

            loadByPrimaryKey( Id );
        }
    }

    public void insertOrUpdate( bool reloadAfterInsert = false ) modify throws {
        var query = "INSERT INTO users ( `created`, `deleted`, `id`, `identifier`, `username` ) VALUES ( NULLIF('" + Created + "', ''), NULLIF('" + Deleted + "', ''), '" + Id + "', '" + Identifier + "', '" + Username + "' ) ON DUPLICATE KEY UPDATE `created` = NULLIF('" + Created + "', ''), `deleted` = NULLIF('" + Deleted + "', ''), `identifier` = '" + Identifier + "', `username` = '" + Username + "'";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        if ( reloadAfterInsert ) {
            if ( !Id ) {
                Id = getLastInsertId();
            }

            loadByPrimaryKey( Id );
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

       Created = cast<string>( mysql_get_field_value( result, "created" ) );
       Deleted = cast<string>( mysql_get_field_value( result, "deleted" ) );
       Id = cast<int>( mysql_get_field_value( result, "id" ) );
       Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
       Username = cast<string>( mysql_get_field_value( result, "username" ) );
    }

    public void loadByPrimaryKey( int id ) modify throws {
        var query = "SELECT * FROM users WHERE id = '" + id + "'";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        var result = mysql_store_result( DB );
        if ( !mysql_fetch_row( result ) ) {
            throw "no result found";
        }

       Created = cast<string>( mysql_get_field_value( result, "created" ) );
       Deleted = cast<string>( mysql_get_field_value( result, "deleted" ) );
       Id = cast<int>( mysql_get_field_value( result, "id" ) );
       Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
       Username = cast<string>( mysql_get_field_value( result, "username" ) );
    }

    public void loadByResult( int result ) modify {
       Created = cast<string>( mysql_get_field_value( result, "created" ) );
       Deleted = cast<string>( mysql_get_field_value( result, "deleted" ) );
       Id = cast<int>( mysql_get_field_value( result, "id" ) );
       Identifier = cast<string>( mysql_get_field_value( result, "identifier" ) );
       Username = cast<string>( mysql_get_field_value( result, "username" ) );
    }

    public void update( bool reloadAfterUpdate = false ) modify throws {
        var query = "UPDATE users SET `created` = NULLIF('" + Created + "', ''), `deleted` = NULLIF('" + Deleted + "', ''), `identifier` = '" + Identifier + "', `username` = '" + Username + "' WHERE id = '" + Id + "'";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        if ( reloadAfterUpdate ) {
            loadByPrimaryKey( Id );
        }
    }

    public bool operator==( TUsersRecord other const ) const {
        return Id == other.Id;
    }

    public string =operator( string ) const {
        return "TUsersRecord { NULLIF('" + Created + "', ''), NULLIF('" + Deleted + "', ''), '" + Id + "', '" + Identifier + "', '" + Username + "' }";
    }

    private int getLastInsertId() const throws {
        var query = "SELECT LAST_INSERT_ID() AS id;";

        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        var result = mysql_store_result( DB );
        if ( !result ) {
            throw mysql_error( DB );
        }

        if ( !mysql_fetch_row( result ) ) {
            throw mysql_error( DB );
        }

        return cast<int>( mysql_get_field_value( result, "id" ) );
    }

    private int DB const;
}


public object TUsersCollection implements ICollection { //<TUsersRecord> {
    public void Constructor( int databaseHandle, string query = "" ) {
        Collection = new Vector<TUsersRecord>();
        DB = databaseHandle;

        if ( query ) {
            loadByQuery( query );
        }
    }

    public TUsersRecord at( int index ) const throws {
        return Collection.at( index );
    }

    public bool empty() const {
        return Collection.empty();
    }

    public TUsersRecord first() const {
        return Collection.first();
    }

    public Iterator<TUsersRecord> getIterator() const {
        return Collection.getIterator();
    }

    public TUsersRecord last() const {
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
            var record = new TUsersRecord( DB );
            record.loadByResult( result );

            Collection.push_back( record );
        }
    }

    public void loadByResult( int result ) modify throws {
        Collection.clear();

        while ( mysql_fetch_row( result ) ) {
            var record = new TUsersRecord( DB );
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

    public void push_back( TUsersRecord item ) modify {
        Collection.push_back( item );
    }

    private Vector<TUsersRecord> Collection;
    private int DB const;
}


