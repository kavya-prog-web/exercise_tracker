-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: May 04, 2025 at 11:39 PM
-- Server version: 8.2.0
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sd2-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `contact_us`
--

CREATE TABLE `contact_us` (
  `contact_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `contact_us`
--


-- --------------------------------------------------------

--
-- Table structure for table `fitness_records`
--

CREATE TABLE `fitness_records` (
  `record_id` int NOT NULL,
  `user_id` int NOT NULL,
  `activity_type` enum('Running','Walking','Cycling') NOT NULL,
  `duration` int NOT NULL,
  `distance` decimal(5,2) DEFAULT NULL,
  `calories_burned` decimal(6,2) DEFAULT NULL,
  `heart_rate` int DEFAULT NULL,
  `steps` int DEFAULT NULL,
  `recorded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `fitness_records`
--

INSERT INTO `fitness_records` (`record_id`, `user_id`, `activity_type`, `duration`, `distance`, `calories_burned`, `heart_rate`, `steps`, `recorded_at`) VALUES
(1, 5, 'Running', 31, 5.00, 300.00, 141, 5000, '2025-03-18 08:00:00'),
(3, 3, 'Cycling', 60, 20.50, 500.00, 130, 8000, '2025-03-18 09:00:00'),
(4, 4, 'Running', 25, 4.50, 250.00, 150, 4000, '2025-03-19 10:00:00'),
(5, 1, 'Walking', 35, 2.80, 180.00, 95, 5500, '2025-03-19 10:30:00'),
(6, 2, 'Cycling', 55, 18.00, 450.00, 120, 7500, '2025-03-19 11:00:00'),
(7, 3, 'Running', 40, 6.00, 350.00, 145, 6000, '2025-03-20 07:00:00'),
(8, 4, 'Walking', 50, 4.00, 220.00, 110, 7000, '2025-03-20 07:30:00'),
(9, 1, 'Cycling', 70, 22.50, 550.00, 125, 9000, '2025-03-20 08:00:00'),
(10, 2, 'Running', 20, 3.50, 200.00, 135, 4500, '2025-03-21 09:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `goals`
--

CREATE TABLE `goals` (
  `goal_id` int NOT NULL,
  `user_id` int NOT NULL,
  `goal_type` enum('Running','Walking','Cycling') NOT NULL,
  `target_value` decimal(10,2) NOT NULL,
  `current_value` decimal(10,2) DEFAULT '0.00',
  `start_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `goals`
--

INSERT INTO `goals` (`goal_id`, `user_id`, `goal_type`, `target_value`, `current_value`, `start_date`, `end_date`) VALUES
(1, 5, 'Running', 12.00, 0.00, '2025-05-04 20:52:00', '2025-05-05');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `id` int NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`id`, `email`, `password`) VALUES
(1, 'kevin@kevin.com', ''),
(2, 'lisa@lisa.com', ''),
(3, 'arturo@arturo.com', ''),
(4, 'Sobham@sobhan.com', ''),

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contact_us`
--
ALTER TABLE `contact_us`
  ADD PRIMARY KEY (`contact_id`);

--
-- Indexes for table `fitness_records`
--
ALTER TABLE `fitness_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `fk_fitness_user` (`user_id`);

--
-- Indexes for table `goals`
--
ALTER TABLE `goals`
  ADD PRIMARY KEY (`goal_id`),
  ADD KEY `idx_goals_user` (`user_id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contact_us`
--
ALTER TABLE `contact_us`
  MODIFY `contact_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `fitness_records`
--
ALTER TABLE `fitness_records`
  MODIFY `record_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `goals`
--
ALTER TABLE `goals`
  MODIFY `goal_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fitness_records`
--
ALTER TABLE `fitness_records`
  ADD CONSTRAINT `fk_fitness_user` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `goals`
--
ALTER TABLE `goals`
  ADD CONSTRAINT `fk_goals_user` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
