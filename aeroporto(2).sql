-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: lerd-mysql
-- Generation Time: Aug 26, 2026 at 02:26 PM
-- Server version: 8.4.11
-- PHP Version: 8.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aeroporto`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `aeroporto`
-- (See below for the actual view)
--
CREATE TABLE `aeroporto` (
);

-- --------------------------------------------------------

--
-- Table structure for table `table1`
--

CREATE TABLE `table1` (
  `idtable` int NOT NULL,
  `table1col` varchar(45) NOT NULL,
  `table1col1` varchar(45) NOT NULL,
  `table1col2` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Table2`
--

CREATE TABLE `Table2` (
  `idtable2` int NOT NULL,
  `tablecol` varchar(45) NOT NULL,
  `tablecol1` varchar(45) NOT NULL,
  `tablecol2` varchar(45) NOT NULL,
  `tablecol3` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure for view `aeroporto`
--
DROP TABLE IF EXISTS `aeroporto`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `aeroporto`  AS SELECT `table1`.`id_passageiro` AS `id_passageiro`, `table1`.`nome` AS `nome`, `table1`.`passaporte` AS `passaporte`, `table1`.`cpf` AS `cpf`, `table1`.`idade` AS `idade` FROM `table1` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
