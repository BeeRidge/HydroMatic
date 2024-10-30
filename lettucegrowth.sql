-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 30, 2024 at 08:31 AM
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
  `Acc_Password` varchar(250) NOT NULL,
  `Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`Acc_Id`, `Acc_Fname`, `Acc_Lname`, `Acc_Pnumber`, `Acc_Password`, `Date`) VALUES
(6, 'Briggs', 'Reyes', '09362386458', '$2b$10$.552YoqnxIRseBMmqc6QN.9udcQiRtZKG6.Bzk4Rt1Y3kOJHbuthm', '2024-10-17');

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
(18, 'Briggs', 'Reyes', '09362386458', 'UPDATE FIRST NAME', '2024-10-15 01:06:33'),
(19, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-17 07:42:08'),
(20, 'Briggs', 'Reyes', '09362386458', 'REMOVE HYDRO FRAME', '2024-10-17 07:42:15'),
(21, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-17 07:43:29'),
(22, 'Briggs', 'Reyes', '09362386458', 'RECOVER HYDRO FRAME', '2024-10-17 07:51:26'),
(23, 'Briggs', 'Reyes', '09362386458', 'REMOVE HYDRO FRAME', '2024-10-17 07:51:33'),
(24, 'Briggs', 'Reyes', '09362386458', 'RECOVER HYDRO FRAME', '2024-10-17 07:51:41'),
(25, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-17 07:58:48'),
(26, 'Briggs', 'Reyes', '09362386458', 'LOGGED OUT', '2024-10-17 07:58:55'),
(27, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-17 11:59:17'),
(28, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-17 14:24:25'),
(29, 'Briggs', 'Reyes', '09362386458', 'LOGGED OUT', '2024-10-17 14:24:28'),
(30, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-17 15:19:30'),
(31, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-23 03:13:03'),
(32, 'Briggs', 'Reyes', '09362386458', 'LOGGED OUT', '2024-10-23 03:25:30'),
(33, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-23 03:33:55'),
(34, 'Briggs', 'Reyes', '09362386458', 'LOGGED OUT', '2024-10-23 11:21:43'),
(35, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-23 12:21:45'),
(36, 'Briggs', 'Reyes', '09362386458', 'LOGGED OUT', '2024-10-23 12:22:47'),
(37, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:12:38'),
(38, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:12:47'),
(39, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:22:09'),
(40, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:22:19'),
(41, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:22:36'),
(42, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:26:43'),
(43, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:27:29'),
(44, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:27:35'),
(45, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:29:17'),
(46, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 12:30:49'),
(47, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 13:12:25'),
(48, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 13:20:05'),
(49, 'Briggs', 'Reyes', '09362386458', 'REMOVE HYDRO FRAME', '2024-10-26 13:20:34'),
(50, 'Briggs', 'Reyes', '09362386458', 'RECOVER HYDRO FRAME', '2024-10-26 13:21:01'),
(51, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 13:22:38'),
(52, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 13:23:01'),
(53, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 14:09:28'),
(54, 'Briggs', 'Reyes', '09362386458', 'LOGGED IN', '2024-10-26 14:29:47');

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `Id` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`Id`, `Username`, `Password`) VALUES
(1, 'Admin', 'AdminPassword123');

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
(3, 'Briggs', 'Reyes', '09362386458', 'bed2', '192.168.100.31', 'REPAIR');

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
(64, 'bed2', '192.168.100.31', 10, 35, '2024-10-01', '2024-11-30', '2024-10-26', NULL, 'ONGOING', '09362386458');

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
(3, 'Hero', 'heading', 'Sample Dashboard of <br>\n<span class=\"text1\">HYDROMATIC</span> Site.', '2024-10-26 06:04:49'),
(4, 'Hero', 'Textheading', '\"Comprehensive Monitoring Solution for Kratky Hydroponics Farms. Leveraging IoT, our system integrates <mark>water-level sensors</mark>, <mark>water temperature sensors</mark>, and <mark>air pumps</mark> to optimize and sustain your hydroponic system.\"', '2024-10-23 12:38:41'),
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
(31, 'faq', 'answer5', 'Yes, HydroMatic is designed for easy setup, with detailed instructions provided for each component.', '2024-10-14 14:25:42'),
(32, 'video-background-section', 'auto', 'Smart Monitoring', '2024-10-26 06:03:57'),
(33, 'video-background-section', 'Hydro', 'Meets HYDROPONICS', '2024-10-26 06:04:03'),
(34, 'video-background-section', 'para', 'Embark on a transformative journey with HydroMatic, where state-of-the-art automation enhances hydroponics farming. Our advanced monitoring solutions keep you informed about every crucial aspect of your farm, ensuring that your crops thrive under optimal conditions. From real-time tracking of water quality and environmental factors, HydroMatic provides the insights you need to make informed decisions. Experience a smarter, more efficient way to grow with HydroMatic and discover how automation can help you achieve a successful, high-yield operation.', '2024-10-26 06:01:00'),
(35, 'video-background-section', 'start', 'Start your journey towards smarter hydroponics with us today!', '2024-10-26 06:03:23');

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
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `archived`
--
ALTER TABLE `archived`
  ADD PRIMARY KEY (`Archive_Id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `archived`
--
ALTER TABLE `archived`
  MODIFY `Archive_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `device_info`
--
ALTER TABLE `device_info`
  MODIFY `Int_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `display_bed`
--
ALTER TABLE `display_bed`
  MODIFY `Bed_Id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `growthtimeline`
--
ALTER TABLE `growthtimeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `pagecontent`
--
ALTER TABLE `pagecontent`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `pageimage`
--
ALTER TABLE `pageimage`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
