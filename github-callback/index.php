<?php

require( "config.php" );


// Get the authorization code from the callback
if (isset($_GET['code'])) {
    $code = $_GET['code'];

    // Exchange the authorization code for an access token
    $token_url = 'https://github.com/login/oauth/access_token';
    $data = [
        'client_id' => $client_id,
        'client_secret' => $client_secret,
        'code' => $code,
    ];

    // Make a POST request to GitHub's token endpoint
    $options = [
        'http' => [
            'header'  => "Content-type: application/x-www-form-urlencoded\r\nAccept: application/json\r\n",
            'method'  => 'POST',
            'content' => http_build_query($data),
        ],
    ];
    $context = stream_context_create($options);
    $response = file_get_contents($token_url, false, $context);
    $result = json_decode($response, true);

    if (isset($result['access_token'])) {
        $access_token = $result['access_token'];

        // Use the access token to fetch user information
        $user_url = 'https://api.github.com/user';
        $options = [
            'http' => [
                'header' => "Authorization: Bearer $access_token\r\nUser-Agent: YourAppName\r\n",
                'method' => 'GET',
            ],
        ];
        $context = stream_context_create($options);
        $user_response = file_get_contents($user_url, false, $context);
        $user = json_decode($user_response, true);

        // Display user information
        echo 'Welcome, ' . htmlspecialchars($user['login']);

        $login = $user['login'];
        $token = $access_token;

        $auth_success_url = "https://modules.slang-lang.org/?login=$login&token=$token";

        // Redirect the user to modules.slang-lang.org and provide authorization data
        header("Location: $auth_success_url");
        exit;

    }
    else {
        echo 'Error: Failed to obtain access token.';
    }
}
else {
    echo 'Error: Authorization code not provided.';
}

?>

