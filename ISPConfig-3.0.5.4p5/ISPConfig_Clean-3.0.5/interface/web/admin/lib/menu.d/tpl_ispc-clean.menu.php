<?php

//clean up. Added by ISPC-Clean
unset($items);

$items[] = array(   'title'     => 'ISPClean Theme',
                    'target' 	=> 'content',
                    'link'	=> 'admin/tpl_ispc-clean_edit.php?id=1',
                    'html_id'   => 'tpl_ispc-clean_admin');

$items[] = array(   'title'     => 'ISPClean Sidebar Categories',
                    'target' 	=> 'content',
                    'link'	=> 'admin/tpl_ispc-clean_cat_list.php',
                    'html_id'   => 'tpl_ispc-clean_cat');

$items[] = array(   'title'     => 'ISPClean Sidebar Applications',
                    'target' 	=> 'content',
                    'link'	=> 'admin/tpl_ispc-clean_app_list.php',
                    'html_id'   => 'tpl_ispc-clean_app');

$module['nav'][] = array(   'title'	=> 'ISPClean Theme Settings',
                            'open' 	=> 1,
                            'items'	=> $items);

?>