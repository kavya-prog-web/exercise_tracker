-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Mar 19, 2025 at 12:05 AM
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
-- Table structure for table `fitness_records`
--

CREATE TABLE `fitness_records` (
  `record_id` int NOT NULL,
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

INSERT INTO `fitness_records` (`record_id`, `activity_type`, `duration`, `distance`, `calories_burned`, `heart_rate`, `steps`, `recorded_at`) VALUES
(1, 'Running', 30, 5.00, 300.00, 140, 5000, '2025-03-18 08:00:00'),
(2, 'Walking', 45, 3.20, 200.00, 100, 6000, '2025-03-18 08:30:00'),
(3, 'Cycling', 60, 20.50, 500.00, 130, 8000, '2025-03-18 09:00:00'),
(4, 'Running', 25, 4.50, 250.00, 150, 4000, '2025-03-19 10:00:00'),
(5, 'Walking', 35, 2.80, 180.00, 95, 5500, '2025-03-19 10:30:00'),
(6, 'Cycling', 55, 18.00, 450.00, 120, 7500, '2025-03-19 11:00:00'),
(7, 'Running', 40, 6.00, 350.00, 145, 6000, '2025-03-20 07:00:00'),
(8, 'Walking', 50, 4.00, 220.00, 110, 7000, '2025-03-20 07:30:00'),
(9, 'Cycling', 70, 22.50, 550.00, 125, 9000, '2025-03-20 08:00:00'),
(10, 'Running', 20, 3.50, 200.00, 135, 4500, '2025-03-21 09:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fitness_records`
--
ALTER TABLE `fitness_records`
  ADD PRIMARY KEY (`record_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fitness_records`
--
ALTER TABLE `fitness_records`
  MODIFY `record_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
