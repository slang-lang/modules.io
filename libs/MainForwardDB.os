#!/usr/local/bin/webscript

// library imports
import libCurl;
import System.Exception;

// project imports
import API.Utils;
import Database;
import Database.Views.VBroker;
import Database.Views.VBrokerData;


public void Main( int argc, string args ) modify {
	try {
		Database.connect();

		string url;

		if ( isSet( "broker_id" ) ) {
			var brokerId = API.retrieve( "broker_id" );
			if ( !brokerId ) {
				throw "invalid broker";
			}

			var broker = new VBrokerRecord( Database.Handle );
			broker.loadByQuery( "SELECT * FROM v_broker WHERE id = '" + brokerId + "'" );

			//print( "REQUEST_URI: " + getenv( "REQUEST_URI" ) );

			url = broker.BackendUrl + getenv( "REQUEST_URI" );
		}
		else if ( isSet( "broker_identifier" ) ) {
			var brokerIdentifier = API.retrieve( "broker_identifier" );
			if ( !brokerIdentifier ) {
				throw "invalid broker";
			}

			var broker = new VBrokerDataRecord( Database.Handle );
			broker.loadByQuery( "SELECT * FROM v_broker_data WHERE identifier = '" + brokerIdentifier + "'" );

			//print( "REQUEST_URI: " + getenv( "REQUEST_URI" ) );

			url = broker.BackendUrl + getenv( "REQUEST_URI" ) + "&broker_id=" + broker.BrokerId;
		}
		else {
			throw "missing broker identification";
		}

		Database.disconnect();

		//print( "Forwarding request to " + url );

		var curl = new CurlRequest( url );
		curl.setHeader( "Accept: application/json" );
		curl.setHeader( "Content-Type: application/json" );

		var reply = curl.execute();
		//print( "Received reply: " + reply );
		print( reply );
	}
	catch ( string e ) {
		print( "Exception: " + e );
	}
	catch ( IException e ) {
		print( "Exception: " + e.what() );
	}
}

