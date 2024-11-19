-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2024 at 09:19 AM
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
-- Database: `ahmad12`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `catogeryID` int(11) NOT NULL,
  `categoryName` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`catogeryID`, `categoryName`) VALUES
(1, 'Home'),
(2, 'gym subscribtion'),
(3, 'Food'),
(4, 'gas');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `expenseID` int(11) NOT NULL,
  `expenseDate` date NOT NULL,
  `amount` double NOT NULL,
  `notes` varchar(500) NOT NULL,
  `catogeryID` int(11) NOT NULL,
  `userID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`expenseID`, `expenseDate`, `amount`, `notes`, `catogeryID`, `userID`) VALUES
(1, '2024-11-20', 100, 'food', 1, 0),
(2, '2024-11-11', 50, 'gifts', 2, 0),
(3, '2019-11-12', 2000, 'rent', 2, 0),
(4, '2024-11-01', 300, 'gym subscribtion', 2, 0),
(5, '2024-11-20', 100, 'food', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `income`
--

CREATE TABLE `income` (
  `incomeID` int(11) NOT NULL,
  `amount` double NOT NULL,
  `incomeDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text NOT NULL,
  `userID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `income`
--

INSERT INTO `income` (`incomeID`, `amount`, `incomeDate`, `notes`, `userID`) VALUES
(1, 2000, '2024-11-10 09:48:17', 'monthly salary', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `firstName` varchar(500) NOT NULL,
  `lastName` varchar(500) NOT NULL,
  `password` varchar(500) NOT NULL,
  `createdDateTime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `firstName`, `lastName`, `password`, `createdDateTime`) VALUES
(1, 'Ahmad', 'AboMok', '123456789', '2024-11-02 07:22:51'),
(2, 'Muhammad', 'Majadly', 'Muhammad123', '2024-11-02 07:22:51'),
(3, 'Ahmad', 'AboMok', '123456789', '2024-11-02 07:22:51'),
(4, 'Muhammad', 'Majadly', 'Muhammad123', '2024-11-02 07:22:51'),
(5, 'Bob', 'momo', '123', '2024-11-16 06:43:35'),
(6, 'Bob', 'momo', '123', '2024-11-16 06:51:48'),
(7, 'ss', 'sss', 'ssss', '2024-11-16 07:38:59'),
(8, 'ss', 'sss', 'ssss', '2024-11-16 07:39:22'),
(9, 'ss', 'sss', 'ssss', '2024-11-16 07:39:38'),
(10, 'ss', 'sss', 'ssss', '2024-11-16 07:39:55'),
(11, 'abo', 'ahmad', 'pass', '2024-11-16 07:40:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`catogeryID`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`expenseID`);

--
-- Indexes for table `income`
--
ALTER TABLE `income`
  ADD PRIMARY KEY (`incomeID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `catogeryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `expenseID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `income`
--
ALTER TABLE `income`
  MODIFY `incomeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
