<?php

/*
	Datatypes:
	- INTEGER
	- DOUBLE
	- CURRENCY
	- VARCHAR
	- TEXT
	- DATE
*/



// Name of the list
$liste["name"] = "tpl_ispc-clean_app";

// Database table
$liste["table"] = "tpl_ispc_clean_app";

// Index index field of the database table
$liste["table_idx"]	= "app_id";

// Search Field Prefix
$liste["search_prefix"] = "search_";

// Records per page
$liste["records_per_page"] 	= "15";

// Script File of the list
$liste["file"] = "tpl_ispc-clean_app_list.php";

// Script file of the edit form
$liste["edit_file"] = "tpl_ispc-clean_app_edit.php";

// Script File of the delete script
$liste["delete_file"] = "tpl_ispc-clean_app_del.php";

// Paging Template
$liste["paging_tpl"] = "templates/paging.tpl.htm";

// Enable auth
$liste["auth"] = "yes";

/*****************************************************
* Suchfelder
*****************************************************/

$liste["item"][] = array(   'field'	=> "active",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "SELECT",
                            'op'	=> "=",
                            'prefix'	=> "",
                            'suffix'	=> "",
                            'width'	=> "",
                            'value'	=> array('Y' => "<div id=\"ir-Yes\" class=\"swap\"><span>Yes</span></div>",'N' => "<div class=\"swap\" id=\"ir-No\"><span>No</span></div>")
);

$liste["item"][] = array(   'field'	=> "title",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "TEXT",
                            'op'	=> "like",
                            'prefix'	=> "%",
                            'suffix'	=> "%",
                            'width'	=> "",
                            'value'	=> ""
);

$liste["item"][] = array(   'field'	=> "desc",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "TEXT",
                            'op'	=> "like",
                            'prefix'	=> "%",
                            'suffix'	=> "%",
                            'width'	=> "",
                            'value'	=> ""
);

$liste["item"][] = array(   'field'	=> "image_url",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "TEXT",
                            'op'	=> "like",
                            'prefix'	=> "%",
                            'suffix'	=> "%",
                            'width'	=> "",
                            'value'	=> ""
);

$liste["item"][] = array(   'field'	=> "link",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "TEXT",
                            'op'	=> "like",
                            'prefix'	=> "%",
                            'suffix'	=> "%",
                            'width'	=> "",
                            'value'	=> ""
);

$liste["item"][] = array(   'field'	=> "target",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "TEXT",
                            'op'	=> "like",
                            'prefix'	=> "%",
                            'suffix'	=> "%",
                            'width'	=> "",
                            'value'	=> ""
);

$liste["item"][] = array(   'field'	=> "sorting",
                            'datatype'	=> "VARCHAR",
                            'formtype'	=> "TEXT",
                            'op'	=> "like",
                            'prefix'	=> "%",
                            'suffix'	=> "%",
                            'width'	=> "",
                            'value'	=> ""
);

?>