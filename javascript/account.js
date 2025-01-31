
const DEFAULT_LANGUAGE = "EN";

Account = {

	apiKey: null,
	identifier: null,
	language: DEFAULT_LANGUAGE,
	persistentSession: false,
	sessionId: null,
	useProUI: false,

OnApiKeyGeneratedSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			this.apiKey = response.message.apiKey;

			Parameters.addOrSetPermanent( "apiKey", this.apiKey );

			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnError: function( event ) {
	// request execution failed
	Notifications.notifyError( event.currentTarget.responseText );

	Account.Logout( History.Refresh );
},

OnLoginSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			Account.SetLogin( response.message.data );

			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnRegisterSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnSessionReload: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			Account.SetLogin( response.message.data );

			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			Account.Logout( LoadPlugin( "loginView" ) );

			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnSuccess: function( event ) {
	// request execution was successful

	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

OnUpdateSuccess: function( event ) {
	var response = {};
	if ( ParseJSON( event.currentTarget.responseText, response ) ) {
		// json string has been parsed successfully
		if ( response.message.result == "success" ) {
			if ( mCallbackSuccess ) {
				mCallbackSuccess();
			}
		}
		else if ( mCallbackFailed ) {
			mCallbackFailed( response.message.message );
		}
	}
	else {
		// error while parsing json string
		OnError( "Error: " + event.currentTarget.responseText );
	}

	mCallbackFailed = null;
	mCallbackSuccess = null;
},

Constructor: function() {
	mCallbackFailed  = null;
	mCallbackSuccess = null;
	mElLoginLabel    = null;

	this.identifier        = localStorage.getItem( "identifier" );
	this.persistentSession = localStorage.getItem( "persistentSession" );
	this.sessionId         = localStorage.getItem( "sessionID" );
	this.useProUI          = localStorage.getItem( "useProUI" );

	if ( this.identifier && this.sessionId ) {
		Parameters.addOrSetPermanent( "identifier", this.identifier );
		Parameters.addOrSetPermanent( "sessionID", this.sessionId );

		Account.ReloadSession( this.identifier, this.sessionId, OnLoginSuccess, OnLoginFailed );
	}
},

CheckSession: function() {
	Account.ReloadSession( Account.GetIdentifier(), Account.GetSessionId() );
},

DeleteAccount: function( identifier ) {
	execute( "admin/deleteUser.os", Logout, this.OnError );
},

GenerateApiKey: function( callbackSuccess, callbackFailed ) {
	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	execute( "admin/generateApiKey.os", this.OnApiKeyGeneratedSuccess, this.OnError );
},

GetIdentifier: function() {
	return this.identifier;
},

GetLastPlugin: function() {
	return localStorage.getItem( "lastPlugin" );
},

GetSessionId: function() {
	return this.sessionId;
},

GetUseProUI: function() {
	return this.useProUI == true || this.useProUI == "1";
},

IsLoggedIn: function() {
	return this.identifier && this.sessionId;
},

IsSessionPersistent: function() {
	return this.identifier && this.persistentSession;
},

Login: function( username, password, stayLoggedIn, callbackSuccess, callbackFailed ) {
	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	this.persistentSession = stayLoggedIn;

	Parameters.clear();
	Parameters.add( "username", username );
	Parameters.add( "password", password );
	Parameters.add( "stayLoggedIn", stayLoggedIn );

	execute( "admin/loginUser.os", this.OnLoginSuccess, this.OnError );
},

Logout: function( callbackSuccess ) {
	if ( mElLoginLabel ) {
		mElLoginLabel.textContent = "Login";
	}

	mCallbackFailed = null;
	mCallbackSuccess = callbackSuccess;

	this.apiKey = null;
	this.identifier = null;
	this.persistentSession = false;
	this.sessionId = null;
	this.useProUI = false;

	localStorage.removeItem( "identifier" );
	localStorage.removeItem( "lastPlugin" );
	localStorage.removeItem( "persistentSession" );
	localStorage.removeItem( "sessionID" );
	localStorage.removeItem( "useProUI" );
	localStorage.clear();

	execute( "admin/logoutUser.os" );

	Parameters.removePermanent( "apiKey" );
	Parameters.removePermanent( "identifier" );
	Parameters.removePermanent( "sessionID" );

	if ( callbackSuccess ) {
		callbackSuccess();
	}
},

Register: function( username, callbackSuccess, callbackFailed ) {
	mCallbackFailed = callbackFailed
	mCallbackSuccess = callbackSuccess;

	Parameters.clear();
	Parameters.add( "username", username );

	execute( "admin/registerUser.os", this.OnRegisterSuccess, this.OnError );
},

ReloadSession: function( identifier, sessionID, callbackSuccess, callbackFailed ) {
	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.addOrSet( "identifier", identifier );
	Parameters.addOrSet( "sessionID", sessionID );

	execute( "admin/loadSession.os", this.OnSessionReload, this.OnError );
},

ResetPassword: function( username, callbackSuccess, callbackFailed ) {
	if ( !username ) {
		if ( callbackFailed ) {
			callbackFailed( "username identifier" );
			return;
		}
	}

	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.add( "username", username );

	execute( "admin/resetPassword.os", this.OnSuccess, this.OnError );
},

SetCurrentPlugin: function( pluginName ) {
	localStorage.setItem( "lastPlugin", pluginName );
},

SetLogin: function( data ) {
	if ( !mElLoginLabel ) {
		mElLoginLabel = document.getElementById( "login_label" );
	}

	if ( mElLoginLabel ) {
		mElLoginLabel.textContent = username;
	}

	this.apiKey = data.apiKey;
	this.identifier = data.identifier;
	this.sessionId = data.sessionID;
	this.useProUI = data.useProUI;

	localStorage.setItem( "identifier", this.identifier );
	localStorage.setItem( "persistentSession", this.persistentSession );
	localStorage.setItem( "sessionID", this.sessionId );
	localStorage.setItem( "useProUI", this.useProUI );

	Parameters.addOrSetPermanent( "apiKey", this.apiKey );
	Parameters.addOrSetPermanent( "identifier", this.identifier );
	Parameters.addOrSetPermanent( "sessionID", this.sessionId );

	Account.SwitchLanguage( data.language );

	LoadTheme( data.theme ? data.theme : "bootstrap" );

	if ( OnLogin ) {
		OnLogin();
	}
},

SwitchLanguage: function( language ) {
	if ( !language ) {
		language = DEFAULT_LANGUAGE;
	}

	if ( this.language == language ) {
		// no need to change anything
		return;
	}

	this.language = language;

	// update HTML page language attribute
	document.documentElement.setAttribute( "lang", language.toLowerCase() );

	Translations.loadLanguage( language );
},

SwitchTheme: function( theme ) {
	LoadTheme( theme );

	ReloadUI();
},

SwitchUser: function( identifier, sessionID, apiKey ) {
	this.apiKey = apiKey;
	this.identifier = identifier;
	this.sessionId = sessionID;

	Parameters.addOrSetPermanent( "apiKey", this.apiKey );
	Parameters.addOrSetPermanent( "identifier", this.identifier );
	Parameters.addOrSetPermanent( "sessionID", this.sessionId );

	Navigation.Reload();
},

SwitchUserInterface: function( useProUI ) {
	this.useProUI = useProUI;

	localStorage.setItem( "useProUI", useProUI );

	ReloadUI();
},

UpdatePassword: function( identifier, password, callbackSuccess, callbackFailed ) {
	if ( !identifier ) {
		if ( callbackFailed ) {
			callbackFailed( "invalid identifier" );
			return;
		}
	}

	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.add( "password", password );

	execute( "admin/updatePassword.os", this.OnSuccess, this.OnError );
},

UpdateUser: function( identifier, prename, surname, callbackSuccess, callbackFailed ) {
	if ( !identifier ) {
		if ( callbackFailed ) {
			callbackFailed("invalid identifier");
			return;
		}
	}

	mCallbackSuccess = callbackSuccess;
	mCallbackFailed = callbackFailed;

	Parameters.clear();
	Parameters.add( "prename", prename );
	Parameters.add( "surname", surname );

	execute( "admin/updateUser.os", this.OnSuccess, this.OnError );
}

}

