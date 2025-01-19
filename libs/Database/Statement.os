
import System.String;
import Database;

public namespace Database {

	public object Statement {

		public void Constructor( string query ) {
			BaseQuery     = query;
			PreparedQuery = new String( query );
		}

		public int affectedRows() throws {
			return mysql_affected_rows( Database.Handle );
		}

		public void bind( string template, bool value ) modify {
			PreparedQuery.ReplaceAll( ":" + template, cast<string>( value ) );
		}

		public void bind( string template, double value ) modify {
			PreparedQuery.ReplaceAll( ":" + template, cast<string>( value ) );
		}

		public void bind( string template, float value ) modify {
			PreparedQuery.ReplaceAll( ":" + template, cast<string>( value ) );
		}

		public void bind( string template, int value ) modify {
			PreparedQuery.ReplaceAll( ":" + template, cast<string>( value ) );
		}

		public void bind( string template, string value ) modify {
			PreparedQuery.ReplaceAll( ":" + template, value );
		}

		public bool execute() modify throws {
			var error = mysql_query( Database.Handle, finalize() );
			if ( error ) {
				throw mysql_error( Database.Handle );
			}

			Result = mysql_store_result( Database.Handle );
			if ( !Result ) {
				throw mysql_error( Database.Handle );
			}

			return true;
		}

		public bool fetchRow() modify throws {
			if ( !mysql_fetch_row( Result ) ) {
				throw mysql_error( Database.Handle );
			}

			return true;
		}

		public string finalize() const {
			return cast<string>( PreparedQuery );
		}

		public string getError() const {
			return mysql_error( Database.Handle );
		}

		public string getValue( string field ) const {
			return mysql_get_field_value( Result, field );
		}

		public void reset() modify {
			PreparedQuery = BaseQuery;
		}

		private string BaseQuery;
		private String PreparedQuery;
		private int Result;
	}

}


