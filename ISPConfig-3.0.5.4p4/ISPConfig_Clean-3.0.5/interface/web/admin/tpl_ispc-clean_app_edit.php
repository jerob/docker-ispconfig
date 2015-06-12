<?php

/******************************************
* Begin Form configuration
******************************************/

$tform_def_file = "form/tpl_ispc-clean_app.tform.php";

/******************************************
* End Form configuration
******************************************/

require_once('../../lib/config.inc.php');
require_once('../../lib/app.inc.php');

//* Check permissions for module
$app->auth->check_module_permissions('admin');
if($conf['demo_mode'] == true) $app->error('This function is disabled in demo mode.');

// Loading classes
$app->uses('tpl,tform,tform_actions');
$app->load('tform_actions');

class page_action extends tform_actions {
	
}

$page = new page_action;
$page->onLoad();

?>
