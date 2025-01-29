<?php

// GitHub OAuth credentials
$client_id = 'Ov23li3Q8NnRl3hvjTyK';
$redirect_uri = 'https://modules.slang-lang.org/github-callback';

// GitHub authorization endpoint
$auth_url = "https://github.com/login/oauth/authorize?client_id=$client_id&redirect_uri=$redirect_uri&scope=user";

// Redirect the user to GitHub for authentication
header("Location: $auth_url");
exit;

?>
