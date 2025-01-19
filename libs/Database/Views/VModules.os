
import System.Collections.Vector;

public object VModulesRecord {
   public string Added;
   public string Architecture;
   public string Description;
   public int Downloads;
   public string Keywords;
   public string LastUpdate;
   public string Name;
   public string Repository;
   public string Version;

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

    public void loadByQuery( string query ) modify throws {
        var error = mysql_query( DB, query );
        if ( error ) {
            throw mysql_error( DB );
        }

        var result = mysql_store_result( DB );
        if ( !mysql_fetch_row( result ) ) {
            throw "no result found";
        }

       Added = cast<string>( mysql_get_field_value( result, "added" ) );
       Architecture = cast<string>( mysql_get_field_value( result, "architecture" ) );
       Description = cast<string>( mysql_get_field_value( result, "description" ) );
       Downloads = cast<int>( mysql_get_field_value( result, "downloads" ) );
       Keywords = cast<string>( mysql_get_field_value( result, "keywords" ) );
       LastUpdate = cast<string>( mysql_get_field_value( result, "last_update" ) );
       Name = cast<string>( mysql_get_field_value( result, "name" ) );
       Repository = cast<string>( mysql_get_field_value( result, "repository" ) );
       Version = cast<string>( mysql_get_field_value( result, "version" ) );
    }

    public void loadByResult( int result ) modify {
       Added = cast<string>( mysql_get_field_value( result, "added" ) );
       Architecture = cast<string>( mysql_get_field_value( result, "architecture" ) );
       Description = cast<string>( mysql_get_field_value( result, "description" ) );
       Downloads = cast<int>( mysql_get_field_value( result, "downloads" ) );
       Keywords = cast<string>( mysql_get_field_value( result, "keywords" ) );
       LastUpdate = cast<string>( mysql_get_field_value( result, "last_update" ) );
       Name = cast<string>( mysql_get_field_value( result, "name" ) );
       Repository = cast<string>( mysql_get_field_value( result, "repository" ) );
       Version = cast<string>( mysql_get_field_value( result, "version" ) );
    }

    public string =operator( string ) const {
        return "VModulesRecord { NULLIF('" + Added + "', ''), '" + Architecture + "', '" + Description + "', '" + Downloads + "', '" + Keywords + "', NULLIF('" + LastUpdate + "', ''), '" + Name + "', '" + Repository + "', '" + Version + "' }";
    }

    private int DB const;
}


public object VModulesCollection implements ICollection /*<VModulesRecord>*/ {
    public void Constructor( int databaseHandle, string query = "" ) {
        Collection = new Vector<VModulesRecord>();
        DB = databaseHandle;

        if ( query ) {
            loadByQuery( query );
        }
    }

    public VModulesRecord at( int index ) const throws {
        return Collection.at( index );
    }

    public bool empty() const {
        return Collection.empty();
    }

    public VModulesRecord first() const {
        return Collection.first();
    }

    public Iterator<VModulesRecord> getIterator() const {
        return Collection.getIterator();
    }

    public VModulesRecord last() const {
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
            var record = new VModulesRecord( DB );
            record.loadByResult( result );

            Collection.push_back( record );
        }
    }

    public void loadByResult( int result ) modify throws {
        Collection.clear();

        while ( mysql_fetch_row( result ) ) {
            var record = new VModulesRecord( DB );
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

    public void push_back( VModulesRecord item ) modify {
        Collection.push_back( item );
    }

    private Vector<VModulesRecord> Collection;
    private int DB const;
}

