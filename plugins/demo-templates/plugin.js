
mPlugin = {

    // consts
    DEMO_VIEW: "demo-templates",

    // instance members
    pagination: {
        currentPage: 1,
        numPages: 1,
    },
    data : {
        transactions: []
    },

    OnLoad: function() {
        mElTransactions = $( "#transactions > tbody" );
    },

    OnLoadReady: function() {
        LoadingFinished();
    },

    OnUnload: function() {
        // nothing to do here
    },

    NextDemo: function() {
        LoadPluginWithHistory( "demo-translations" );
    },

    Reload: function() {
        this.pagination.currentPage = 1;

        this.RenderTransactions( this.transactions );
    },

    RenderTransactions: function( data ) {
        if ( !data.transactions.length ) {
            mElTransactions.innerHTML = Templates.clone( "template-transaction-row-default" ).str();

            Translations.translate( mElTransactions );

            return;
        }

        var listItems = "";

        for ( idx = 0; idx < data.transactions.length; ++idx ) {
            var entry = data.transactions[ idx ];

            listItems += Templates.clone( "template-transaction-row" )
                            .bind( "AMOUNT", Translations.number( entry.amount ) )
                            .bind( "BROKER", entry.broker )
                            .bind( "INSTRUMENT_CODE", entry.instrumentCode )
                            .bind( "PRICE", Translations.number( entry.price ) )
                            .bind( "SIDE", entry.side.toLowerCase() )
                            .bind( "TIME", entry.time )
                            .bind( "TYPE", entry.type )
                            .str();
        }

        mElTransactions.innerHTML = listItems;

        Translations.translate( mElTransactions );

        this.pagination = data.pagination;

        Pagination( this.pagination );
    },

};

mCurrentPlugin = mPlugin;
