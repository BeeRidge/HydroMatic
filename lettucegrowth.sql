-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 20, 2024 at 12:32 PM
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
(5, 'bed1', '192.168.100.116', 59, 71, '2024-09-04', '2024-09-15', '2024-09-16', 'FINISHED'),
(6, 'bed1', '192.168.100.116', 10, 49, '2024-08-08', '2024-10-07', '2024-09-16', 'REMOVED'),
(7, 'bed1', '192.168.100.116', 30, 37, '2024-09-09', '2024-10-19', '2024-09-16', 'REMOVED'),
(8, 'bed2', '192.168.100.118', 30, 47, '2024-09-01', '2024-10-11', '2024-09-18', 'REMOVED'),
(9, 'bed2', '192.168.100.118', 10, 29, '2024-08-30', '2024-10-11', '2024-09-18', 'REMOVED');

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
(1, '192.168.100.116', '29.56', 'LOW', '2024-07-21', '21:15:06'),
(2, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:15:21'),
(3, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:15:37'),
(4, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:15:52'),
(5, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:16:08'),
(6, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:16:24'),
(7, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:16:42'),
(8, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:16:58'),
(9, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:17:13'),
(10, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:17:29'),
(11, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:17:45'),
(12, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:18:00'),
(13, '192.168.100.116', '29.50', 'LOW', '2024-08-31', '21:18:16'),
(14, '192.168.100.116', '29.38', 'LOW', '2024-08-31', '21:18:31'),
(15, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:18:47'),
(16, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:19:03'),
(17, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:19:18'),
(18, '192.168.100.116', '29.38', 'LOW', '2024-08-31', '21:19:34'),
(19, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:19:49'),
(20, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:20:05'),
(21, '192.168.100.116', '29.38', 'LOW', '2024-08-31', '21:20:30'),
(22, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:20:45'),
(23, '192.168.100.116', '29.38', 'LOW', '2024-08-31', '21:21:01'),
(24, '192.168.100.116', '29.44', 'LOW', '2024-08-31', '21:21:16'),
(25, '192.168.100.116', '29.38', 'LOW', '2024-08-31', '21:21:32'),
(26, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:21:48'),
(27, '192.168.100.116', '29.38', 'LOW', '2024-08-31', '21:22:03'),
(28, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:22:19'),
(29, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:22:34'),
(30, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:22:50'),
(31, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:23:05'),
(32, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:23:21'),
(33, '192.168.100.116', '29.25', 'LOW', '2024-08-31', '21:23:36'),
(34, '192.168.100.116', '29.25', 'LOW', '2024-08-31', '21:23:52'),
(35, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:24:08'),
(36, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:24:23'),
(37, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:24:39'),
(38, '192.168.100.116', '29.25', 'LOW', '2024-08-31', '21:24:54'),
(39, '192.168.100.116', '29.25', 'LOW', '2024-08-31', '21:25:10'),
(40, '192.168.100.116', '29.25', 'LOW', '2024-08-31', '21:25:25'),
(41, '192.168.100.116', '29.31', 'LOW', '2024-08-31', '21:25:41'),
(42, '192.168.100.116', '29.25', 'LOW', '2024-08-31', '21:25:56'),
(43, '192.168.100.116', '28.69', 'LOW', '2024-08-31', '21:56:23'),
(44, '192.168.100.116', '28.69', 'LOW', '2024-08-31', '21:56:38'),
(45, '192.168.100.116', '28.69', 'LOW', '2024-08-31', '21:56:54'),
(46, '192.168.100.116', '28.69', 'LOW', '2024-08-31', '21:57:09'),
(47, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:57:25'),
(48, '192.168.100.116', '28.69', 'LOW', '2024-08-31', '21:57:40'),
(49, '192.168.100.116', '28.69', 'LOW', '2024-08-31', '21:57:56'),
(50, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:58:12'),
(51, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:58:27'),
(52, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:58:43'),
(53, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:58:58'),
(54, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:59:14'),
(55, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:59:29'),
(56, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '21:59:45'),
(57, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '22:00:00'),
(58, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '22:00:16'),
(59, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:00:32'),
(60, '192.168.100.116', '28.63', 'LOW', '2024-08-31', '22:00:47'),
(61, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:01:15'),
(62, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:01:31'),
(63, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:01:46'),
(64, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:02:02'),
(65, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:02:18'),
(66, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:02:48'),
(67, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:03:03'),
(68, '192.168.100.116', '28.56', 'LOW', '2024-08-31', '22:03:19'),
(69, '192.168.100.116', '28.50', 'LOW', '2024-08-31', '22:03:34'),
(70, '192.168.100.116', '28.50', 'LOW', '2024-08-31', '22:03:50'),
(71, '192.168.100.116', '28.50', 'LOW', '2024-08-31', '22:04:06'),
(72, '192.168.100.116', '28.50', 'LOW', '2024-09-09', '22:04:21'),
(73, '192.168.100.116', '27.25', 'LOW', '2024-09-09', '09:29:01'),
(74, '192.168.100.116', '27.19', 'LOW', '2024-09-09', '09:29:16'),
(75, '192.168.100.116', '27.19', 'LOW', '2024-09-09', '09:29:35'),
(76, '192.168.100.116', '27.19', 'LOW', '2024-09-09', '09:29:52'),
(77, '192.168.100.116', '27.25', 'LOW', '2024-09-09', '09:30:08'),
(78, '192.168.100.116', '27.38', 'LOW', '2024-09-09', '09:32:27'),
(79, '192.168.100.116', '27.38', 'LOW', '2024-09-10', '09:32:43'),
(80, '192.168.100.116', '27.38', 'LOW', '2024-09-10', '09:32:58');

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
(1, '192.168.100.116', '29.56', 'LOW', '2024-09-10', '21:15:06'),
(2, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:15:21'),
(3, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:15:37'),
(4, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:15:52'),
(5, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:16:08'),
(6, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:16:24'),
(7, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:16:42'),
(8, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:16:58'),
(9, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:17:13'),
(10, '192.168.100.116', '29.50', 'LOW', '2024-09-10', '21:17:29');

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
(1, 'bed1', '192.168.100.116', 'CONNECTED'),
(2, 'bed2', '192.168.100.118', 'CONNECTED');

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

--
-- Dumping data for table `display_bed`
--

INSERT INTO `display_bed` (`Bed_Id`, `Var_Host`, `Var_Ip`, `Start_Day`, `Last_Day`, `Start_Date`, `Harvest_Date`, `Update_Date`, `Last_SMS_Date`) VALUES
(37, 'bed1', '192.168.100.116', 30, 60, '2024-08-19', '2024-09-26', '2024-09-18', '2024-09-19');

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
(1, 'hero', '<section class=\"bg-c py-48 px-10 w-full h-auto\">\n        <div class=\"container mx-auto flex flex-col md:flex-row items-center\">\n            <div id=\"headings-container\" class=\" space-y-6 text-center md:text-left\">\n                <h1 id=\"heading1\" class=\"fade-slide-in text-5xl font-bold text-gray-800 leading-tight\">Monitor\n                    Remotely with <br><span class=\"text1\">HYDROMATIC</span></h1>\n                <h1 id=\"heading2\" class=\"fade-slide-in text-5xl font-bold text-gray-800 leading-tight hidden\">Grow\n                    Lettuce with <br><span class=\"text1\">HYDROMATIC</span></h1>\n                <h1 id=\"heading3\" class=\"fade-slide-in text-5xl font-bold text-gray-800 leading-tight hidden\">Sample\n                    Dashboard of <br><span class=\"text1\">HYDROMATIC</span> Site.</h1>\n                <p class=\"text-gray-600 mx-5 lg:mr-11\">\"Comprehensive Monitoring Solution for Kratky Hydroponics Farms.\n                    Leveraging IoT,\n                    our system integrates <mark>water-level sensors</mark>, <mark>water temperature sensors</mark>, and\n                    <mark>air pumps</mark> to optimize and sustain your hydroponic system.\"\n                </p>\n            </div>\n            <div class=\"zoom-container mx-auto\">\n                <img src=\"img/deviceframes (1).png\" alt=\"App Image\" class=\"w-full h-auto\">\n            </div>\n        </div>\n    </section>'),
(2, 'features', '<section id=\"features\" class=\"bg-body  py-44 \">\n        <div class=\"container mx-auto text-center p-6 \">\n            <h2 class=\"text-5xl font-bold text-gray-200 mb-8 scroll-animation\">Key Features</h2>\n            <div class=\"grid grid-cols-1 md:grid-cols-3 gap-8\">\n                <div class=\"feature-item p-6 bg-gray-100 rounded-lg shadow-lg\">\n                    <div class=\"text-3xl text-d mb-4\">\n                        <i class=\"fas fa-water\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-semibold text-gray-800 mb-2 scroll-animation\"><mark>Water-Level\n                            Monitoring</mark></h3>\n                    <p class=\"text-gray-600 scroll-animation\">Track the water levels in real-time to ensure optimal\n                        conditions for your plants.</p>\n                </div>\n                <div class=\"feature-item p-6 bg-gray-100 rounded-lg shadow-lg\">\n                    <div class=\"text-3xl text-d mb-4\">\n                        <i class=\"fas fa-thermometer-half\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-semibold text-gray-800 mb-2 scroll-animation\"><mark>Temperature\n                            Monitoring</mark></h3>\n                    <p class=\"text-gray-600 scroll-animation\">Monitor the water temperature to maintain the perfect\n                        environment for your crops.</p>\n                </div>\n                <div class=\"feature-item p-6 bg-gray-100 rounded-lg shadow-lg\">\n                    <div class=\"text-3xl text-d mb-4\">\n                        <i class=\"fas fa-bullhorn\"></i>\n                    </div>\n                    <h3 class=\"text-2xl font-semibold text-gray-800 mb-2 scroll-animation\"><mark>Automated Air\n                            Pumps</mark></h3>\n                    <p class=\"text-gray-600 scroll-animation\">Ensure efficient aeration with automated air pumps that\n                        supply oxygen to the roots of the plants.</p>\n                </div>\n            </div>\n        </div>\n    </section>'),
(3, 'device_info', '<section id=\"device-info\" class=\"bg-c  pb-24\">\n        <div class=\"mx-auto grid max-w-2xl grid-cols-1 items-center gap-x-8 gap-y-16 px-4 py-24 sm:px-6 sm:py-32 lg:max-w-7xl lg:grid-cols-2 lg:px-8\">\n            <div>\n                <h2 class=\"text-3xl font-bold tracking-tight text-black-200 sm:text-4xl scroll-animation\">HydroMatic\n                    Device</h2>\n                <p class=\"mt-4 text-black-200 scroll-animation\">Description: We develop a device that utilizes sensors to\n                    monitor and supply oxygen in hydroponic setup. It ensures optimal growing conditions and\n                    facitlitates oxygen delivery to aerate water for growth efficiency.</p>\n\n                <dl class=\"mt-16 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 sm:gap-y-16 lg:gap-x-8\">\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">1. Water Level Sensor</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A device that measures the\n                            level of water in a container, providing real-time data for applications.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">2. DS18B20 Temperature Sensor</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A digital temperature\n                            sensor capable of measuring temperatures ranging from -55°C to +125°C.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">3. Air Pump</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: An electric or manual\n                            device that moves air from one location to another, typically used to aerate water in\n                            hydroponic system, ensuring oxygen for plant roots.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">4.ESP8266 NodeMCU v1.0 (ESP-12E)</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A low-cost Wi-Fi microchip\n                            with full TCP/IP stack and microcontroller capabilities, often used in IoT projects for\n                            wireless connectivity and control of devices.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">5. NodeMCU Baseboard</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: A development board\n                            designed for the ESP8266, providing easy access to GPIO pins, power supply, and programming\n                            interfaces, facilitating rapid prototyping of IoT applications.</dd>\n                    </div>\n                    <div class=\"border-t border-black-800 pt-4\">\n                        <dt class=\"font-medium text-black-200 scroll-animation\">6.Relay Module</dt>\n                        <dd class=\"mt-2 text-sm text-black-200 scroll-animation\">Description: An electronic component\n                            that allows a low-power signal to control a high-power circuit, it is used to control the\n                            Air Pump.</dd>\n                    </div>\n                </dl>\n            </div>\n            <div class=\"grid grid-cols-2 grid-rows-2 gap-4 sm:gap-6 lg:gap-8 scroll-animation\">\n                <img src=\"img\\water-level.jpg\" alt=\"Walnut card tray with white powder coated steel divider and 3 punchout holes.\" class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\water-temp.jpg\" alt=\"Top down view of walnut card tray with embedded magnets and card groove.\" class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\sensor.jpg\" alt=\"Side of walnut card tray with card groove and recessed card area.\" class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\wifi.jpg\" alt=\"Walnut card tray filled with cards and card angled in dedicated groove.\" class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\board.jpg\" alt=\"Side of walnut card tray with card groove and recessed card area.\" class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\relay.jpg\" alt=\"Walnut card tray filled with cards and card angled in dedicated groove.\" class=\"rounded-lg bg-gray-100\">\n\n            </div>\n        </div>\n        \n    </section>'),
(4, 'steps', '<section id=\"steps\" class=\"bg-body py-24\">\n        <div class=\"mx-auto max-w-7xl px-4 sm:px-6 lg:px-8\">\n\n            <h2 class=\"text-3xl font-bold tracking-tight text-center text-gray-200 sm:text-4xl\">Steps to Use HydroMatic Device</h2>\n            <ol class=\"mt-8 space-y-4 text-gray-200\">\n                <li class=\"flex items-start\">\n                    <span class=\"font-bold text-lg\">1.</span>\n                    <span class=\"ml-2\">Go to the WiFi settings and connect to the \"ESP8266_Config\" network.</span>\n                </li>\n                <li class=\"flex items-start\">\n                    <span class=\"font-bold text-lg\">2.</span>\n                    <span class=\"ml-2\">Type 192.168.4.1 on your browser and input the username and password at the back\n                        of device.</span>\n                </li>\n                <li class=\"flex items-start\">\n                    <span class=\"font-bold text-lg\">3.</span>\n                    <span class=\"ml-2\">Input the bed number \"bed_\", also type the ssid/name and password of the WiFi\n                        network.</span>\n                </li>\n                <li class=\"flex items-start\">\n                    <span class=\"font-bold text-lg\">4.</span>\n                    <span class=\"ml-2\">Wait for the SUCCESS message to display and connect to your network to see the\n                        Dashboard.</span>\n                </li>\n\n            </ol>\n            <div class=\" py-6 grid grid-cols-4  gap-4 sm:gap-2  scroll-animation\">\n                <img src=\"img\\step1.jpg\"\n                    alt=\"Walnut card tray with white powder coated steel divider and 3 punchout holes.\"\n                    class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\step3.jpg\" alt=\"Side of walnut card tray with card groove and recessed card area.\"\n                    class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\step4.jpg\"\n                    alt=\"Walnut card tray filled with cards and card angled in dedicated groove.\"\n                    class=\"rounded-lg bg-gray-100\">\n                <img src=\"img\\step5.jpg\" alt=\"Side of walnut card tray with card groove and recessed card area.\"\n                    class=\"rounded-lg bg-gray-100\">\n            </div>\n        </div>\n    </section>'),
(5, 'about-us', '<section id=\"about-us\" class=\"bg-c py-44 \">\n        <div class=\"container mx-auto px-4\">\n            <!-- About Us Heading -->\n            <div class=\"text-center mb-12\">\n                <h2 class=\"text-5xl font-bold text-gray-800 scroll-animation\">About Us</h2>\n                <p class=\"text-gray-600 mt-4 scroll-animation\">We are a passionate team dedicated to innovating and\n                    revolutionizing the hydroponic industry.</p>\n            </div>\n\n            <!-- Mission Statement -->\n            <div class=\"flex flex-col md:flex-row items-center mb-12 scroll-animation\">\n                <!-- Image Section -->\n                <div class=\"md:w-1/2 mb-8 md:mb-0 scroll-animation\">\n                    <img src=\"img\\lett.jpg\" alt=\"Our Team\" class=\"w-full h-auto rounded-lg shadow-lg\">\n                </div>\n                <!-- Text Section -->\n                <div class=\"md:w-1/2 md:pl-12\">\n                    <h3 class=\"text-3xl font-semibold text-gray-800 scroll-animation\">Our Mission</h3>\n                    <p class=\"text-gray-600 mt-4 scroll-animation\">\n                        At HydroMatic, our mission is to make sustainable farming accessible to everyone through\n                        cutting-edge technology.\n                        We aim to empower farmers, hobbyists, and businesses with the tools they need to grow plants\n                        efficiently and sustainably.\n                    </p>\n                    <p class=\"text-gray-600 mt-4 scroll-animation\">\n                        Our team of experts brings together a wealth of experience in agriculture, engineering, and\n                        technology to deliver\n                        innovative hydroponic solutions. We believe in the power of hydroponics to transform the future\n                        of farming and are committed\n                        to making this vision a reality.\n                    </p>\n                </div>\n            </div>\n\n            <!-- Team Introduction -->\n            <div class=\"text-center mb-12 \">\n                <h3 class=\"text-4xl font-semibold text-gray-800 scroll-animation\">Meet Our Team</h3>\n                <p class=\"text-gray-600 mt-4 scroll-animation\">A group of dedicated professionals with diverse\n                    expertise.</p>\n            </div>\n            <div class=\" grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-8 scroll-animation\">\n                <!-- Team Member 1 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img src=\"img\\KURT.jpg\" alt=\"Team Member 1\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Kurt Russel C. Pablo</h4>\n                    <p class=\"text-gray-600\">Website Developer</p>\n                </div>\n\n                <!-- Team Member 2 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img src=\"img\\BRIGGS.jpg\" alt=\"Team Member 2\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Briggs V. Reyes</h4>\n                    <p class=\"text-gray-600\">Full Stack Developer</p>\n                </div>\n\n                <!-- Team Member 3 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img src=\"img\\SHEIK.jpg\" alt=\"Team Member 3\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Earl Sheik G. Mateo</h4>\n                    <p class=\"text-gray-600\">Documentation</p>\n                </div>\n\n                <!-- Team Member 4 -->\n                <div class=\"team-member bg-white p-6 rounded-lg shadow-lg text-center\">\n                    <img src=\"img\\JEAN.jpg\" alt=\"Team Member 4\" class=\"w-32 h-32 mx-auto rounded-full mb-4\">\n                    <h4 class=\"text-xl font-bold text-gray-800\">Jean Micaell Yabot</h4>\n                    <p class=\"text-gray-600\">Presentation</p>\n                </div>\n            </div>\n        </div>\n    </section>');

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
(0, '1726680756519.png', '/img/1726680756519.png', '2024-09-18 17:32:36', 0),
(11, 'board.jpg', 'img/board.jpg', '2024-09-16 07:25:15', 3),
(12, 'sensor.jpg', 'img/sensor.jpg', '2024-09-16 07:25:15', 3),
(14, 'BRIGGS.jpg', 'img/BRIGGS.jpg', '2024-09-16 07:25:15', 5),
(15, 'deviceframes (1).png', '/img/deviceframes (1).png', '2024-09-16 07:25:15', 1),
(16, 'JEAN.jpg', 'img/JEAN.jpg', '2024-09-16 07:25:15', 5),
(17, 'KURT.jpg', 'img/KURT.jpg', '2024-09-16 07:25:15', 5),
(18, 'lett.jpg', 'img/lett.jpg', '2024-09-16 07:25:15', 5),
(19, 'relay.jpg', 'img/relay.jpg', '2024-09-16 07:25:15', 3),
(20, 'SHEIK.jpg', 'img/SHEIK.jpg', '2024-09-16 07:25:15', 5),
(21, 'step1.jpg', 'img/step1.jpg', '2024-09-16 07:25:15', 4),
(22, 'step2.jpg', 'img/step2.jpg', '2024-09-16 07:25:15', 4),
(23, 'step3.jpg', 'img/step3.jpg', '2024-09-16 07:25:15', 4),
(24, 'step4.jpg', 'img/step4.jpg', '2024-09-16 07:25:15', 4),
(25, 'step5.jpg', 'img/step5.jpg', '2024-09-16 07:25:15', 4),
(26, 'water-level.jpg', '/img/water-level.jpg', '2024-09-16 07:25:15', 3),
(27, 'water-temp.jpg', 'img/water-temp.jpg', '2024-09-16 07:25:15', 3),
(28, 'wifi.jpg', 'img/wifi.jpg', '2024-09-16 07:25:15', 3);

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
  MODIFY `Archive_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `bed1`
--
ALTER TABLE `bed1`
  MODIFY `Num_Id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `device_info`
--
ALTER TABLE `device_info`
  MODIFY `Int_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `display_bed`
--
ALTER TABLE `display_bed`
  MODIFY `Bed_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
