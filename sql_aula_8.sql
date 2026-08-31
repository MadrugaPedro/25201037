-- phpMyAdmin SQL Dump
-- version 5.2.3
-- Database: `aeroporto`

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `aeroporto` (
);

CREATE TABLE `table1` (
  `idtable` int NOT NULL,
  `table1col` varchar(45) NOT NULL,
  `table1col1` varchar(45) NOT NULL,
  `table1col2` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Table2` (
  `idtable2` int NOT NULL,
  `tablecol` varchar(45) NOT NULL,
  `tablecol1` varchar(45) NOT NULL,
  `tablecol2` varchar(45) NOT NULL,
  `tablecol3` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `aeroporto`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `aeroporto`  AS SELECT `table1`.`id_passageiro` AS `id_passageiro`, `table1`.`nome` AS `nome`, `table1`.`passaporte` AS `passaporte`, `table1`.`cpf` AS `cpf`, `table1`.`idade` AS `idade` FROM `table1` ;
COMMIT;
