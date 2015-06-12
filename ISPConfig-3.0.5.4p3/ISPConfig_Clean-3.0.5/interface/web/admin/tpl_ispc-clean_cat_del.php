<?php

/******************************************
* Begin Form configuration
******************************************/

$list_def_file = "list/tpl_ispc-clean_cat.list.php";
$tform_def_file = "form/tpl_ispc-clean_cat.tform.php";

/******************************************
* End Form configuration
******************************************/

require_once('../../lib/config.inc.php');
require_once('../../lib/app.inc.php');

//* Check permissions for module
$app->auth->check_module_permissions('admin');
if($conf['demo_mode'] == true) $app->error('This function is disabled in demo mode.');

$app->uses("tform_actions");
$app->tform_actions->onDelete();

?>