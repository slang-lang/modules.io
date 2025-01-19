
// library import
import libJsonBuilder.StructuredBuilder;
import System.Exception;

// project imports
import Database;


public void Main( int argc, string args ) modify {
	try {
		Database.connect();

		Process( argc, args );

		Database.disconnect();
	}
	catch ( string e ) {
		Json.AddElement( "message", e );
	}
	catch ( IException e ) {
		Json.AddElement( "message", e.what() );
	}

	print( Json.GetString() );
}

