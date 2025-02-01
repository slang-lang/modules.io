const DEFAULT_LANGUAGE = "EN";

Account = {
    apiKey: null,
    identifier: null,
    language: DEFAULT_LANGUAGE,
    persistentSession: false,
    sessionID: null,

    OnApiKeyGeneratedSuccess: function (event) {
        // request execution was successful

        var response = {};
        if (ParseJSON(event.currentTarget.responseText, response)) {
            // json string has been parsed successfully
            if (response.message.result == "success") {
                this.apiKey = response.message.apiKey;

                Parameters.addOrSetPermanent("apiKey", this.apiKey);

                if (mCallbackSuccess) {
                    mCallbackSuccess();
                }
            } else if (mCallbackFailed) {
                mCallbackFailed(response.message.message);
            }
        } else {
            // error while parsing json string
            OnError("Error: " + event.currentTarget.responseText);
        }

        mCallbackFailed = null;
        mCallbackSuccess = null;
    },

    OnError: function (event) {
        // request execution failed
        Notifications.notifyError(event.currentTarget.responseText);

        Account.Logout(History.Refresh);
    },

    OnLoginSuccess: function (event) {
        // request execution was successful

        var response = {};
        if (ParseJSON(event.currentTarget.responseText, response)) {
            // json string has been parsed successfully
            if (response.message.result == "success") {
                Account.SetLogin(response.message.data);

                if (mCallbackSuccess) {
                    mCallbackSuccess();
                }
            } else if (mCallbackFailed) {
                mCallbackFailed(response.message.message);
            }
        } else {
            // error while parsing json string
            OnError("Error: " + event.currentTarget.responseText);
        }

        mCallbackFailed = null;
        mCallbackSuccess = null;
    },

    OnRegisterSuccess: function (event) {
        // request execution was successful

        var response = {};
        if (ParseJSON(event.currentTarget.responseText, response)) {
            // json string has been parsed successfully
            if (response.message.result == "success") {
                if (mCallbackSuccess) {
                    mCallbackSuccess();
                }
            } else if (mCallbackFailed) {
                mCallbackFailed(response.message.message);
            }
        } else {
            // error while parsing json string
            OnError("Error: " + event.currentTarget.responseText);
        }

        mCallbackFailed = null;
        mCallbackSuccess = null;
    },

    OnSessionReload: function (event) {
        // request execution was successful

        var response = {};
        if (ParseJSON(event.currentTarget.responseText, response)) {
            // json string has been parsed successfully
            if (response.message.result == "success") {
                Account.SetLogin(response.message.data);

                if (mCallbackSuccess) {
                    mCallbackSuccess();
                }
            } else if (mCallbackFailed) {
                Account.Logout(LoadPlugin("start"));

                mCallbackFailed(response.message.message);
            }
        } else {
            // error while parsing json string
            OnError("Error: " + event.currentTarget.responseText);
        }

        mCallbackFailed = null;
        mCallbackSuccess = null;
    },

    OnSuccess: function (event) {
        // request execution was successful

        var response = {};
        if (ParseJSON(event.currentTarget.responseText, response)) {
            // json string has been parsed successfully
            if (response.message.result == "success") {
                if (mCallbackSuccess) {
                    mCallbackSuccess();
                }
            } else if (mCallbackFailed) {
                mCallbackFailed(response.message.message);
            }
        } else {
            // error while parsing json string
            OnError("Error: " + event.currentTarget.responseText);
        }

        mCallbackFailed = null;
        mCallbackSuccess = null;
    },

    OnUpdateSuccess: function (event) {
        var response = {};
        if (ParseJSON(event.currentTarget.responseText, response)) {
            // json string has been parsed successfully
            if (response.message.result == "success") {
                if (mCallbackSuccess) {
                    mCallbackSuccess();
                }
            } else if (mCallbackFailed) {
                mCallbackFailed(response.message.message);
            }
        } else {
            // error while parsing json string
            OnError("Error: " + event.currentTarget.responseText);
        }

        mCallbackFailed = null;
        mCallbackSuccess = null;
    },

    Constructor: function () {
        mCallbackFailed = null;
        mCallbackSuccess = null;

        this.identifier = localStorage.getItem("identifier");
        this.persistentSession = localStorage.getItem("persistentSession");
        this.sessionID = localStorage.getItem("sessionID");

        if (this.identifier && this.sessionID) {
            Parameters.addOrSetPermanent("identifier", this.identifier);
            Parameters.addOrSetPermanent("sessionID", this.sessionID);

            Account.ReloadSession(
                this.identifier,
                this.sessionID,
                OnLoginSuccess,
                OnLoginFailed,
            );
        }
    },

    CheckSession: function () {
        Account.ReloadSession(Account.GetIdentifier(), Account.GetSessionId());
    },

    DeleteAccount: function (identifier) {
        execute("admin/deleteUser.os", Logout, this.OnError);
    },

    GenerateApiKey: function (callbackSuccess, callbackFailed) {
        mCallbackFailed = callbackFailed;
        mCallbackSuccess = callbackSuccess;

        get(
            "admin/api_key/create/",
            (response) => {
                if (response.result == "success") {
                    this.apiKey = response.apiKey;

                    Parameters.addOrSetPermanent("apiKey", this.apiKey);

                    if (mCallbackSuccess) {
                        mCallbackSuccess();
                    }
                } else if (mCallbackFailed) {
                    mCallbackFailed(response.message);
                }
            },
            this.OnError,
        );
    },

    GetIdentifier: function () {
        return this.identifier;
    },

    GetSessionId: function () {
        return this.sessionID;
    },

    GithubLogin: function (callback) {
        Parameters.clear();
        Parameters.add("userId", Cache.userInfo.id);
        Parameters.add("username", Cache.userInfo.login);
        Parameters.add("email", Cache.userInfo.email);
        Parameters.add("userProfileUrl", Cache.userInfo.avatar_url);

        get(
            "admin/users/login/",
            (response) => {
                if (response.result == "success") {
                    Account.SetLogin(response.data);

                    if (mCallbackSuccess) {
                        mCallbackSuccess();
                    }
                } else if (mCallbackFailed) {
                    mCallbackFailed(response.message);
                }
            },
            this.OnError,
        );
    },

    IsLoggedIn: function () {
        return this.identifier && this.sessionID;
    },

    IsSessionPersistent: function () {
        return this.identifier && this.persistentSession;
    },

    Login: function (
        username,
        password,
        stayLoggedIn,
        callbackSuccess,
        callbackFailed,
    ) {
        mCallbackFailed = callbackFailed;
        mCallbackSuccess = callbackSuccess;

        this.persistentSession = stayLoggedIn;

        Parameters.clear();
        Parameters.add("username", username);
        Parameters.add("password", password);
        Parameters.add("stayLoggedIn", stayLoggedIn);

        execute("admin/loginUser.os", this.OnLoginSuccess, this.OnError);
    },

    Logout: function (callbackSuccess) {
        mCallbackFailed = null;
        mCallbackSuccess = callbackSuccess;

        this.apiKey = null;
        this.identifier = null;
        this.persistentSession = false;
        this.sessionID = null;

        localStorage.removeItem("identifier");
        localStorage.removeItem("persistentSession");
        localStorage.removeItem("sessionID");
        localStorage.removeItem("token");
        localStorage.removeItem("userInfo");
        localStorage.clear();

        //execute( "admin/logoutUser.os" );

        Parameters.removePermanent("apiKey");
        Parameters.removePermanent("identifier");
        Parameters.removePermanent("token");
        Parameters.removePermanent("userInfo");

        if (callbackSuccess) {
            callbackSuccess();
        }
    },

    Register: function (username, callbackSuccess, callbackFailed) {
        mCallbackFailed = callbackFailed;
        mCallbackSuccess = callbackSuccess;

        Parameters.clear();
        Parameters.add("username", username);

        execute("admin/registerUser.os", this.OnRegisterSuccess, this.OnError);
    },

    ReloadSession: function (
        identifier,
        sessionID,
        callbackSuccess,
        callbackFailed,
    ) {
        mCallbackFailed = callbackFailed;
        mCallbackSuccess = callbackSuccess;

        Parameters.clear();
        Parameters.addOrSet("identifier", identifier);
        Parameters.addOrSet("sessionID", sessionID);

        execute("admin/loadSession.os", this.OnSessionReload, this.OnError);
    },

    ResetPassword: function (username, callbackSuccess, callbackFailed) {
        if (!username) {
            if (callbackFailed) {
                callbackFailed("username identifier");
                return;
            }
        }

        mCallbackFailed = callbackFailed;
        mCallbackSuccess = callbackSuccess;

        Parameters.clear();
        Parameters.add("username", username);

        execute("admin/resetPassword.os", this.OnSuccess, this.OnError);
    },

    SetCurrentPlugin: function (pluginName) {
        localStorage.setItem("lastPlugin", pluginName);
    },

    SetLogin: function (data) {
        this.apiKey = data.apiKey;
        this.identifier = data.identifier;
        this.sessionID = data.sessionID;

        localStorage.setItem("identifier", this.identifier);
        localStorage.setItem("persistentSession", this.persistentSession);
        localStorage.setItem("sessionID", this.sessionID);

        Parameters.addOrSetPermanent("apiKey", this.apiKey);
        Parameters.addOrSetPermanent("identifier", this.identifier);
        Parameters.addOrSetPermanent("sessionID", this.sessionID);

        OnLoginSuccess();
    },

    SwitchLanguage: function (language) {
        if (!language) {
            language = DEFAULT_LANGUAGE;
        }

        if (this.language == language) {
            // no need to change anything
            return;
        }

        this.language = language;

        // update HTML page language attribute
        document.documentElement.setAttribute("lang", language.toLowerCase());

        Translations.loadLanguage(language);
    },
};
