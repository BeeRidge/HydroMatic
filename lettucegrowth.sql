-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 12, 2024 at 03:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
  `Acc_Password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`Acc_Id`, `Acc_Fname`, `Acc_Lname`, `Acc_Pnumber`, `Acc_Password`) VALUES
(2, '', '', '09763120382', 'KurtPablo'),
(4, '', '', '09362386458', 'BriggsReyes'),
(5, '', '', '09352544614', 'Password');

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
(21, 'bed1', '192.168.100.31', 10, 70, '2024-09-17', '2024-11-16', '2024-10-06', 'FINISHED', '');

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
(1, '', '', '', 'bed1', '192.168.100.31', '');

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
  `Pnum` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `pageId` varchar(50) NOT NULL,
  `pageContent1` text NOT NULL,
  `pageContent2` text NOT NULL,
  `pageContent3` text NOT NULL,
  `pageContent4` text NOT NULL,
  `pageContent5` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `page_images`
--

CREATE TABLE `page_images` (
  `id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `section_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `page_images`
--

INSERT INTO `page_images` (`id`, `filename`, `url`, `created`, `section_id`) VALUES
(11, 'board.jpg', 'img/board.jpg', '2024-09-15 23:25:15', 3),
(12, 'sensor.jpg', 'img/sensor.jpg', '2024-09-15 23:25:15', 3),
(14, 'BRIGGS.jpg', 'img/BRIGGS.jpg', '2024-09-15 23:25:15', 5),
(15, 'deviceframes.png', '/img/deviceframes.png', '2024-09-15 23:25:15', 1),
(16, 'JEAN.jpg', 'img/JEAN.jpg', '2024-09-15 23:25:15', 5),
(17, 'KURT.jpg', 'img/KURT.jpg', '2024-09-15 23:25:15', 5),
(18, 'lett.jpg', 'img/lett.jpg', '2024-09-15 23:25:15', 5),
(19, 'relay.jpg', 'img/relay.jpg', '2024-09-15 23:25:15', 3),
(20, 'SHEIK.jpg', 'img/SHEIK.jpg', '2024-09-15 23:25:15', 5),
(26, 'water-level.jpg', '/img/water-level.jpg', '2024-09-15 23:25:15', 3),
(27, 'water-temp.jpg', 'img/water-temp.jpg', '2024-09-15 23:25:15', 3),
(28, 'wifi.jpg', 'img/wifi.jpg', '2024-09-15 23:25:15', 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`Acc_Id`),
  ADD UNIQUE KEY `Acc_Pnumber` (`Acc_Pnumber`);

--
-- Indexes for table `archived`
--
ALTER TABLE `archived`
  ADD PRIMARY KEY (`Archive_Id`),
  ADD UNIQUE KEY `Pnum` (`Pnum`);

--
-- Indexes for table `bed1`
--
ALTER TABLE `bed1`
  ADD PRIMARY KEY (`Num_Id`);

--
-- Indexes for table `device_info`
--
ALTER TABLE `device_info`
  ADD PRIMARY KEY (`Int_Id`),
  ADD UNIQUE KEY `Pnum` (`Pnum`);

--
-- Indexes for table `display_bed`
--
ALTER TABLE `display_bed`
  ADD PRIMARY KEY (`Bed_Id`),
  ADD UNIQUE KEY `Pnum` (`Pnum`);

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
-- Indexes for table `page_images`
--
ALTER TABLE `page_images`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `Acc_Id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `archived`
--
ALTER TABLE `archived`
  MODIFY `Archive_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `bed1`
--
ALTER TABLE `bed1`
  MODIFY `Num_Id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `device_info`
--
ALTER TABLE `device_info`
  MODIFY `Int_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `display_bed`
--
ALTER TABLE `display_bed`
  MODIFY `Bed_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pagecontent`
--
ALTER TABLE `pagecontent`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
