<?php

//Debug settings;
define('FirePHP', true);

// Derived Constants
define('APP_PATH', dirname(dirname(__FILE__)) . '/');
define('WWW_BASE_PATH', str_replace('index.php', '', $_SERVER['SCRIPT_NAME']));
define('WWW_CSS_PATH', WWW_BASE_PATH . 'css/');
define('WWW_JS_PATH', WWW_BASE_PATH . 'js/');
define('WWW_IMAGE_PATH', WWW_BASE_PATH . 'img/');

// Include and configure the LighVC framework
include_once (APP_PATH . 'lib/lightvc.php');
Lvc_Config::addControllerPath(APP_PATH . 'app/controllers/');
Lvc_Config::addControllerViewPath(APP_PATH . 'app/views/');
Lvc_Config::addLayoutViewPath(APP_PATH . 'app/views/layouts/');
Lvc_Config::addElementViewPath(APP_PATH . 'app/views/elements/');
Lvc_Config::setViewClassName('AppView');

// Load AppController
include (APP_PATH . 'lib/WebpageController.php');
include (APP_PATH . 'lib/AppView.php');

// Load Routes
include (APP_PATH . 'config/routes.php');

// Load Database settings
include (APP_PATH . 'config/database.php');
?>