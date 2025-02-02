
mPlugin = {

	// consts
	SETTINGS_VIEW: "settingsView",

	// instance members
	pluginName: "settingsView",

	OnDeleteSuccess: function( event ) {
		Parameters.clear();

		LoadPlugin( "start" );
	},

	OnLoad: function( event ) {
		mElApiKey  = $( "#api_key" );
		mElModules = $( "#modules > tbody" );

		mPlugin.OnLoadReady();
	},

	OnLoadReady: function() {
		var elAppVersion = $( "#app_version" );
		elAppVersion.innerHTML = Templates.clone( "app_version" )
									.bind( "APP_VERSION", APP_VERSION )
									.str();

		this.RenderData( Cache.settings );
		this.QueryModules();

		LoadingFinished();
	},

	DeleteAccount: function() {
		if ( !confirm( Translations.token( "ACCOUNT_DELETE_CONFIRMATION" ) ) ) {
			return;
		}

		Account.DeleteAccount( mPlugin.OnDeleteSuccess );
	},

	GenerateApiKey: function() {
		Account.GenerateApiKey( mPlugin.QueryData );
	},

	Logout: function() {
		Account.Logout( OnLogoutSuccess );
	},

	QueryData: function() {
		Parameters.clear();

		get( "admin/users/settings/", ( response ) => {

			Globals.vm.settings = response.settings;

			mPlugin.RenderData( response.settings );

		} );
	},

	QueryModules: function() {
		Parameters.clear();

		get( "admin/crates/", ( response ) => {

			mPlugin.RenderModules( response.crates );

		} );
	},

	RenderData: function( settings ) {
		if ( !settings ) {
			return;
		}

		mElApiKey.value = settings.apiKey;
	},

	RenderModules: function( modules ) {
		var list = "";
		var moduleTpl = Templates.clone( "template-module" );

		for ( var idx = 0; idx < modules.length; ++idx ) {
			var module = modules[ idx ];

			list += moduleTpl.clone()
						.bind( "ADDED", module.created_at )
						.bind( "ARCHITECTURE", module.architecture )
						.bind( "DOWNLOADS", module.downloads )
						.bind( "LAST_UPDATE", module.updated_at )
						.bind( "NAME", module.name )
						.bind( "TYPE", module.type )
						.bind( "VERSION", module.max_version )
						.str();
		}

		mElModules.innerHTML = list;
	}

};

mCurrentPlugin = mPlugin;

