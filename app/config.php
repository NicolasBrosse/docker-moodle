<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'db';
$CFG->dbname    = getenv('MYSQL_DATABASE');
$CFG->dbuser    = getenv('MYSQL_USER');
$CFG->dbpass    = getenv('MYSQL_PASSWORD');
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbcollation' => 'utf8mb4_unicode_ci',
);

$CFG->wwwroot   = 'http://'.getenv('DOMAIN');
$CFG->dataroot  = '/var/moodledata';
$CFG->directorypermissions = 0777;

// DEBUG
@error_reporting(E_ALL | E_STRICT); // NOT FOR PRODUCTION SERVERS!
@ini_set('display_errors', '1');    // NOT FOR PRODUCTION SERVERS!
$CFG->debug = (E_ALL | E_STRICT);   // === DEBUG_DEVELOPER - NOT FOR PRODUCTION SERVERS!
$CFG->debugdisplay = 1;  

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!