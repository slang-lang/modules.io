
// Library imports

// Project imports
import libs.Database.Tables.Modules;


public namespace Modules
{

    public bool Create( TModulesRecord module ) modify throws
    {
        try {
            var newModule = new TModulesRecord( Database.Handle ) {
                newModule.Architecture = module.Architecture;
                newModule.Keywords     = module.Keywords;
                newModule.Name         = module.Name;
                newModule.Owner        = module.Owner;
                newModule.Repository   = "";
                newModule.Version      = module.Version;

                newModule.insert();
            }

            return true;
        }
        catch ( string e ) {
            Json.AddElement( "message", e );
        }
        catch ( IException e ) {
            Json.AddElement( "message", e.what() );
        }

        return false;
    }

    public bool Delete( TModulesRecord module ) modify throws
    {
        try {
            var query = "UPDATE modules
                            SET deleted = NOW()
                          WHERE module = '" + module.Name + "'";

            Database.Execute( query );

            return true;
        }
        catch ( string e ) {
            Json.AddElement( "message", e );
        }
        catch ( IException e ) {
            Json.AddElement( "message", e.what() );
        }

        return false;
    }

    public bool Update( TModulesRecord module ) modify throws
    {
        try {
            var query = "UPDATE modules
                            SET architecture = '" + module.Architecture + "'
                                keywords = '" + module.Keywords + "'
                                version = '" + module.Version + "'
                          WHERE module = '" + module.Name + "'";

            Database.Execute( query );

            return true;
        }
        catch ( string e ) {
            Json.AddElement( "message", e );
        }
        catch ( IException e ) {
            Json.AddElement( "message", e.what() );
        }

        return false;
    }

}
