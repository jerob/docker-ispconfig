-- ISPC-Clean Table Configuration
-- Generation Time: May 13, 2013 at 06:50 PM


SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dbispconfig`
--
USE `dbispconfig`;
-- --------------------------------------------------------

--
-- Table structure for table `tpl_ispc_clean`
--

CREATE TABLE IF NOT EXISTS `tpl_ispc_clean` (
  `themesettings_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sys_userid` int(11) DEFAULT NULL,
  `sys_groupid` int(11) DEFAULT NULL,
  `sys_perm_user` varchar(5) DEFAULT NULL,
  `sys_perm_group` varchar(5) DEFAULT NULL,
  `sys_perm_other` varchar(5) DEFAULT NULL,
  `logo_url` varchar(255) NOT NULL,
  `sidebar_state` tinyint(1) NOT NULL,
  PRIMARY KEY (`themesettings_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `tpl_ispc_clean`
--

INSERT INTO `tpl_ispc_clean` (`themesettings_id`, `sys_userid`, `sys_groupid`, `sys_perm_user`, `sys_perm_group`, `sys_perm_other`, `logo_url`, `sidebar_state`) VALUES
(1, 1, 1, 'riud', 'riud', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tpl_ispc_clean_app`
--

CREATE TABLE IF NOT EXISTS `tpl_ispc_clean_app` (
  `app_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sys_userid` int(11) unsigned NOT NULL DEFAULT '0',
  `sys_groupid` int(11) unsigned NOT NULL DEFAULT '0',
  `sys_perm_user` varchar(5) DEFAULT NULL,
  `sys_perm_group` varchar(5) DEFAULT NULL,
  `sys_perm_other` varchar(5) DEFAULT NULL,
  `title` varchar(64) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `link` varchar(255) NOT NULL,
  `target` varchar(16) NOT NULL,
  `sorting` tinyint(2) NOT NULL,
  `category` varchar(255) NOT NULL,
  `active` enum('N','Y') NOT NULL,
  PRIMARY KEY (`app_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tpl_ispc_clean_cat`
--

CREATE TABLE IF NOT EXISTS `tpl_ispc_clean_cat` (
  `cat_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sys_userid` int(11) unsigned NOT NULL DEFAULT '0',
  `sys_groupid` int(11) unsigned NOT NULL DEFAULT '0',
  `sys_perm_user` varchar(5) DEFAULT NULL,
  `sys_perm_group` varchar(5) DEFAULT NULL,
  `sys_perm_other` varchar(5) DEFAULT NULL,
  `title` varchar(64) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `sorting` tinyint(2) NOT NULL,
  `active` enum('N','Y') NOT NULL,
  PRIMARY KEY (`cat_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `tpl_ispc_clean_cat`
--

INSERT INTO `tpl_ispc_clean_cat` (`cat_id`, `sys_userid`, `sys_groupid`, `sys_perm_user`, `sys_perm_group`, `sys_perm_other`, `title`, `desc`, `sorting`, `active`) VALUES
(1, 1, 1, 'riud', 'riud', '', 'Services', 'Category for Services', 10, 'Y'),
(2, 1, 1, 'riud', 'riud', '', 'Useful Links', 'Helpful links for Customers', 20, 'Y'),
(3, 1, 1, 'riud', 'riud', '', 'Linux News', 'Test Category', 30, 'Y');
