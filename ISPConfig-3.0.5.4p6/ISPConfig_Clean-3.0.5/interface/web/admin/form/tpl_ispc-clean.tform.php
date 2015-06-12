<?php

/*
	Form Definition

	Tabellendefinition

	Datentypen:
	- INTEGER (Wandelt Ausdrücke in Int um)
	- DOUBLE
	- CURRENCY (Formatiert Zahlen nach Währungsnotation)
	- VARCHAR (kein weiterer Format Check)
	- TEXT (kein weiterer Format Check)
	- DATE (Datumsformat, Timestamp Umwandlung)

	Formtype:
	- TEXT (normales Textfeld)
	- TEXTAREA (normales Textfeld)
	- PASSWORD (Feldinhalt wird nicht angezeigt)
	- SELECT (Gibt Werte als option Feld aus)
	- RADIO
	- CHECKBOX
	- FILE

	VALUE:
	- Wert oder Array

	Hinweis:
	Das ID-Feld ist nicht bei den Table Values einzufügen.


*/

$form["title"] 		= "ISPClean Theme Settings";
$form["description"]= "Basic Settings for the ISPC-Clean Theme";
$form["name"] 		= "tpl_ispc-clean_settings";
$form["action"]		= "tpl_ispc-clean_edit.php";
$form["db_table"]	= "tpl_ispc_clean";
$form["db_table_idx"]	= "themesettings_id";
$form["db_history"]	= "yes";
$form["tab_default"]= "basic";
$form["list_default"]	= "server_list.php";
$form["auth"]		= 'yes';

$form["auth_preset"]["userid"]  = 0; // 0 = id of the user, > 0 id must match with id of current user
$form["auth_preset"]["groupid"] = 0; // 0 = default groupid of the user, > 0 id must match with groupid of current user
$form["auth_preset"]["perm_user"] = 'riud'; //r = read, i = insert, u = update, d = delete
$form["auth_preset"]["perm_group"] = 'riud'; //r = read, i = insert, u = update, d = delete
$form["auth_preset"]["perm_other"] = ''; //r = read, i = insert, u = update, d = delete


$form["tabs"]['basic'] = array (
	'title' 	=> "Basic Settings",
	'width' 	=> 80,
	'template' 	=> "templates/tpl_ispc-clean_edit.htm",
	'fields' 	=> array (
	##################################
	# Beginn Datenbankfelder
	##################################
		'logo_url' => array (
			'datatype'	=> 'VARCHAR',
			'formtype'	=> 'TEXT',
			'default'	=> '',
			'value'		=> '',
			'separator'	=> '',
			'width'		=> '40',
			'maxlength'	=> '255'
		),
        'sidebar_state' => array (
			'datatype'	=> 'INTEGER',
			'formtype'	=> 'SELECT',
			'default'	=> '',
			'value'		=> array(0 => 'Off', 1 => 'On'),
		),
	##################################
	# ENDE Datenbankfelder
	##################################
	)
);

?>