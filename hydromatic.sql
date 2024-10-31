-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 31, 2024 at 08:31 AM
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
-- Database: `hydromatic`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `AccountId` int(10) NOT NULL,
  `AccountFirstname` varchar(50) NOT NULL,
  `AccountLastname` varchar(50) NOT NULL,
  `AccountPhoneNumber` varchar(11) NOT NULL,
  `AccountPassword` varchar(255) NOT NULL,
  `Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`AccountId`, `AccountFirstname`, `AccountLastname`, `AccountPhoneNumber`, `AccountPassword`, `Date`) VALUES
(1, 'Briggs', 'Reyes', '09362386458', '$2b$10$BOo2tmAWEYZEwzIH.j.n0OcSs4EmXcLOf8Dm7SHdBP80gD7UsJnyW', '2024-10-31');

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `AdminId` int(10) NOT NULL,
  `AdminUsername` varchar(50) NOT NULL,
  `AdminPassword` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`AdminId`, `AdminUsername`, `AdminPassword`) VALUES
(1, 'Admin', 'Password');

-- --------------------------------------------------------

--
-- Table structure for table `archive`
--

CREATE TABLE `archive` (
  `ArchiveId` int(50) NOT NULL,
  `DeviceHostname` varchar(50) NOT NULL,
  `DeviceIpAddress` varchar(50) NOT NULL,
  `ArchiveStartDay` int(10) NOT NULL,
  `ArchiveLastDay` int(10) NOT NULL,
  `ArchiveStartDate` date NOT NULL,
  `ArchiveHarvestDate` date NOT NULL,
  `ArchiveDate` date NOT NULL,
  `ArchiveStatus` varchar(50) NOT NULL,
  `AccountId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deviceinformation`
--

CREATE TABLE `deviceinformation` (
  `DeviceId` int(11) NOT NULL,
  `OwnerFirstname` varchar(50) NOT NULL,
  `OwnerLastname` varchar(50) NOT NULL,
  `OwnerPhoneNumber` varchar(11) NOT NULL,
  `DeviceHostname` varchar(50) NOT NULL,
  `DeviceIpAddress` varchar(50) NOT NULL,
  `DeviceStatus` varchar(50) NOT NULL
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
-- Table structure for table `hydroframe`
--

CREATE TABLE `hydroframe` (
  `HydroFrameId` int(10) NOT NULL,
  `DeviceHostname` varchar(50) NOT NULL,
  `DeviceIpAddress` varchar(50) NOT NULL,
  `HydroFrameStartDay` int(10) NOT NULL,
  `HydroFrameLastDay` int(10) NOT NULL,
  `HydroFrameStartDate` date NOT NULL,
  `HydroFrameHarvestDate` date NOT NULL,
  `HydroFrameUpdateDate` date NOT NULL,
  `HydroFrameLastSMSDate` date NOT NULL,
  `HydroFrameStatus` varchar(50) NOT NULL,
  `AccountId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'Hero', 'heading1', 'Monitor Remotely with <br>           \n<span class=\"text1\">HYDROMATIC</span>', '2024-10-14 07:29:26'),
(2, 'Hero', 'heading2', 'Grow Lettuce with <br>\n<span class=\"text1\">HYDROMATIC</span>', '2024-10-14 07:22:13'),
(3, 'Hero', 'heading', 'Sample Dashboard of <br>\n<span class=\"text1\">HYDROMATIC</span> Site.', '2024-10-25 22:04:49'),
(4, 'Hero', 'Textheading', '\"Comprehensive Monitoring Solution for Kratky Hydroponics Farms. Leveraging IoT, our system integrates <mark>water-level sensors</mark>, <mark>water temperature sensors</mark>, and <mark>air pumps</mark> to optimize and sustain your hydroponic system.\"', '2024-10-23 04:38:41'),
(5, 'Features', 'featTitle', 'Key Features', '2024-10-14 05:55:00'),
(6, 'Features', 'realTime', '<mark>Real-Time Monitoring</mark>', '2024-10-14 05:55:00'),
(7, 'Features', 'realTimeText', 'Monitor your hydroponic system\'s status in real-time fromanywhere.', '2024-10-14 07:22:54'),
(8, 'Features', 'sms', '<mark>SMS Notification</mark>', '2024-10-14 05:55:00'),
(9, 'Features', 'smsText', 'Receive instant SMS notifications about your system’s status.', '2024-10-14 05:55:00'),
(10, 'Features', 'IoT', '<mark>IoT Integrated</mark>', '2024-10-14 05:55:00'),
(11, 'Features', 'IoTText', 'Seamlessly integrate IoT devices for automated monitoring.', '2024-10-14 05:55:00'),
(12, 'aboutHydro', 'HydroTitle', 'What is <span class=\"text1\">HydroMatic</span> all about?', '2024-10-14 06:01:50'),
(13, 'aboutHydro', 'HydroText', 'The HydroMatic is a smart system designed for easy management of hydroponic setups. It monitors water levels and temperature to ensure optimal conditions for plant growth, while the air pump keeps roots oxygenated. With built-in Wi-Fi, you can control and check the system remotely, and its design allows for easy upgrades. The device also automates tasks like turning the air pump on and off, making it a hassle-free way to maintain a healthy hydroponic environment.', '2024-10-14 06:01:50'),
(14, 'Steps', 'stepsTitle', 'How can I set up <span class=\"text1\">HydroMatic</span> with WiFi?', '2024-10-14 06:06:28'),
(15, 'aboutUs', 'aboutHead', 'About Us', '2024-10-14 06:14:28'),
(16, 'aboutUs', 'aboutHeadText', 'We are a passionate team dedicated to innovating and revolutionizing the hydroponic industry.', '2024-10-14 06:14:28'),
(17, 'aboutUs', 'mission', 'Our Mission', '2024-10-14 06:17:41'),
(18, 'aboutUs', 'missionText1', 'At HydroMatic, our mission is to make sustainable farming accessible to everyone through cutting-edge technology. We aim to empower farmers, hobbyists, and businesses with the tools they need to grow plants efficiently and sustainably.', '2024-10-14 06:17:41'),
(19, 'aboutUs', 'missionText2', 'Our team of experts brings together a wealth of experience in agriculture, engineering, and technology to deliver innovative hydroponic solutions. We believe in the power of hydroponics to transform the future of farming and are committed to making this vision a reality.', '2024-10-14 06:17:41'),
(20, 'faq', 'faqTitle', 'Frequently Asked Questions', '2024-10-14 06:25:42'),
(21, 'faq', 'faqDesc', 'Answers to your common queries about HydroMatic.', '2024-10-14 06:25:42'),
(22, 'faq', 'faqItem1', 'What is HydroMatic?', '2024-10-14 06:25:42'),
(23, 'faq', 'answer1', 'HydroMatic is a web-based monitoring system designed for hydroponics farming, utilizing IoT devices to optimize plant growth.', '2024-10-14 06:25:42'),
(24, 'faq', 'faqItem2', 'How does HydroMatic work?', '2024-10-14 06:25:42'),
(25, 'faq', 'answer2', 'HydroMatic works by collecting data from various sensors to monitor environmental conditions, allowing users to make informed decisions about their plants.', '2024-10-14 06:25:42'),
(26, 'faq', 'faqItem3', 'What sensors are included?', '2024-10-14 06:25:42'),
(27, 'faq', 'answer3', 'The system includes temperature sensors, humidity sensors, and water level sensors to provide comprehensive monitoring.', '2024-10-14 06:25:42'),
(28, 'faq', 'faqItem4', 'How can I get support?', '2024-10-14 06:25:42'),
(29, 'faq', 'answer4', 'You can reach out to our support team via email or through our website\'s contact form for assistance.', '2024-10-14 06:25:42'),
(30, 'faq', 'faqItem5', 'Is HydroMatic easy to set up?', '2024-10-14 06:25:42'),
(31, 'faq', 'answer5', 'Yes, HydroMatic is designed for easy setup, with detailed instructions provided for each component.', '2024-10-14 06:25:42'),
(32, 'video-background-section', 'auto', 'Smart Monitoring', '2024-10-25 22:03:57'),
(33, 'video-background-section', 'Hydro', 'Meets HYDROPONICS', '2024-10-25 22:04:03'),
(34, 'video-background-section', 'para', 'Embark on a transformative journey with HydroMatic, where state-of-the-art automation enhances hydroponics farming. Our advanced monitoring solutions keep you informed about every crucial aspect of your farm, ensuring that your crops thrive under optimal conditions. From real-time tracking of water quality and environmental factors, HydroMatic provides the insights you need to make informed decisions. Experience a smarter, more efficient way to grow with HydroMatic and discover how automation can help you achieve a successful, high-yield operation.', '2024-10-25 22:01:00'),
(35, 'video-background-section', 'start', 'Start your journey towards smarter hydroponics with us today!', '2024-10-25 22:03:23');

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
(1, 'Hero', 'sampleDevice', 'deviceframes2.png', 'img/deviceframes2.png', '2024-10-14 05:46:20'),
(2, 'aboutHydro', 'hydroImg', 'How.png', 'img/How.png', '2024-10-14 07:08:30'),
(3, 'Steps', 'stepsImg1', 'step1.jpg', 'img/step1.jpg', '2024-10-14 06:30:18'),
(4, 'Steps', 'stepsImg2', 'step3.jpg', 'img/step3.jpg', '2024-10-14 06:30:23'),
(5, 'Steps', 'stepsImg3', 'step4.jpg', 'img/step4.jpg', '2024-10-14 06:30:28'),
(6, 'Steps', 'stepsImg4', 'step5.jpg', 'img/step5.jpg', '2024-10-14 06:30:34'),
(7, 'aboutUs', 'aboutImg', 'lett.jpg', 'img/lett.jpg', '2024-10-14 06:30:38');

-- --------------------------------------------------------

--
-- Table structure for table `useractivity`
--

CREATE TABLE `useractivity` (
  `ActivityId` int(50) NOT NULL,
  `AccountId` int(10) NOT NULL,
  `Activity` varchar(50) NOT NULL,
  `Date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `useractivity`
--

INSERT INTO `useractivity` (`ActivityId`, `AccountId`, `Activity`, `Date`) VALUES
(1, 1, 'LOGGED IN', '2024-10-31 06:56:29'),
(2, 1, 'LOGGED OUT', '2024-10-31 06:56:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`AccountId`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`AdminId`);

--
-- Indexes for table `archive`
--
ALTER TABLE `archive`
  ADD PRIMARY KEY (`ArchiveId`),
  ADD KEY `AccountId` (`AccountId`) USING BTREE,
  ADD KEY `DeviceHostname` (`DeviceHostname`),
  ADD KEY `DeviceIpAddress` (`DeviceIpAddress`);

--
-- Indexes for table `deviceinformation`
--
ALTER TABLE `deviceinformation`
  ADD PRIMARY KEY (`DeviceId`),
  ADD UNIQUE KEY `DeviceHostname` (`DeviceHostname`,`DeviceIpAddress`);

--
-- Indexes for table `hydroframe`
--
ALTER TABLE `hydroframe`
  ADD PRIMARY KEY (`HydroFrameId`),
  ADD KEY `AccountId` (`AccountId`) USING BTREE,
  ADD KEY `DeviceHostname` (`DeviceHostname`),
  ADD KEY `DeviceIpAddress` (`DeviceIpAddress`);

--
-- Indexes for table `useractivity`
--
ALTER TABLE `useractivity`
  ADD PRIMARY KEY (`ActivityId`),
  ADD KEY `AccountId` (`AccountId`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `AccountId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `AdminId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `archive`
--
ALTER TABLE `archive`
  MODIFY `ArchiveId` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deviceinformation`
--
ALTER TABLE `deviceinformation`
  MODIFY `DeviceId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hydroframe`
--
ALTER TABLE `hydroframe`
  MODIFY `HydroFrameId` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `useractivity`
--
ALTER TABLE `useractivity`
  MODIFY `ActivityId` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
