<?php
/******************************************
* Begin Form configuration
******************************************/

require_once('../../lib/config.inc.php');
require_once('../../lib/app.inc.php');

/******************************************
* Begin Form configuration
******************************************/

$list_def_file = "list/tpl_ispc-clean_cat.list.php";

/******************************************
* End Form configuration
******************************************/

//* Check permissions for module
$app->auth->check_module_permissions('admin');

$app->uses('listform_actions');

$app->listform_actions->SQLOrderBy = 'ORDER BY sorting ASC';
$app->listform_actions->onLoad();

?>