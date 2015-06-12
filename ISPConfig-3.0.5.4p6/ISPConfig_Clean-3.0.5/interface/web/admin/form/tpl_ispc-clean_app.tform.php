<?php

/*
	Form Definition

	Tabledefinition

	Datatypes:
	- INTEGER (Forces the input to Int)
	- DOUBLE
	- CURRENCY (Formats the values to currency notation)
	- VARCHAR (no format check, maxlength: 255)
	- TEXT (no format check)
	- DATE (Dateformat, automatic conversion to timestamps)

	Formtype:
	- TEXT (Textfield)
	- TEXTAREA (Textarea)
	- PASSWORD (Password textfield, input is not shown when edited)
	- SELECT (Select option field)
	- RADIO
	- CHECKBOX
	- CHECKBOXARRAY
	- FILE

	VALUE:
	- Wert oder Array

	Hint:
	The ID field of the database table is not part of the datafield definition.
	The ID field must be always auto incement (int or bigint).
	
	Search:
	- searchable = 1 or searchable = 2 include the field in the search
	- searchable = 1: this field will be the title of the search result
	- searchable = 2: this field will be included in the description of the search result


*/

$form["title"] 		= "ISPClean Sidebar Applications";
$form["description"] 	= "Applications in the Login Sidebar";
$form["name"] 		= "tpl_ispc-clean_app";
$form["action"]		= "tpl_ispc-clean_app_edit.php";
$form["db_table"]	= "tpl_ispc_clean_app";
$form["db_table_idx"]	= "app_id";
$form["db_history"]	= "no";
$form["tab_default"]	= "app";
$form["list_default"]	= "tpl_ispc-clean_app_list.php";
$form["auth"]		= 'yes'; // yes / no

$form["auth_preset"]["userid"]  = 0; // 0 = id of the user, > 0 id must match with id of current user
$form["auth_preset"]["groupid"] = 0; // 0 = default groupid of the user, > 0 id must match with groupid of current user
$form["auth_preset"]["perm_user"] = 'riud'; //r = read, i = insert, u = update, d = delete
$form["auth_preset"]["perm_group"] = 'riud'; //r = read, i = insert, u = update, d = delete
$form["auth_preset"]["perm_other"] = ''; //r = read, i = insert, u = update, d = delete

$form["tabs"]['app'] = array (
	'title' 	=> "Application",
	'width' 	=> 100,
	'template' 	=> "templates/tpl_ispc-clean_app_edit.htm",
	'fields' 	=> array (
	##################################
	# Begin Datatable fields
	##################################
		'title' => array (
			'datatype'	=> 'VARCHAR',
			'formtype'	=> 'TEXT',
			'default'	=> '',
			'value'		=> '',
			'width'		=> '30',
			'maxlength'	=> '64',
		),
		'desc' => array (
			'datatype'	=> 'VARCHAR',
			'formtype'	=> 'TEXT',
			'default'	=> '',
			'value'		=> '',
			'width'		=> '30',
			'maxlength'	=> '255',
		),
		'image_url' => array (
			'datatype'	=> 'VARCHAR',
			'formtype'	=> 'TEXT',
			'default'	=> '',
			'value'		=> '',
			'width'		=> '30',
			'maxlength'	=> '255'
		),
		'link' => array (
			'datatype'	=> 'VARCHAR',
			'formtype'	=> 'TEXT',
			'default'	=> '',
			'value'		=> '',
			'width'		=> '30',
			'maxlength'	=> '255'
		),
		'target' => array (
			'datatype'	=> 'VARCHAR',
			'formtype'	=> 'SELECT',
			'default'	=> '_blank',
			'value'		=> array( "_blank" => "_blank", "_self" => "_self", "_parent" => "_parent", "_top" => "_top"),
			'width'		=> '30',
			'maxlength'	=> '16'
		),
		'sorting' => array (
			'datatype'	=> 'INTEGER',
			'formtype'	=> 'TEXT',
			'default'	=> '',
			'value'		=> '',
			'width'		=> '10',
			'maxlength'	=> '10'
		),
		'category' => array (
			'datatype'	=> 'TEXT',
			'formtype'	=> 'SELECT',
			'default'	=> '',
			'datasource'	=> array ( 	'type'	=> 'SQL',
										'querystring' => 'SELECT title FROM tpl_ispc_clean_cat WHERE {AUTHSQL} AND active = "Y" ORDER BY sorting',
										'keyfield'=> 'title',
										'valuefield'=> 'title'
									 ),
			'value'		=> 'title',
			'width'		=> '10',
			'maxlength'	=> '255'
		),
        'active' => array (
            'datatype'	=> 'VARCHAR',
            'formtype'	=> 'CHECKBOX',
            'default'	=> 'Y',
            'value'     => array(0 => 'N',1 => 'Y')
        ),
	##################################
	# ENDE Datatable fields
	##################################
	)
);

?>