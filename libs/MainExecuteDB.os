
// library import
import libJsonBuilder.StructuredBuilder;
import System.Exception;

// project imports
import Database;


public void Main( int argc, string args ) modify {
	try {
		Database.connect();
		Database.begin();

		if ( Execute( argc, args ) ) {
			Json.AddElement( "result", "success" );
		}
		else {
			Json.AddElement( "result", "failed" );
		}

		Database.commit();
		Database.disconnect();
	}
	catch ( string e ) {
		Database.rollback();

		Json.AddElement( "message", e );
	}
	catch ( IException e ) {
		Database.rollback();

		Json.AddElement( "message", e.what() );
	}

	print( Json.GetString() );
}

