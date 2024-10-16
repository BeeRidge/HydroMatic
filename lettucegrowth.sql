-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2024 at 06:23 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lettucegrowth`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `Acc_Id` int(10) NOT NULL,
  `Acc_Fname` varchar(50) NOT NULL,
  `Acc_Lname` varchar(50) NOT NULL,
  `Acc_Pnumber` varchar(50) NOT NULL,
  `Acc_Password` varchar(250) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`Acc_Id`, `Acc_Fname`, `Acc_Lname`, `Acc_Pnumber`, `Acc_Password`, `Date`) VALUES
(6, 'Briggs', 'Reyes', '09362386458', '$2b$10$.552YoqnxIRseBMmqc6QN.9udcQiRtZKG6.Bzk4Rt1Y3kOJHbuthm', '2024-10-15 01:06:33');

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` int(11) NOT NULL,
  `Fname` varchar(50) NOT NULL,
  `Lname` varchar(50) NOT NULL,
  `Pnum` varchar(50) NOT NULL,
  `Activity` varchar(50) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `Fname`, `Lname`, `Pnum`, `Activity`, `Date`) VALUES
(1, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-14 16:04:52'),
(2, 'Briggs', 'Reyes', '09362386458', 'REMOVE HYDRO FRAME', '2024-10-14 16:06:11'),
(3, 'Briggs', 'Reyes', '09362386458', 'ADD HYDRO FRAME', '2024-10-14 16:06:33'),
(4, 'Briggs', 'Reyes', '09362386458', 'REMOVE HYDRO FRAME', '2024-10-14 16:06:51'),
(5, 'Briggs', 'Reyes', '09362386458', 'RECOVER HYDRO FRAME', '2024-10-14 16:07:15'),
(6, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-14 16:09:19'),
(7, 'Brigg', 'Reyes', '09362386458', 'UPDATE FIRST NAME', '2024-10-14 16:09:27'),
(8, 'Brigg', 'Reye', '09362386458', 'UPDATE LAST NAME', '2024-10-14 16:09:40'),
(9, 'Briggs', 'Reye', '09362386458', 'UPDATE FIRST NAME', '2024-10-14 16:09:48'),
(10, 'Briggs', 'Reyes', '09362386458', 'UPDATE LAST NAME', '2024-10-14 16:09:51'),
(11, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-15 00:24:54'),
(12, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-15 01:02:24'),
(13, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-15 01:03:19'),
(14, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-15 01:04:35'),
(15, 'Joshua', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-15 01:05:47'),
(16, 'Briggs', 'Reyes', '09362386458', 'UPDATE FIRST NAME', '2024-10-15 01:06:04'),
(17, 'Joshua', 'Reyes', '09362386458', 'UPDATE FIRST NAME', '2024-10-15 01:06:24'),
(18, 'Briggs', 'Reyes', '09362386458', 'UPDATE FIRST NAME', '2024-10-15 01:06:33');

-- --------------------------------------------------------

--
-- Table structure for table `archived`
--

CREATE TABLE `archived` (
  `Archive_Id` int(50) NOT NULL,
  `Var_Host` varchar(50) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Start_Day` int(50) NOT NULL,
  `Last_Day` int(50) NOT NULL,
  `Start_Date` date NOT NULL,
  `Harvest_Date` date NOT NULL,
  `Date_Archived` date NOT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `Pnum` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archived`
--

INSERT INTO `archived` (`Archive_Id`, `Var_Host`, `Var_Ip`, `Start_Day`, `Last_Day`, `Start_Date`, `Harvest_Date`, `Date_Archived`, `Status`, `Pnum`) VALUES
(29, 'bed2', '192.168.100.31', 40, 47, '2024-10-07', '2024-11-06', '2024-10-15', 'REMOVED', '09362386458');

-- --------------------------------------------------------

--
-- Table structure for table `bed1`
--

CREATE TABLE `bed1` (
  `Num_Id` int(255) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Var_Temp` varchar(50) NOT NULL,
  `Var_WLvl` varchar(50) NOT NULL,
  `Date_Dev` date NOT NULL,
  `Time_Dev` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bed1`
--

INSERT INTO `bed1` (`Num_Id`, `Var_Ip`, `Var_Temp`, `Var_WLvl`, `Date_Dev`, `Time_Dev`) VALUES
(1, '192.168.100.31', '30.69', 'LOW', '2024-09-26', '12:17:20'),
(2, '192.168.100.31', '30.69', 'LOW', '2024-09-26', '12:17:36'),
(3, '192.168.100.31', '30.69', 'LOW', '2024-09-26', '12:17:51'),
(4, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:24:40'),
(5, '192.168.100.31', '30.69', 'LOW', '2024-09-26', '12:24:56'),
(6, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:36:19'),
(7, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:36:35'),
(8, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:36:51'),
(9, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:37:06'),
(10, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:37:22'),
(11, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:37:37'),
(12, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:37:53'),
(13, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:38:09'),
(14, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:38:24'),
(15, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:38:40'),
(16, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:38:55'),
(17, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:39:11'),
(18, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:39:26'),
(19, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:39:42'),
(20, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:39:58'),
(21, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:40:13'),
(22, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:40:29'),
(23, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:40:44'),
(24, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:41:00'),
(25, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:41:15'),
(26, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:41:31'),
(27, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:41:46'),
(28, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:42:02'),
(29, '192.168.100.31', '30.75', 'LOW', '2024-09-26', '12:42:18'),
(30, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:42:33'),
(31, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:42:49'),
(32, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:43:04'),
(33, '192.168.100.31', '30.81', 'HIGH', '2024-09-26', '12:43:20'),
(34, '192.168.100.31', '30.81', 'LOW', '2024-09-26', '12:43:36'),
(35, '192.168.100.31', '30.88', 'HIGH', '2024-09-26', '12:43:51'),
(36, '192.168.100.31', '30.88', 'LOW', '2024-09-26', '12:44:07'),
(37, '192.168.100.31', '27.44', 'LOW', '2024-10-05', '23:13:53'),
(38, '192.168.100.31', '27.44', 'LOW', '2024-10-05', '23:14:08'),
(39, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:14:24'),
(40, '192.168.100.31', '27.44', 'LOW', '2024-10-05', '23:14:40'),
(41, '192.168.100.31', '27.44', 'LOW', '2024-10-05', '23:14:55'),
(42, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:15:11'),
(43, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:15:27'),
(44, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:15:42'),
(45, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:15:58'),
(46, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:16:14'),
(47, '192.168.100.31', '27.31', 'LOW', '2024-10-05', '23:16:29'),
(48, '192.168.100.31', '27.38', 'LOW', '2024-10-05', '23:16:45'),
(49, '192.168.100.31', '27.31', 'LOW', '2024-10-05', '23:17:00'),
(50, '192.168.100.31', '27.31', 'LOW', '2024-10-05', '23:17:16'),
(51, '192.168.100.31', '27.31', 'LOW', '2024-10-05', '23:17:32'),
(52, '192.168.100.31', '27.25', 'LOW', '2024-10-05', '23:17:48'),
(53, '192.168.100.31', '27.25', 'LOW', '2024-10-05', '23:18:03'),
(54, '192.168.100.31', '27.25', 'LOW', '2024-10-05', '23:18:19'),
(55, '192.168.100.31', '27.19', 'LOW', '2024-10-05', '23:18:34'),
(56, '192.168.100.31', '27.19', 'LOW', '2024-10-05', '23:18:50'),
(57, '192.168.100.31', '27.25', 'LOW', '2024-10-05', '23:19:06'),
(58, '192.168.100.31', '27.19', 'LOW', '2024-10-05', '23:19:21'),
(59, '192.168.100.31', '27.25', 'LOW', '2024-10-05', '23:19:37'),
(60, '192.168.100.31', '27.19', 'LOW', '2024-10-05', '23:19:52'),
(61, '192.168.100.31', '27.13', 'LOW', '2024-10-05', '23:20:08'),
(62, '192.168.100.31', '27.13', 'LOW', '2024-10-05', '23:20:23'),
(63, '192.168.100.31', '27.13', 'LOW', '2024-10-05', '23:20:42'),
(64, '192.168.100.31', '27.13', 'LOW', '2024-10-05', '23:20:58'),
(65, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:21:13'),
(66, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:21:29'),
(67, '192.168.100.31', '27.13', 'LOW', '2024-10-05', '23:21:45'),
(68, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:22:00'),
(69, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:22:16'),
(70, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:22:31'),
(71, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:22:47'),
(72, '192.168.100.31', '27.00', 'LOW', '2024-10-05', '23:23:03'),
(73, '192.168.100.31', '27.00', 'LOW', '2024-10-05', '23:23:18'),
(74, '192.168.100.31', '27.06', 'LOW', '2024-10-05', '23:23:34'),
(75, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:26:08'),
(76, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:26:24'),
(77, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:26:40'),
(78, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:26:55'),
(79, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:27:11'),
(80, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:27:26'),
(81, '192.168.100.31', '26.94', 'LOW', '2024-10-05', '23:27:42'),
(82, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:27:57'),
(83, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:28:13'),
(84, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:28:29'),
(85, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:28:44'),
(86, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:29:00'),
(87, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:29:15'),
(88, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:29:31'),
(89, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:29:46'),
(90, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:30:02'),
(91, '192.168.100.31', '26.88', 'LOW', '2024-10-05', '23:30:18'),
(92, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:30:33'),
(93, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:30:49'),
(94, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:31:04'),
(95, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:31:20'),
(96, '192.168.100.31', '26.75', 'LOW', '2024-10-05', '23:31:35'),
(97, '192.168.100.31', '26.81', 'LOW', '2024-10-05', '23:31:51'),
(98, '192.168.100.31', '26.75', 'LOW', '2024-10-05', '23:32:07'),
(99, '192.168.100.31', '26.75', 'LOW', '2024-10-05', '23:32:22'),
(100, '192.168.100.31', '26.75', 'LOW', '2024-10-05', '23:32:38'),
(101, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:32:57'),
(102, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:33:12'),
(103, '192.168.100.31', '26.75', 'LOW', '2024-10-05', '23:33:28'),
(104, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:33:44'),
(105, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:33:59'),
(106, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:34:15'),
(107, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:34:31'),
(108, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:34:46'),
(109, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:35:02'),
(110, '192.168.100.31', '26.63', 'LOW', '2024-10-05', '23:35:18'),
(111, '192.168.100.31', '26.63', 'LOW', '2024-10-05', '23:35:33'),
(112, '192.168.100.31', '26.63', 'LOW', '2024-10-05', '23:35:49'),
(113, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:36:05'),
(114, '192.168.100.31', '26.69', 'LOW', '2024-10-05', '23:36:21'),
(115, '192.168.100.31', '26.63', 'LOW', '2024-10-05', '23:36:37'),
(116, '192.168.100.31', '26.56', 'LOW', '2024-10-05', '23:36:52'),
(117, '192.168.100.31', '26.56', 'LOW', '2024-10-05', '23:37:08'),
(118, '192.168.100.31', '26.63', 'LOW', '2024-10-05', '23:37:24'),
(119, '192.168.100.31', '26.63', 'LOW', '2024-10-05', '23:37:39'),
(120, '192.168.100.31', '26.56', 'LOW', '2024-10-05', '23:37:55'),
(121, '192.168.100.31', '26.56', 'LOW', '2024-10-05', '23:38:11'),
(122, '192.168.100.31', '26.56', 'LOW', '2024-10-05', '23:38:26'),
(123, '192.168.100.31', '26.56', 'LOW', '2024-10-05', '23:38:42'),
(124, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:55:41'),
(125, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:55:51'),
(126, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:56:02'),
(127, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:56:13'),
(128, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:56:23'),
(129, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:56:34'),
(130, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:56:44'),
(131, '192.168.100.31', '25.8125', 'LOW', '2024-10-06', '00:56:55'),
(132, '192.168.100.31', '25.875', 'LOW', '2024-10-06', '00:57:05'),
(133, '192.168.100.31', '27.625', 'HIGH', '2024-10-06', '00:57:16'),
(134, '192.168.100.31', '30.125', 'HIGH', '2024-10-06', '00:57:26'),
(135, '192.168.100.31', '31.125', 'HIGH', '2024-10-06', '00:57:37'),
(136, '192.168.100.31', '30.9375', 'LOW', '2024-10-06', '16:21:47');

-- --------------------------------------------------------

--
-- Table structure for table `bed2`
--

CREATE TABLE `bed2` (
  `Num_Id` int(255) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Var_Temp` varchar(50) NOT NULL,
  `Var_WLvl` varchar(50) NOT NULL,
  `Date_Dev` date NOT NULL,
  `Time_Dev` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bed2`
--

INSERT INTO `bed2` (`Num_Id`, `Var_Ip`, `Var_Temp`, `Var_WLvl`, `Date_Dev`, `Time_Dev`) VALUES
(1, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:52:05'),
(2, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:52:15'),
(3, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:52:25'),
(4, '192.168.100.31', '31.25', 'HIGH', '2024-10-13', '19:52:36'),
(5, '192.168.100.31', '31.25', 'HIGH', '2024-10-13', '19:52:46'),
(6, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:53:06'),
(7, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:53:16'),
(8, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:53:27'),
(9, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:53:37'),
(10, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:53:48'),
(11, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:53:58'),
(12, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:54:12'),
(13, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:54:22'),
(14, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:03:11'),
(15, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:03:29'),
(16, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:03:39'),
(17, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:03:50'),
(18, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:04:01'),
(19, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:04:11'),
(20, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:04:22'),
(21, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:04:32'),
(22, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:04:42'),
(23, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:04:53'),
(24, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:05:03'),
(25, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:05:14'),
(26, '192.168.100.31', '31.25', 'HIGH', '2024-10-13', '20:05:24'),
(27, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:05:35'),
(28, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:05:45'),
(29, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:05:56'),
(30, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:06:06'),
(31, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:06:17'),
(32, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:06:28'),
(33, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:06:38'),
(34, '192.168.100.31', '31.25', 'HIGH', '2024-10-13', '20:06:49'),
(35, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:06:59'),
(36, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:07:10'),
(37, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:07:20'),
(38, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:07:31'),
(39, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:07:41'),
(40, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:07:52'),
(41, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:08:02'),
(42, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:08:13'),
(43, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:08:23'),
(44, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:08:34'),
(45, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:08:44'),
(46, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:08:55'),
(47, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:09:05'),
(48, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:09:16'),
(49, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:09:26'),
(50, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:09:37'),
(51, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:09:47'),
(52, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:09:58'),
(53, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:10:09'),
(54, '192.168.100.31', '31.25', 'HIGH', '2024-10-13', '20:18:16'),
(55, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:18:27'),
(56, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:18:38');

-- --------------------------------------------------------

--
-- Table structure for table `bed3`
--

CREATE TABLE `bed3` (
  `Num_Id` int(255) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Var_Temp` varchar(50) NOT NULL,
  `Var_WLvl` varchar(50) NOT NULL,
  `Date_Dev` date NOT NULL,
  `Time_Dev` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bed3`
--

INSERT INTO `bed3` (`Num_Id`, `Var_Ip`, `Var_Temp`, `Var_WLvl`, `Date_Dev`, `Time_Dev`) VALUES
(1, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:54:45'),
(2, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:54:55'),
(3, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:55:06'),
(4, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:55:16'),
(5, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:55:27'),
(6, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:55:37'),
(7, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:55:48'),
(8, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:55:58'),
(9, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:56:09'),
(10, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:56:19'),
(11, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:56:30'),
(12, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:56:40'),
(13, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:56:51'),
(14, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:57:01'),
(15, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:57:12'),
(16, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:57:22'),
(17, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:57:33'),
(18, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:57:43'),
(19, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:57:54'),
(20, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:58:04'),
(21, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:58:14'),
(22, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:58:25'),
(23, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:58:35'),
(24, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:58:46'),
(25, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:58:56'),
(26, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:59:07'),
(27, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:59:18'),
(28, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '19:59:28'),
(29, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:59:39'),
(30, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '19:59:52'),
(31, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:00:02'),
(32, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:00:13'),
(33, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:00:23'),
(34, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:00:34'),
(35, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:00:44'),
(36, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:00:55'),
(37, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:01:05'),
(38, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:01:16'),
(39, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:01:26'),
(40, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:01:37'),
(41, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:01:47'),
(42, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:01:58'),
(43, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:02:09'),
(44, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:02:19'),
(45, '192.168.100.31', '31.125', 'HIGH', '2024-10-13', '20:02:29'),
(46, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:02:40'),
(47, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:02:50'),
(48, '192.168.100.31', '31.1875', 'HIGH', '2024-10-13', '20:03:01');

-- --------------------------------------------------------

--
-- Table structure for table `device_info`
--

CREATE TABLE `device_info` (
  `Int_Id` int(50) NOT NULL,
  `Fname` varchar(50) NOT NULL,
  `Lname` varchar(50) NOT NULL,
  `Pnum` varchar(50) NOT NULL,
  `Var_Host` varchar(50) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_info`
--

INSERT INTO `device_info` (`Int_Id`, `Fname`, `Lname`, `Pnum`, `Var_Host`, `Var_Ip`, `Status`) VALUES
(3, 'Briggs', 'Reyes', '09362386458', 'bed2', '192.168.100.31', 'INACTIVE');

-- --------------------------------------------------------

--
-- Table structure for table `display_bed`
--

CREATE TABLE `display_bed` (
  `Bed_Id` int(50) NOT NULL,
  `Var_Host` varchar(50) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Start_Day` int(50) NOT NULL,
  `Last_Day` int(50) NOT NULL,
  `Start_Date` date NOT NULL,
  `Harvest_Date` date NOT NULL,
  `Update_Date` date DEFAULT NULL,
  `Last_SMS_Date` date DEFAULT NULL,
  `Status` varchar(50) NOT NULL,
  `Pnum` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `display_bed`
--

INSERT INTO `display_bed` (`Bed_Id`, `Var_Host`, `Var_Ip`, `Start_Day`, `Last_Day`, `Start_Date`, `Harvest_Date`, `Update_Date`, `Last_SMS_Date`, `Status`, `Pnum`) VALUES
(61, 'bed2', '192.168.100.31', 10, 24, '2024-10-01', '2024-11-30', '2024-10-15', NULL, 'ONGOING', '09362386458');

-- --------------------------------------------------------

--
-- Table structure for table `growthtimeline`
--

CREATE TABLE `growthtimeline` (
  `id` int(11) NOT NULL,
  `phase_name` varchar(50) NOT NULL,
  `start_day` int(11) NOT NULL,
  `end_day` int(11) NOT NULL,
  `description` text NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `image` blob DEFAULT NULL,
  `image_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `growthtimeline`
--

INSERT INTO `growthtimeline` (`id`, `phase_name`, `start_day`, `end_day`, `description`, `image_path`, `image`, `image_name`) VALUES
(1, 'Germination', 0, 7, 'Seeds begin to sprout. You may see the first signs of seedlings emerging from the soil.', 'img/lettuce2.png', NULL, 'image 2'),
(2, 'Seedling', 7, 14, 'Small, delicate leaves start to form. The plant is in its most vulnerable stage and requires careful watering and light.', 'img/lettuce3.png', NULL, 'image 3'),
(3, 'Early Vegetative', 15, 30, 'The plant begins to develop more leaves and starts to grow rapidly. It’s crucial to ensure the plant has enough nutrients and water.', 'img/lettuce4.png', NULL, 'image 4'),
(4, 'Late Vegetative', 31, 45, 'The lettuce continues to grow in size. Leaves become fuller and larger, and the plant is nearing its mature size.', 'img/lettuce5.png', NULL, 'image 5'),
(5, 'Heading', 46, 60, 'For varieties that form heads (like iceberg lettuce), the inner leaves start to curl inward, forming a head. Loose-leaf varieties will have a rosette shape.', 'img/lettuce6.png', NULL, 'image 6'),
(6, 'Maturity', 61, 70, 'The lettuce is fully grown and ready for harvest. The leaves should be crisp and tender.', 'img/lettuce7.png', NULL, 'image 7');

-- --------------------------------------------------------

--
-- Table structure for table `pagecontent`
--

CREATE TABLE `pagecontent` (
  `Id` int(11) NOT NULL,
  `sectionId` varchar(50) NOT NULL,
  `tagId` varchar(50) NOT NULL,
  `tagContent` text NOT NULL,
  `lastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pagecontent`
--

INSERT INTO `pagecontent` (`Id`, `sectionId`, `tagId`, `tagContent`, `lastUpdated`) VALUES
(1, 'Hero', 'heading1', 'Monitor Remotely with <br>           \n<span class=\"text1\">HYDROMATIC</span>', '2024-10-14 15:29:26'),
(2, 'Hero', 'heading2', 'Grow Lettuce with <br>\n<span class=\"text1\">HYDROMATIC</span>', '2024-10-14 15:22:13'),
(3, 'Hero', 'heading3', 'Sample Dashboard of <br>\n<span class=\"text1\">HYDROMATIC</span> Site.', '2024-10-14 15:22:13'),
(4, 'Hero', 'Textheading', '\"Comprehensive Monitoring Solution for Kratky Hydroponics Farms. Leveraging IoT, our system integrates <mark>water-level sensors</mark>, <mark>water temperature sensors</mark>, and <mark>air pumps</mark> to optimize and sustain your hydroponic system.\"', '2024-10-14 11:54:59'),
(5, 'Features', 'featTitle', 'Key Features', '2024-10-14 13:55:00'),
(6, 'Features', 'realTime', '<mark>Real-Time Monitoring</mark>', '2024-10-14 13:55:00'),
(7, 'Features', 'realTimeText', 'Monitor your hydroponic system\'s status in real-time fromanywhere.', '2024-10-14 15:22:54'),
(8, 'Features', 'sms', '<mark>SMS Notification</mark>', '2024-10-14 13:55:00'),
(9, 'Features', 'smsText', 'Receive instant SMS notifications about your system’s status.', '2024-10-14 13:55:00'),
(10, 'Features', 'IoT', '<mark>IoT Integrated</mark>', '2024-10-14 13:55:00'),
(11, 'Features', 'IoTText', 'Seamlessly integrate IoT devices for automated monitoring.', '2024-10-14 13:55:00'),
(12, 'aboutHydro', 'HydroTitle', 'What is <span class=\"text1\">HydroMatic</span> all about?', '2024-10-14 14:01:50'),
(13, 'aboutHydro', 'HydroText', 'The HydroMatic is a smart system designed for easy management of hydroponic setups. It monitors water levels and temperature to ensure optimal conditions for plant growth, while the air pump keeps roots oxygenated. With built-in Wi-Fi, you can control and check the system remotely, and its design allows for easy upgrades. The device also automates tasks like turning the air pump on and off, making it a hassle-free way to maintain a healthy hydroponic environment.', '2024-10-14 14:01:50'),
(14, 'Steps', 'stepsTitle', 'How can I set up <span class=\"text1\">HydroMatic</span> with WiFi?', '2024-10-14 14:06:28'),
(15, 'aboutUs', 'aboutHead', 'About Us', '2024-10-14 14:14:28'),
(16, 'aboutUs', 'aboutHeadText', 'We are a passionate team dedicated to innovating and revolutionizing the hydroponic industry.', '2024-10-14 14:14:28'),
(17, 'aboutUs', 'mission', 'Our Mission', '2024-10-14 14:17:41'),
(18, 'aboutUs', 'missionText1', 'At HydroMatic, our mission is to make sustainable farming accessible to everyone through cutting-edge technology. We aim to empower farmers, hobbyists, and businesses with the tools they need to grow plants efficiently and sustainably.', '2024-10-14 14:17:41'),
(19, 'aboutUs', 'missionText2', 'Our team of experts brings together a wealth of experience in agriculture, engineering, and technology to deliver innovative hydroponic solutions. We believe in the power of hydroponics to transform the future of farming and are committed to making this vision a reality.', '2024-10-14 14:17:41'),
(20, 'faq', 'faqTitle', 'Frequently Asked Questions', '2024-10-14 14:25:42'),
(21, 'faq', 'faqDesc', 'Answers to your common queries about HydroMatic.', '2024-10-14 14:25:42'),
(22, 'faq', 'faqItem1', 'What is HydroMatic?', '2024-10-14 14:25:42'),
(23, 'faq', 'answer1', 'HydroMatic is a web-based monitoring system designed for hydroponics farming, utilizing IoT devices to optimize plant growth.', '2024-10-14 14:25:42'),
(24, 'faq', 'faqItem2', 'How does HydroMatic work?', '2024-10-14 14:25:42'),
(25, 'faq', 'answer2', 'HydroMatic works by collecting data from various sensors to monitor environmental conditions, allowing users to make informed decisions about their plants.', '2024-10-14 14:25:42'),
(26, 'faq', 'faqItem3', 'What sensors are included?', '2024-10-14 14:25:42'),
(27, 'faq', 'answer3', 'The system includes temperature sensors, humidity sensors, and water level sensors to provide comprehensive monitoring.', '2024-10-14 14:25:42'),
(28, 'faq', 'faqItem4', 'How can I get support?', '2024-10-14 14:25:42'),
(29, 'faq', 'answer4', 'You can reach out to our support team via email or through our website\'s contact form for assistance.', '2024-10-14 14:25:42'),
(30, 'faq', 'faqItem5', 'Is HydroMatic easy to set up?', '2024-10-14 14:25:42'),
(31, 'faq', 'answer5', 'Yes, HydroMatic is designed for easy setup, with detailed instructions provided for each component.', '2024-10-14 14:25:42');

-- --------------------------------------------------------

--
-- Table structure for table `pageimage`
--

CREATE TABLE `pageimage` (
  `id` int(11) NOT NULL,
  `sectionId` varchar(50) NOT NULL,
  `imageId` varchar(50) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `src` varchar(255) NOT NULL,
  `lastUpdated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pageimage`
--

INSERT INTO `pageimage` (`id`, `sectionId`, `imageId`, `filename`, `src`, `lastUpdated`) VALUES
(1, 'Hero', 'sampleDevice', 'deviceframes2.png', 'img/deviceframes2.png', '2024-10-14 13:46:20'),
(2, 'aboutHydro', 'hydroImg', 'How.png', 'img/How.png', '2024-10-14 15:08:30'),
(3, 'Steps', 'stepsImg1', 'step1.jpg', 'img/step1.jpg', '2024-10-14 14:30:18'),
(4, 'Steps', 'stepsImg2', 'step3.jpg', 'img/step3.jpg', '2024-10-14 14:30:23'),
(5, 'Steps', 'stepsImg3', 'step4.jpg', 'img/step4.jpg', '2024-10-14 14:30:28'),
(6, 'Steps', 'stepsImg4', 'step5.jpg', 'img/step5.jpg', '2024-10-14 14:30:34'),
(7, 'aboutUs', 'aboutImg', 'lett.jpg', 'img/lett.jpg', '2024-10-14 14:30:38');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`Acc_Id`);

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `archived`
--
ALTER TABLE `archived`
  ADD PRIMARY KEY (`Archive_Id`);

--
-- Indexes for table `bed1`
--
ALTER TABLE `bed1`
  ADD PRIMARY KEY (`Num_Id`);

--
-- Indexes for table `bed2`
--
ALTER TABLE `bed2`
  ADD PRIMARY KEY (`Num_Id`);

--
-- Indexes for table `bed3`
--
ALTER TABLE `bed3`
  ADD PRIMARY KEY (`Num_Id`);

--
-- Indexes for table `device_info`
--
ALTER TABLE `device_info`
  ADD PRIMARY KEY (`Int_Id`);

--
-- Indexes for table `display_bed`
--
ALTER TABLE `display_bed`
  ADD PRIMARY KEY (`Bed_Id`);

--
-- Indexes for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pagecontent`
--
ALTER TABLE `pagecontent`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `pageimage`
--
ALTER TABLE `pageimage`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `Acc_Id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `archived`
--
ALTER TABLE `archived`
  MODIFY `Archive_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `bed1`
--
ALTER TABLE `bed1`
  MODIFY `Num_Id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `bed2`
--
ALTER TABLE `bed2`
  MODIFY `Num_Id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `bed3`
--
ALTER TABLE `bed3`
  MODIFY `Num_Id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `device_info`
--
ALTER TABLE `device_info`
  MODIFY `Int_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `display_bed`
--
ALTER TABLE `display_bed`
  MODIFY `Bed_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pagecontent`
--
ALTER TABLE `pagecontent`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `pageimage`
--
ALTER TABLE `pageimage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `device_info`
--
ALTER TABLE `device_info`
  ADD CONSTRAINT `device_info_ibfk_1` FOREIGN KEY (`Pnum`) REFERENCES `account` (`Acc_Pnumber`);

--
-- Constraints for table `display_bed`
--
ALTER TABLE `display_bed`
  ADD CONSTRAINT `display_bed_ibfk_1` FOREIGN KEY (`Pnum`) REFERENCES `account` (`Acc_Pnumber`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
