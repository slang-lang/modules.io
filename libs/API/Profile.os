
// Library imports

// Project imports
import libs.API.Utils;
import libs.Database.Statement;
import libs.Database.Utils;


public namespace API {

    public bool VerifyApiKey() throws {
        var apiKey     = retrieve( "apiKey" );
        var identifier = retrieve( "identifier" );

        var stmt = new Database.Statement( "SELECT 1 FROM user_data WHERE api_key = ':apiKey' AND identifier = ':identifier'" );
        stmt.bind( "apiKey",     apiKey );
        stmt.bind( "identifier", identifier );
        stmt.execute();

        if ( !stmt.fetchRow() ) {
            throw "API key verification failed!";
        }

        return true;
    }

}
