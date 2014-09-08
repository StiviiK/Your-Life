-- phpMyAdmin SQL Dump
-- version 4.1.6
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Erstellungszeit: 08. Sep 2014 um 13:11
-- Server Version: 5.6.16
-- PHP-Version: 5.5.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `y-life`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `housesystem_houses`
--

CREATE TABLE IF NOT EXISTS `housesystem_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(100) NOT NULL,
  `pos_x` int(11) NOT NULL,
  `pos_y` int(11) NOT NULL,
  `pos_z` int(11) NOT NULL,
  `sold` varchar(10) NOT NULL,
  `forrent` varchar(10) NOT NULL,
  `rent` int(11) NOT NULL,
  ` tenant` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `userdata`
--

CREATE TABLE IF NOT EXISTS `userdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(500) NOT NULL,
  `playtime` int(11) NOT NULL DEFAULT '0',
  `salt` varchar(11) NOT NULL,
  `health` int(11) NOT NULL DEFAULT '100',
  `armor` int(11) NOT NULL DEFAULT '100',
  `faction` int(11) NOT NULL DEFAULT '0',
  `factionrank` int(11) NOT NULL DEFAULT '-1',
  `adminlvl` int(11) NOT NULL DEFAULT '0',
  `foodlvl` int(11) NOT NULL DEFAULT '100',
  `jailtime` int(11) NOT NULL DEFAULT '0',
  `mail` varchar(400) NOT NULL,
  `birth` varchar(100) NOT NULL,
  `spawntype` varchar(100) NOT NULL,
  `spawn_x` int(11) NOT NULL,
  `spawn_y` int(11) NOT NULL,
  `spawn_z` int(11) NOT NULL,
  `rot` int(11) NOT NULL,
  `interrior` int(11) NOT NULL,
  `dimension` int(11) NOT NULL,
  `skinid` int(11) NOT NULL,
  `socialstate` varchar(100) NOT NULL,
  `friends` text NOT NULL,
  `vehiclekeys` text NOT NULL,
  `housekey` int(11) NOT NULL,
  `housekey_type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;
-- ---------------------------------------------------

--
-- Tabellenstruktur für Tabelle `userdata_bankaccounts`
--

CREATE TABLE IF NOT EXISTS `userdata_bankaccounts` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `money` int(11) NOT NULL,
  `log` text NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Daten für Tabelle `userdata_bankaccounts`
--

INSERT INTO `userdata_bankaccounts` (`id`, `username`, `money`, `log`) VALUES
(1, 'StiviK', 2000, '[28.6.2014 - 12:41] Einzahlung: 2000$\\n');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `userdata_bans`
--

CREATE TABLE IF NOT EXISTS `userdata_bans` (
  `id` int(110) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `serial` varchar(500) NOT NULL,
  `admin` varchar(200) NOT NULL,
  `reason` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `s_bantime` int(11) NOT NULL,
  `e_bantime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `userdata_serial`
--

CREATE TABLE IF NOT EXISTS `userdata_serial` (
  `serial` text NOT NULL,
  `username` varchar(20) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `vehicledata_faction`
--

CREATE TABLE IF NOT EXISTS `vehicledata_faction` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `faction` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `spawn_x` int(11) NOT NULL,
  `spawn_y` int(11) NOT NULL,
  `spawn_z` int(11) NOT NULL,
  `rot_x` int(11) NOT NULL,
  `rot_y` int(11) NOT NULL,
  `rot_z` int(11) NOT NULL,
  `color1` int(11) NOT NULL,
  `color2` int(11) NOT NULL,
  `color3` int(11) NOT NULL,
  `damage` int(11) NOT NULL,
  `carnumber` int(11) NOT NULL,
  `fuel` int(11) NOT NULL,
  `numberplate` varchar(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Daten für Tabelle `vehicledata_faction`
--

INSERT INTO `vehicledata_faction` (`ID`, `faction`, `rank`, `model`, `spawn_x`, `spawn_y`, `spawn_z`, `rot_x`, `rot_y`, `rot_z`, `color1`, `color2`, `color3`, `damage`, `carnumber`, `fuel`, `numberplate`) VALUES
(1, 1, 0, 599, 170, 10, 1, 0, 0, 94, 150, 204, 0, 1000, 1, 100, 'SF 3000'),
(2, 1, 3, 599, 170, 13, 1, 0, 0, 90, 255, 150, 13, 1000, 2, 100, 'SF 3001'),
(3, 1, 3, 599, 170, 16, 1, 0, 0, 90, 145, 125, 134, 1000, 3, 100, 'SF 3002'),
(4, 1, 3, 599, 170, 19, 1, 0, 0, 90, 255, 255, 99, 1000, 4, 100, 'SF 3003'),
(5, 1, 3, 599, 170, 22, 1, 0, 0, 90, 145, 125, 255, 1000, 5, 100, 'SF 3004'),
(6, 1, 3, 599, 170, 25, 1, 0, 0, 90, 132, 255, 145, 1000, 6, 100, 'SF 3005');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `vehicledata_private`
--

CREATE TABLE IF NOT EXISTS `vehicledata_private` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `destroyed` varchar(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `model` int(11) NOT NULL,
  `spawn_x` int(11) NOT NULL,
  `spawn_y` int(11) NOT NULL,
  `spawn_z` int(11) NOT NULL,
  `rot_x` int(11) NOT NULL,
  `rot_y` int(11) NOT NULL,
  `rot_z` int(11) NOT NULL,
  `color1` int(11) NOT NULL,
  `color2` int(11) NOT NULL,
  `color3` int(11) NOT NULL,
  `damage` int(11) NOT NULL,
  `carnumber` int(11) NOT NULL,
  `fuel` int(11) NOT NULL,
  `numberplate` varchar(11) NOT NULL,
  `tunings` varchar(1000) NOT NULL,
  `s_tunings` varchar(1100) NOT NULL,
  PRIMARY KEY (`destroyed`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
