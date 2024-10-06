-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 07, 2024 at 01:49 AM
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
  `Acc_Pnumber` varchar(50) NOT NULL,
  `Acc_Password` varchar(50) NOT NULL,
  `Acc_OTP` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`Acc_Id`, `Acc_Pnumber`, `Acc_Password`, `Acc_OTP`) VALUES
(2, '09763120382', 'KurtPablo', '579022'),
(4, '09362386458', 'BriggsReyes', '245270'),
(5, '09352544614', 'Password', '444260');

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
  `Status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `archived`
--

INSERT INTO `archived` (`Archive_Id`, `Var_Host`, `Var_Ip`, `Start_Day`, `Last_Day`, `Start_Date`, `Harvest_Date`, `Date_Archived`, `Status`) VALUES
(21, 'bed1', '192.168.100.31', 10, 70, '2024-09-17', '2024-11-16', '2024-10-06', 'FINISHED');

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
  `Var_Host` varchar(50) NOT NULL,
  `Var_Ip` varchar(50) NOT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_info`
--

INSERT INTO `device_info` (`Int_Id`, `Var_Host`, `Var_Ip`, `Status`) VALUES
(1, 'bed1', '192.168.100.31', '');

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
  `Last_SMS_Date` date DEFAULT NULL
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
-- Table structure for table `page_content`
--

CREATE TABLE `page_content` (
  `section_id` int(11) NOT NULL,
  `section_name` varchar(255) NOT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `page_content`
--

INSERT INTO `page_content` (`section_id`, `section_name`, `content`) VALUES
(1, 'Home', '<section class=\"bg-c py-48 px-10 w-full h-auto\">\n        <div class=\"container mx-auto flex flex-col md:flex-row items-center\">\n            <div id=\"headings-container\" class=\" space-y-6 text-center md:text-left\">\n                <h1 id=\"heading1\" class=\"fade-slide-in text-5xl font-bold text-gray-800 leading-tight\">Monitor\n                    Remotely with <br><span class=\"text1\">HYDROMATIC</span></h1>\n                <h1 id=\"heading2\" class=\"fade-slide-in text-5xl font-bold text-gray-800 leading-tight hidden\">Grow\n                    Lettuce with <br><span class=\"text1\">HYDROMATIC</span></h1>\n                <h1 id=\"heading3\" class=\"fade-slide-in text-5xl font-bold text-gray-800 leading-tight hidden\">Sample\n                    Dashboard of <br><span class=\"text1\">HYDROMATIC</span> Site.</h1>\n                <p class=\"text-gray-600 mx-5 lg:mr-11\">\"Comprehensive Monitoring Solution for Kratky Hydroponics Farms.\n                    Leveraging IoT,\n                    our system integrates <mark>water-level sensors</mark>, <mark>water temperature sensors</mark>, and\n                    <mark>air pumps</mark> to optimize and sustain your hydroponic system.\"\n                </p>\n            </div>\n            <div class=\"zoom-container mx-auto\">\n                <img id=\"section-image-1\" src=\"img/deviceframes.png\" alt=\"App Image\" class=\"w-full h-auto\">\n            </div>\n        </div>\n    </section>'),
(2, 'Features', '<section id=\"features\" class=\"bg-body  py-44 \">\n        <div class=\"container mx-auto text-center p-6 \">\n            <h2 class=\"text-5xl font-bold text-gray-200 mb-8 scroll-animation\">Key Features</h2>\n            <div class=\"grid grid-cols-1 md:grid-cols-3 gap-8\">\n                <div class=\"feature-item p-6 bg-gray-100 rounded-lg shadow-lg\">\n                    <div class=\"text-3xl text-d mb-4\">\n                        <i class=\"fas fa-water\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-semibold text-gray-800 mb-2 scroll-animation\"><mark>Water-Level\n                            Monitoring</mark></h3>\n                    <p class=\"text-gray-600 scroll-animation\">Track the water levels in real-time to ensure optimal\n                        conditions for your plants.</p>\n                </div>\n                <div class=\"feature-item p-6 bg-gray-100 rounded-lg shadow-lg\">\n                    <div class=\"text-3xl text-d mb-4\">\n                        <i class=\"fas fa-thermometer-half\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-semibold text-gray-800 mb-2 scroll-animation\"><mark>Temperature\n                            Monitoring</mark></h3>\n                    <p class=\"text-gray-600 scroll-animation\">Monitor the water temperature to maintain the perfect\n                        environment for your crops.</p>\n                </div>\n                <div class=\"feature-item p-6 bg-gray-100 rounded-lg shadow-lg\">\n                    <div class=\"text-3xl text-d mb-4\">\n                        <i class=\"fas fa-bullhorn\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-semibold text-gray-800 mb-2 scroll-animation\"><mark>Automated Air\n                            Pumps</mark></h3>\n                    <p class=\"text-gray-600 scroll-animation\">Ensure efficient aeration with automated air pumps that\n                        supply oxygen to the roots of the plants.</p>\n                </div>\n            </div>\n        </div>\n    </section>'),
(3, 'Device Information', '<section id=\"device-info\" class=\"bg-c  pb-24\">\n        <div class=\"mx-auto grid max-w-2xl grid-cols-1 items-center gap-x-8 gap-y-16 px-4 py-24 sm:px-6 sm:py-32 lg:max-w-7xl lg:grid-cols-2 lg:px-8\">\n            <div>\n                <h2 class=\"text-3xl font-bold tracking-tight text-black-200 sm:text-4xl scroll-animation\">HydroMatic\n                    Device</h2>\n                <p class=\"mt-4 text-black-200 scroll-animation\">Description: We develop a device that utilizes sensors to\n                    monitor and supply oxygen in hydroponic setup. It ensures optimal growing conditions and\n                    facitlitates oxygen delivery to aerate water for growth efficiency.</p>\n\n                <dl class=\"mt-16 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 sm:gap-y-16 lg:gap-x-8\">\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">1. Water Level Sensor</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A device that measures the\n                            level of water in a container, providing real-time data for applications.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">2. DS18B20 Temperature Sensor</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A digital temperature\n                            sensor capable of measuring temperatures ranging from -55°C to +125°C.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">3. Air Pump</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: An electric or manual\n                            device that moves air from one location to another, typically used to aerate water in\n                            hydroponic system, ensuring oxygen for plant roots.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">4.ESP8266 NodeMCU v1.0 (ESP-12E)</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A low-cost Wi-Fi microchip\n                            with full TCP/IP stack and microcontroller capabilities, often used in IoT projects for\n                            wireless connectivity and control of devices.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">5. NodeMCU Baseboard</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A development board\n                            designed for the ESP8266, providing easy access to GPIO pins, power supply, and programming\n                            interfaces, facilitating rapid prototyping of IoT applications.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">6.Relay Module</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: An electronic component\n                            that allows a low-power signal to control a high-power circuit, it is used to control the\n                            Air Pump.</dd>\n                    </div>\n                </dl>\n            </div>\n            <div class=\"grid grid-cols-2 grid-rows-2 gap-4 sm:gap-6 lg:gap-8 scroll-animation\">\n                <img id=\"section-image-3\" src=\"img\\water-level.jpg\" alt=\"Walnut card tray with white powder coated steel divider and 3 punchout holes.\" class=\"rounded-lg bg-gray-100\">\n                <img id=\"section-image-3\" src=\"img\\water-temp.jpg\" alt=\"Top down view of walnut card tray with embedded magnets and card groove.\" class=\"rounded-lg bg-gray-100\">\n                <img id=\"section-image-3\" src=\"img\\sensor.jpg\" alt=\"Side of walnut card tray with card groove and recessed card area.\" class=\"rounded-lg bg-gray-100\">\n                <img id=\"section-image-3\" src=\"img\\wifi.jpg\" alt=\"Walnut card tray filled with cards and card angled in dedicated groove.\" class=\"rounded-lg bg-gray-100\">\n                <img id=\"section-image-3\" src=\"img\\board.jpg\" alt=\"Side of walnut card tray with card groove and recessed card area.\" class=\"rounded-lg bg-gray-100\">\n                <img id=\"section-image-3\" src=\"img\\relay.jpg\" alt=\"Walnut card tray filled with cards and card angled in dedicated groove.\" class=\"rounded-lg bg-gray-100\">\n\n            </div>\n        </div>\n        \n    </section>'),
(5, 'About Us', '<section id=\"about-us\" class=\"bg-body py-44 \">\n        <div class=\"container mx-auto px-4\">\n            <!-- About Us Heading -->\n            <div class=\"text-center mb-12\">\n                <h2 class=\"text-5xl font-bold text-gray-200 scroll-animation\">About Us</h2>\n                <p class=\"text-gray-300 mt-4 scroll-animation\">We are a passionate team dedicated to innovating and\n                    revolutionizing the hydroponic industry.</p>\n            </div>\n\n            <!-- Mission Statement -->\n            <div class=\"flex flex-col md:flex-row items-center mb-12 scroll-animation\">\n                <!-- Image Section -->\n                <div class=\"md:w-1/2 mb-8 md:mb-0 scroll-animation\">\n                    <img id=\"section-image-5\" src=\"img\\lett.jpg\" alt=\"Our Team\" class=\"w-full h-auto rounded-lg shadow-lg\">\n                </div>\n                <!-- Text Section -->\n                <div class=\"md:w-1/2 md:pl-12\">\n                    <h3 class=\"text-3xl font-semibold text-gray-200 scroll-animation\">Our Mission</h3>\n                    <p class=\"text-gray-300 mt-4 scroll-animation\">\n                        At HydroMatic, our mission is to make sustainable farming accessible to everyone through\n                        cutting-edge technology.\n                        We aim to empower farmers, hobbyists, and businesses with the tools they need to grow plants\n                        efficiently and sustainably.\n                    </p>\n                    <p class=\"text-gray-300 mt-4 scroll-animation\">\n                        Our team of experts brings together a wealth of experience in agriculture, engineering, and\n                        technology to deliver\n                        innovative hydroponic solutions. We believe in the power of hydroponics to transform the future\n                        of farming and are committed\n                        to making this vision a reality.\n                    </p>\n                </div>\n            </div>\n\n            <!-- Team Introduction -->\n            <div class=\"text-center mb-12 \">\n                <h3 class=\"text-4xl font-semibold text-gray-200 scroll-animation\">Meet Our Team</h3>\n                <p class=\"text-gray-300 mt-4 scroll-animation\">A group of dedicated professionals with diverse\n                    expertise.</p>\n            </div>\n            <div class=\" grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8 scroll-animation\">\n                <!-- Team Member 1 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img id=\"section-image-5\" src=\"img\\KURT.jpg\" alt=\"Team Member 1\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Kurt Russel C. Pablo</h4>\n                    <p class=\"text-gray-600\">Website Developer</p>\n                </div>\n\n                <!-- Team Member 2 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img id=\"section-image-5\" src=\"img\\BRIGGS.jpg\" alt=\"Team Member 2\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Briggs V. Reyes</h4>\n                    <p class=\"text-gray-600\">Full Stack Developer</p>\n                </div>\n\n                <!-- Team Member 3 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img id=\"section-image-5\" src=\"img\\SHEIK.jpg\" alt=\"Team Member 3\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Earl Sheik G. Mateo</h4>\n                    <p class=\"text-gray-600\">Documentation</p>\n                </div>\n\n                <!-- Team Member 4 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img id=\"section-image-5\" src=\"img\\JEAN.jpg\" alt=\"Team Member 4\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Jean Micaell Yabot</h4>\n                    <p class=\"text-gray-600\">Presentation</p>\n                </div>\n            </div>\n        </div>\n    </section>');

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
  ADD PRIMARY KEY (`Acc_Id`);

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
-- Indexes for table `page_content`
--
ALTER TABLE `page_content`
  ADD PRIMARY KEY (`section_id`);

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
