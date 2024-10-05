-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 29, 2024 at 02:43 AM
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
-- Table structure for table `bed1`
--

CREATE TABLE `bed1` (
  `id` int(255) NOT NULL,
  `temperature` float NOT NULL,
  `water_level` varchar(10) NOT NULL,
  `D_Date` date NOT NULL,
  `T_Time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bed1`
--

INSERT INTO `bed1` (`id`, `temperature`, `water_level`, `D_Date`, `T_Time`) VALUES
(1, 25.19, 'LOW', '2024-08-28', '19:38:52'),
(2, 25.13, 'LOW', '2024-08-28', '19:39:08'),
(3, 25.19, 'LOW', '2024-08-28', '19:39:24'),
(4, 25.19, 'LOW', '2024-08-28', '19:39:39'),
(5, 25.13, 'LOW', '2024-08-28', '19:39:55'),
(6, 25.06, 'LOW', '2024-08-28', '19:40:10'),
(7, 25.06, 'LOW', '2024-08-28', '19:40:26'),
(8, 25.06, 'LOW', '2024-08-28', '19:40:41'),
(9, 25.06, 'LOW', '2024-08-28', '19:40:57'),
(10, 25, 'LOW', '2024-08-28', '19:41:13'),
(11, 24.88, 'LOW', '2024-08-28', '19:43:05'),
(12, 24.81, 'LOW', '2024-08-28', '19:43:21'),
(13, 24.81, 'LOW', '2024-08-28', '19:43:36'),
(14, 24.81, 'LOW', '2024-08-28', '19:43:52'),
(15, 24.75, 'LOW', '2024-08-28', '19:44:07'),
(16, 24.75, 'LOW', '2024-08-28', '19:44:23'),
(17, 24.75, 'LOW', '2024-08-28', '19:44:38'),
(18, 24.69, 'LOW', '2024-08-28', '19:44:54'),
(19, 24.81, 'LOW', '2024-08-28', '19:45:10'),
(20, 24.81, 'LOW', '2024-08-28', '19:45:25'),
(21, 24.75, 'LOW', '2024-08-28', '19:45:41'),
(22, 24.75, 'LOW', '2024-08-28', '19:45:56'),
(23, 24.69, 'LOW', '2024-08-28', '19:46:12'),
(24, 24.63, 'LOW', '2024-08-28', '19:46:28'),
(25, 24.63, 'LOW', '2024-08-28', '19:46:43'),
(26, 24.56, 'LOW', '2024-08-28', '19:46:59'),
(27, 24.5, 'LOW', '2024-08-28', '19:47:14'),
(28, 24.5, 'LOW', '2024-08-28', '19:47:30'),
(29, 24.5, 'LOW', '2024-08-28', '19:48:00'),
(30, 24.38, 'LOW', '2024-08-28', '19:51:21'),
(31, 24.38, 'LOW', '2024-08-28', '19:51:36'),
(32, 24.38, 'LOW', '2024-08-28', '19:51:52'),
(33, 24.38, 'LOW', '2024-08-28', '19:52:07'),
(34, 24.38, 'LOW', '2024-08-28', '19:52:23'),
(35, 24.44, 'LOW', '2024-08-28', '19:52:39'),
(36, 24.44, 'LOW', '2024-08-28', '19:52:54'),
(37, 24.38, 'LOW', '2024-08-28', '19:53:10'),
(38, 24.38, 'LOW', '2024-08-28', '19:53:25'),
(39, 24.38, 'LOW', '2024-08-28', '19:53:41'),
(40, 24.38, 'LOW', '2024-08-28', '19:53:56'),
(41, 24.38, 'LOW', '2024-08-28', '19:54:12'),
(42, 24.38, 'LOW', '2024-08-28', '19:54:28'),
(43, 24.44, 'LOW', '2024-08-28', '19:54:43'),
(44, 24.31, 'LOW', '2024-08-28', '19:54:59'),
(45, 24.31, 'LOW', '2024-08-28', '19:55:14'),
(46, 24.31, 'LOW', '2024-08-28', '19:55:30'),
(47, 24.25, 'LOW', '2024-08-28', '19:55:45'),
(48, 24.25, 'LOW', '2024-08-28', '19:56:01'),
(49, 24.19, 'LOW', '2024-08-28', '19:56:17'),
(50, 24.19, 'LOW', '2024-08-28', '19:56:32'),
(51, 24.06, 'LOW', '2024-08-28', '19:56:48'),
(52, 24.13, 'LOW', '2024-08-28', '19:57:03'),
(53, 24.19, 'LOW', '2024-08-28', '19:57:19'),
(54, 24.13, 'LOW', '2024-08-28', '19:57:34'),
(55, 24.06, 'LOW', '2024-08-28', '19:57:50'),
(56, 24.06, 'LOW', '2024-08-28', '19:58:06'),
(57, 24.06, 'LOW', '2024-08-28', '19:58:21'),
(58, 24, 'LOW', '2024-08-28', '19:58:37'),
(59, 24, 'LOW', '2024-08-28', '19:58:52'),
(60, 24, 'LOW', '2024-08-28', '19:59:08'),
(61, 23.94, 'LOW', '2024-08-28', '19:59:23'),
(62, 23.94, 'LOW', '2024-08-28', '19:59:39'),
(63, 23.88, 'LOW', '2024-08-28', '19:59:55'),
(64, 23.88, 'LOW', '2024-08-28', '20:00:10'),
(65, 23.81, 'LOW', '2024-08-28', '20:00:26'),
(66, 23.81, 'LOW', '2024-08-28', '20:00:41'),
(67, 23.94, 'LOW', '2024-08-28', '20:00:57'),
(68, 23.94, 'LOW', '2024-08-28', '20:01:12'),
(69, 23.88, 'LOW', '2024-08-28', '20:01:28'),
(70, 23.94, 'LOW', '2024-08-28', '20:01:44'),
(71, 23.88, 'LOW', '2024-08-28', '20:01:59'),
(72, 23.94, 'LOW', '2024-08-28', '20:02:15'),
(73, 28.88, 'LOW', '2024-08-29', '07:26:58'),
(74, 28.88, 'LOW', '2024-08-29', '07:27:14'),
(75, 28.88, 'LOW', '2024-08-29', '07:27:29'),
(76, 28.88, 'LOW', '2024-08-29', '07:27:45'),
(77, 28.88, 'LOW', '2024-08-29', '07:28:00'),
(78, 28.94, 'LOW', '2024-08-29', '07:28:16'),
(79, 28.94, 'LOW', '2024-08-29', '07:28:31'),
(80, 28.94, 'LOW', '2024-08-29', '07:28:47'),
(81, 28.88, 'LOW', '2024-08-29', '07:29:03'),
(82, 28.94, 'LOW', '2024-08-29', '07:29:18'),
(83, 29, 'LOW', '2024-08-29', '07:29:34'),
(84, 29, 'LOW', '2024-08-29', '07:29:49'),
(85, 28.94, 'LOW', '2024-08-29', '07:30:05'),
(86, 28.94, 'LOW', '2024-08-29', '07:30:21'),
(87, 28.94, 'LOW', '2024-08-29', '07:30:36'),
(88, 29, 'LOW', '2024-08-29', '07:30:52'),
(89, 29, 'LOW', '2024-08-29', '07:31:07'),
(90, 29, 'LOW', '2024-08-29', '07:31:23'),
(91, 29.06, 'LOW', '2024-08-29', '07:31:38'),
(92, 29.06, 'LOW', '2024-08-29', '07:31:54'),
(93, 29, 'LOW', '2024-08-29', '07:32:10'),
(94, 29.06, 'LOW', '2024-08-29', '07:32:25'),
(95, 29, 'LOW', '2024-08-29', '07:32:41'),
(96, 29.06, 'LOW', '2024-08-29', '07:32:56'),
(97, 29.06, 'LOW', '2024-08-29', '07:33:12'),
(98, 29.06, 'LOW', '2024-08-29', '07:33:27'),
(99, 29.13, 'LOW', '2024-08-29', '07:33:43'),
(100, 29.06, 'LOW', '2024-08-29', '07:33:59'),
(101, 29.06, 'LOW', '2024-08-29', '07:34:14'),
(102, 29.06, 'LOW', '2024-08-29', '07:34:30'),
(103, 29.13, 'LOW', '2024-08-29', '07:34:45'),
(104, 29.13, 'LOW', '2024-08-29', '07:35:01'),
(105, 29.13, 'LOW', '2024-08-29', '07:35:16'),
(106, 29.13, 'LOW', '2024-08-29', '07:35:32'),
(107, 29.13, 'LOW', '2024-08-29', '07:35:48'),
(108, 29.13, 'LOW', '2024-08-29', '07:36:03'),
(109, 29.13, 'LOW', '2024-08-29', '07:36:19'),
(110, 29.19, 'LOW', '2024-08-29', '07:36:34'),
(111, 29.13, 'LOW', '2024-08-29', '07:36:50'),
(112, 29.19, 'LOW', '2024-08-29', '07:37:05'),
(113, 29.25, 'LOW', '2024-08-29', '07:37:21'),
(114, 29.25, 'LOW', '2024-08-29', '07:37:37'),
(115, 29.19, 'LOW', '2024-08-29', '07:37:52'),
(116, 29.25, 'LOW', '2024-08-29', '07:38:08'),
(117, 29.31, 'LOW', '2024-08-29', '07:38:23'),
(118, 29.25, 'LOW', '2024-08-29', '07:38:39'),
(119, 29.31, 'LOW', '2024-08-29', '07:38:54'),
(120, 29.31, 'LOW', '2024-08-29', '07:39:10'),
(121, 29.31, 'LOW', '2024-08-29', '07:39:26'),
(122, 29.31, 'LOW', '2024-08-29', '07:39:41'),
(123, 29.31, 'LOW', '2024-08-29', '07:39:57'),
(124, 29.31, 'LOW', '2024-08-29', '07:40:12'),
(125, 29.38, 'LOW', '2024-08-29', '07:40:28'),
(126, 29.38, 'LOW', '2024-08-29', '07:40:43'),
(127, 29.38, 'LOW', '2024-08-29', '07:40:59'),
(128, 29.38, 'LOW', '2024-08-29', '07:41:15'),
(129, 29.38, 'LOW', '2024-08-29', '07:41:30'),
(130, 29.38, 'LOW', '2024-08-29', '07:41:46'),
(131, 29.38, 'LOW', '2024-08-29', '07:42:01'),
(132, 29.38, 'LOW', '2024-08-29', '07:42:18'),
(133, 29.44, 'LOW', '2024-08-29', '07:42:34'),
(134, 29.44, 'LOW', '2024-08-29', '07:42:50'),
(135, 29.44, 'LOW', '2024-08-29', '07:43:05'),
(136, 29.44, 'LOW', '2024-08-29', '07:43:21'),
(137, 29.44, 'LOW', '2024-08-29', '07:43:37'),
(138, 29.5, 'LOW', '2024-08-29', '07:43:52'),
(139, 29.44, 'LOW', '2024-08-29', '07:44:08'),
(140, 29.44, 'LOW', '2024-08-29', '07:44:23'),
(141, 29.5, 'LOW', '2024-08-29', '07:44:39'),
(142, 29.44, 'LOW', '2024-08-29', '07:44:54'),
(143, 29.5, 'LOW', '2024-08-29', '07:45:10'),
(144, 29.5, 'LOW', '2024-08-29', '07:45:26'),
(145, 29.5, 'LOW', '2024-08-29', '07:45:41'),
(146, 29.5, 'LOW', '2024-08-29', '07:45:57'),
(147, 29.5, 'LOW', '2024-08-29', '07:46:12'),
(148, 29.5, 'LOW', '2024-08-29', '07:46:28'),
(149, 29.56, 'LOW', '2024-08-29', '07:46:43'),
(150, 29.56, 'LOW', '2024-08-29', '07:46:59'),
(151, 29.63, 'LOW', '2024-08-29', '07:47:15'),
(152, 29.56, 'LOW', '2024-08-29', '07:47:30'),
(153, 29.56, 'LOW', '2024-08-29', '07:47:46'),
(154, 29.63, 'LOW', '2024-08-29', '07:48:01'),
(155, 29.56, 'LOW', '2024-08-29', '07:48:17'),
(156, 29.63, 'LOW', '2024-08-29', '07:48:32'),
(157, 29.63, 'LOW', '2024-08-29', '07:48:48'),
(158, 29.63, 'LOW', '2024-08-29', '07:49:04'),
(159, 29.63, 'LOW', '2024-08-29', '07:49:19'),
(160, 29.63, 'LOW', '2024-08-29', '07:49:35'),
(161, 29.63, 'LOW', '2024-08-29', '07:49:50'),
(162, 29.69, 'LOW', '2024-08-29', '07:50:06'),
(163, 29.69, 'LOW', '2024-08-29', '07:50:22'),
(164, 29.75, 'LOW', '2024-08-29', '07:50:37'),
(165, 29.63, 'LOW', '2024-08-29', '07:50:53'),
(166, 29.69, 'LOW', '2024-08-29', '07:51:08'),
(167, 29.69, 'LOW', '2024-08-29', '07:51:24'),
(168, 29.69, 'LOW', '2024-08-29', '07:51:39'),
(169, 29.69, 'LOW', '2024-08-29', '07:51:55'),
(170, 29.63, 'LOW', '2024-08-29', '07:52:11'),
(171, 29.69, 'LOW', '2024-08-29', '07:52:26'),
(172, 29.69, 'LOW', '2024-08-29', '07:52:42'),
(173, 29.69, 'LOW', '2024-08-29', '07:52:57'),
(174, 29.75, 'LOW', '2024-08-29', '07:53:13'),
(175, 29.75, 'LOW', '2024-08-29', '07:53:28'),
(176, 29.75, 'LOW', '2024-08-29', '07:53:44'),
(177, 29.69, 'LOW', '2024-08-29', '07:54:00'),
(178, 29.69, 'LOW', '2024-08-29', '07:54:15'),
(179, 29.69, 'LOW', '2024-08-29', '07:54:31'),
(180, 29.69, 'LOW', '2024-08-29', '07:54:46'),
(181, 29.75, 'LOW', '2024-08-29', '07:55:02'),
(182, 29.75, 'LOW', '2024-08-29', '07:55:18'),
(183, 29.75, 'LOW', '2024-08-29', '07:55:34'),
(184, 29.69, 'LOW', '2024-08-29', '07:55:49'),
(185, 29.75, 'LOW', '2024-08-29', '07:56:05'),
(186, 29.69, 'LOW', '2024-08-29', '07:56:20');

-- --------------------------------------------------------

--
-- Table structure for table `bed_number`
--

CREATE TABLE `bed_number` (
  `id` int(11) NOT NULL,
  `V_Hostname` varchar(50) NOT NULL,
  `V_IpAddress` varchar(50) NOT NULL,
  `I_NumberofDays` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bed_number`
--

INSERT INTO `bed_number` (`id`, `V_Hostname`, `V_IpAddress`, `I_NumberofDays`) VALUES
(1, 'bed1', '192.168.1.224', 10);

-- --------------------------------------------------------

--
-- Table structure for table `device_info`
--

CREATE TABLE `device_info` (
  `id` int(50) NOT NULL,
  `V_Name` varchar(50) NOT NULL,
  `V_IpAddress` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_info`
--

INSERT INTO `device_info` (`id`, `V_Name`, `V_IpAddress`) VALUES
(1, 'bed1', '192.168.1.224'),
(2, 'Bed1', '192.168.1.224');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `event_title` varchar(255) NOT NULL,
  `event_date` date NOT NULL,
  `event_theme` varchar(50) NOT NULL
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
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `phase_name` varchar(255) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `image` blob DEFAULT NULL,
  `image_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`phase_name`, `image_path`, `image`, `image_name`) VALUES
('Early Vegetative', 'dist/img/lettuce4.jpg', NULL, 'Image 4'),
('Germination', 'dist/img/lettuce2.jpg', NULL, 'Image 2'),
('Heading', 'dist/img/lettuce6.jpg', NULL, 'Image 6'),
('Late Vegetative', 'dist/img/lettuce5.jpg', NULL, 'Image 5'),
('Maturity', 'dist/img/lettuce7.jpg', NULL, 'Image 7'),
('Seedling', 'dist/img/lettuce3.jpg', NULL, 'Image 3');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bed1`
--
ALTER TABLE `bed1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bed_number`
--
ALTER TABLE `bed_number`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `device_info`
--
ALTER TABLE `device_info`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`phase_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bed1`
--
ALTER TABLE `bed1`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=187;

--
-- AUTO_INCREMENT for table `bed_number`
--
ALTER TABLE `bed_number`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `device_info`
--
ALTER TABLE `device_info`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
