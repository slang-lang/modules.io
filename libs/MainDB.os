
// library imports
import System.Exception;

// project imports
import Database;


public void Main( int argc, string args ) modify {
	try {
		Database.connect();

		Render();

		Database.disconnect();
	}
	catch ( string e ) {
		print( "Exception: " + e );
	}
	catch ( IException e ) {
		print( "Exception: " + e.what() );
	}
}

