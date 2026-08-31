-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: lerd-mysql
-- Generation Time: Aug 31, 2026 at 11:20 AM
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
  `id_passageiro` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `passaporte` varchar(20) DEFAULT NULL,
  `cpf` varchar(14) NOT NULL,
  `idade` int DEFAULT NULL
);

-- --------------------------------------------------------

--
-- Table structure for table `passageiro`
--

CREATE TABLE `passageiro` (
  `id_passageiro` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `passaporte` varchar(20) DEFAULT NULL,
  `data_nascimento` date NOT NULL,
  PRIMARY KEY (`id_passageiro`),
  UNIQUE KEY `cpf_UNIQUE` (`cpf`),
  UNIQUE KEY `passaporte_UNIQUE` (`passaporte`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `voo`
--

CREATE TABLE `voo` (
  `id_voo` int NOT NULL AUTO_INCREMENT,
  `codigo_voo` varchar(10) NOT NULL,
  `origem` varchar(50) NOT NULL,
  `destino` varchar(50) NOT NULL,
  `data_hora_partida` datetime NOT NULL,
  PRIMARY KEY (`id_voo`),
  UNIQUE KEY `codigo_voo_UNIQUE` (`codigo_voo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `passagem_voo`
--

CREATE TABLE `passagem_voo` (
  `id_passagem` int NOT NULL AUTO_INCREMENT,
  `id_passageiro` int NOT NULL,
  `id_voo` int NOT NULL,
  `poltrona` varchar(5) NOT NULL,
  PRIMARY KEY (`id_passagem`),
  KEY `fk_passagem_passageiro_idx` (`id_passageiro`),
  KEY `fk_passagem_voo_idx` (`id_voo`),
  CONSTRAINT `fk_passagem_passageiro` FOREIGN KEY (`id_passageiro`) REFERENCES `passageiro` (`id_passageiro`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_passagem_voo` FOREIGN KEY (`id_voo`) REFERENCES `voo` (`id_voo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure for view `aeroporto`
--
DROP TABLE IF EXISTS `aeroporto`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `aeroporto` AS 
SELECT 
  `passageiro`.`id_passageiro` AS `id_passageiro`,
  `passageiro`.`nome` AS `nome`,
  `passageiro`.`passaporte` AS `passaporte`,
  `passageiro`.`cpf` AS `cpf`,
  TIMESTAMPDIFF(YEAR, `passageiro`.`data_nascimento`, CURDATE()) AS `idade`
FROM `passageiro`;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
