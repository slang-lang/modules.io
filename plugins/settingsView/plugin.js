
mPlugin = {

	// consts
	SETTINGS_VIEW: "settingsView",

	// instance members
	pluginName: "settingsView",

	OnDeleteSuccess: function( event ) {
		Parameters.clear();

		LoadPlugin( "loginView" );
	},

	OnKeyPress: function( event ) {
		Login();
	},

	OnLoad: function( event ) {
		mElApiKey                    = $( "#api_key" );
		mElEmail                     = $( "#email" );
		mElReceiveLoginNotifications = $( "#receive_login_notifications" );
		mElReceiveMailNotifications  = $( "#receive_mail_notifications" );
		mElUserProfile               = $( "#user_profile" );

		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		var elAppVersion = $( "#app_version" );
		elAppVersion.innerHTML = Templates.clone( "app_version" )
									.bind( "APP_VERSION", APP_VERSION )
									.str();

		this.RenderData( Cache.settings );

		LoadingFinished();
	},

	OnLoginFailed: function( message ) {
		mElMessage.textContent = message;
	},

	DeleteAccount: function() {
		if ( !confirm( Translations.token( "ACCOUNT_DELETE_CONFIRMATION" ) ) ) {
			return;
		}

		Account.DeleteAccount( mPlugin.OnDeleteSuccess );
	},

	GenerateApiKey: function() {
		Account.GenerateApiKey( mPlugin.LoadData );
	},

	LoadData: function() {
		Parameters.clear();

		get( "admin/users/settings/", ( response ) => {

			Globals.vm.settings = response.settings;

			mPlugin.RenderData( response.settings );

		} );
	},

	Logout: function() {
		Account.Logout( OnLogoutSuccess );
	},

	Refresh: function() {
		History.Refresh();
	},

	RenderData: function( settings ) {
		if ( !settings ) {
			return;
		}

		mElApiKey.value                      = settings.apiKey;
		mElEmail                             = Cache.userInfo.login;
		//mElReceiveLoginNotifications.checked = settings.sendLoginNotifications;
		//mElReceiveMailNotifications.checked  = settings.sendMailNotifications;
		//mElUserProfile.value                 = Translations.token( settings.userProfile );
	},

	UpdateUser: function() {
		if ( !IsFormValid( "frmUserSettings" ) ) {
			return;
		}

		Parameters.clear();

		Parameters.add( "receive_login_notifications", mElReceiveLoginNotifications.checked );
		Parameters.add( "receive_mail_notifications", mElReceiveMailNotifications.checked );

		execute( "admin/updateUser.os", () => {
			Cache.FetchSettings();
		} );
	}

};

mCurrentPlugin = mPlugin;

