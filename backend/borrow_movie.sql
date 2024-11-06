-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 06, 2024 at 04:38 AM
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
-- Database: `borrow_movie`
--

-- --------------------------------------------------------

--
-- Table structure for table `asset`
--

CREATE TABLE `asset` (
  `asset_id` int(11) NOT NULL,
  `asset_name` varchar(30) NOT NULL,
  `asset_status` enum('available','pending','borrowed','disabled') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `categorie` enum('Adventure','Action','Comedy','Fantasy','Horror','Romance','Sci-Fi','Thriller','War') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `asset`
--

INSERT INTO `asset` (`asset_id`, `asset_name`, `asset_status`, `file_path`, `categorie`) VALUES
(1, 'john wick', 'available', '/assets/john_wick.jpg', 'Action'),
(2, 'mission_impossoble', 'available', '/assets/mission_impossoble.jpg', 'Action'),
(3, 'venom_2', 'disabled', '/assets/venom_2.jpg', 'Action'),
(4, 'workpoint', 'available', '/assets/workpoint.jpg', 'Action'),
(5, 'venom_1', 'available', '/assets/venom_1.jpg', 'Action');

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `history_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `borrower_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `returned_by` int(11) DEFAULT NULL,
  `return_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `request`
--

CREATE TABLE `request` (
  `request_id` int(11) NOT NULL,
  `asset_id` int(11) NOT NULL,
  `borrower_id` int(11) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date NOT NULL,
  `approve_status` enum('pending','approved','rejected') NOT NULL,
  `return_status` enum('not_returned','returned') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `request`
--

INSERT INTO `request` (`request_id`, `asset_id`, `borrower_id`, `borrow_date`, `return_date`, `approve_status`, `return_status`) VALUES
(1, 3, 1, '2024-11-05', '2024-11-06', 'approved', 'returned'),
(2, 2, 1, '2024-11-05', '2024-11-06', 'approved', 'returned');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(60) NOT NULL,
  `role` enum('student','admin','approver') NOT NULL,
  `name` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `password`, `role`, `name`, `email`) VALUES
(1, 'aaa', '$2a$10$RobtMCzNymCS4966hqUMQueyMZDoaVb/zKj.MfSl4oOZxpuLKS9Ru', 'student', 'plug', 'student@gmail.com'),
(2, 'bbb', '$2a$10$1DHe04ePQAn79BnLA.Z96uphdeIm9fnHT/9eyE/B33V.dFRaJ/L9i', 'student', 'staff', 'staff@gmail.com'),
(3, 'ccc', '$2a$10$YprDpUyP.vtBhIisoTciz.PYr9KHbhIcnPO1mp2BT/TPCR89lOqMC', 'student', 'approver', 'approver@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asset`
--
ALTER TABLE `asset`
  ADD PRIMARY KEY (`asset_id`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `borrower_id` (`borrower_id`),
  ADD KEY `request_id` (`request_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `returned_by` (`returned_by`);

--
-- Indexes for table `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `asset_id` (`asset_id`),
  ADD KEY `borrower_id` (`borrower_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `asset`
--
ALTER TABLE `asset`
  MODIFY `asset_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `request`
--
ALTER TABLE `request`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`asset_id`),
  ADD CONSTRAINT `history_ibfk_2` FOREIGN KEY (`borrower_id`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `history_ibfk_3` FOREIGN KEY (`request_id`) REFERENCES `request` (`request_id`),
  ADD CONSTRAINT `history_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`),
  ADD CONSTRAINT `history_ibfk_5` FOREIGN KEY (`returned_by`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `asset` (`asset_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
