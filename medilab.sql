-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 19, 2023 at 08:09 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `medilab`
--

-- --------------------------------------------------------

--
-- Table structure for table `ADMIN`
--

CREATE TABLE `ADMIN` (
  `admin_id` int(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `phone` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `book_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `booked_for` varchar(100) NOT NULL,
  `dependant_id` int(11) DEFAULT NULL,
  `test_id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `where_taken` text NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `lab_id` int(11) NOT NULL,
  `invoice_no` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dependants`
--

CREATE TABLE `dependants` (
  `dependant_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `surname` text NOT NULL,
  `others` text NOT NULL,
  `dob` date NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dependants`
--

INSERT INTO `dependants` (`dependant_id`, `member_id`, `surname`, `others`, `dob`, `reg_date`) VALUES
(2, 2, 'Ja', 'Mar', '2000-08-05', '2023-06-08 07:41:24'),
(3, 2, 'gg', 'Mar', '2000-08-05', '2023-06-08 07:49:39'),
(4, 2, 'gg', 'bob', '2000-08-05', '2023-06-08 07:49:59'),
(5, 3, 'Gloria', 'Monique', '2000-08-05', '2023-06-08 07:51:23'),
(6, 3, 'Alice', 'Shariffa', '2000-08-05', '2023-06-08 07:51:39');

-- --------------------------------------------------------

--
-- Table structure for table `laboratories`
--

CREATE TABLE `laboratories` (
  `lab_id` int(11) NOT NULL,
  `lab_name` text NOT NULL,
  `permit_id` varchar(100) DEFAULT NULL,
  `email` varchar(300) NOT NULL,
  `phone` varchar(200) NOT NULL,
  `password` varchar(200) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `laboratories`
--

INSERT INTO `laboratories` (`lab_id`, `lab_name`, `permit_id`, `email`, `phone`, `password`, `role`, `reg_date`) VALUES
(5, 'MnN', '2', 'MnN@gmail.com', 'gAAAAABkirjOZfpyxZL1skBlrwbCJ1CG8pQDfiuasnAadcy_QKfjTodI20O_6WcfrfB3EfvLYFXuGVhW-wU26bHTw3AjfrmtcA==', '$2b$12$uGMgvxGJJfZaawPtpH5IJO7jJ7vgFyQq1BJVzCsQJKIAS2ifhu6Um', 'admin', '2023-06-15 07:07:59');

-- --------------------------------------------------------

--
-- Table structure for table `lab_tests`
--

CREATE TABLE `lab_tests` (
  `test_id` int(11) NOT NULL,
  `lab_id` int(11) NOT NULL,
  `test_name` text NOT NULL,
  `test_description` text NOT NULL,
  `test_cost` int(11) NOT NULL,
  `test_discount` int(11) NOT NULL,
  `availability` text NOT NULL,
  `more_info` varchar(200) DEFAULT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lab_tests`
--

INSERT INTO `lab_tests` (`test_id`, `lab_id`, `test_name`, `test_description`, `test_cost`, `test_discount`, `availability`, `more_info`, `reg_date`) VALUES
(6, 5, 'Covid Test', 'Test is free', 500, 20, 'yes', 'available', '2023-06-15 09:28:14');

-- --------------------------------------------------------

--
-- Table structure for table `lab_test_allocations`
--

CREATE TABLE `lab_test_allocations` (
  `allocation_id` int(11) NOT NULL,
  `nurse_id` int(11) NOT NULL,
  `invoice_no` varchar(50) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `location_id` int(11) NOT NULL,
  `location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`location_id`, `location`) VALUES
(1, 'Nairobi'),
(2, 'Nakuru');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `member_id` int(11) NOT NULL,
  `surname` text NOT NULL,
  `others` text NOT NULL,
  `gender` text NOT NULL,
  `email` varchar(300) NOT NULL,
  `phone` varchar(500) NOT NULL,
  `dob` date NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `password` varchar(200) NOT NULL,
  `location_id` int(11) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`member_id`, `surname`, `others`, `gender`, `email`, `phone`, `dob`, `status`, `password`, `location_id`, `reg_date`) VALUES
(2, 'Jane', 'Mary', 'Female', 'gAAAAABkgDx_3DRuOX8lbOuy-9zeQsrGajz91YC1pUl7vfCk61cjsHSUZKBOfJDpt2_w_pdlEvCNGDMymyEpSlpJF-nlXio7Xk6bEr9Ee0AG15shRX5Qewk=', 'gAAAAABkgDx_TpmXnR5g66iZ10FQmH9atlxuJ1lwo1dFz3GFHscvYwMJxQHotE5Ls0TnFcgvpXWgHsuMBn1-rWBj6-Ew5DTIQA==', '2000-08-05', 1, '$2b$12$MV/JXTSS/rK76QaL9P1XV./PlZ9s2kHsK03s0DB6hTN5Yb69/enxe', 1, '2023-06-07 08:14:55'),
(3, 'Marcos', 'Noel', 'male', 'gAAAAABkgYhOfsgX8osYnJPx-G6EFAXi2axW153OwLEpqL2sawb0PbLxSSvssfTypZJgk9AIyGOTshBtHJbsZq2_afBnzaaLPGcWvPKb1g1eZ7xNtI4hrr8=', 'gAAAAABkgYhODNRtAmFx7GvmEFgudS_Rcv75TXsYU-_Wa8Oe_4kzUJ00P3akk9oACxBCOvJ27QmCNfSsH72C4btuxPrhaNIpXA==', '2000-08-05', 1, '$2b$12$V9kN8PG7Y5MR2RLtws6p8O7mmzhOC6k7ZYs88ruiz43uowYx/aZB.', 1, '2023-06-08 07:52:34'),
(4, 'Marcos', 'Noel', 'Female', 'gAAAAABkgY_JG19iJujhoqc4Rx-JCruyd5sXIQm3gzYqjheG3B8LbSpx50U2XWxzH2XR_5gylPwcgQrcN8a728OTQZ7x6yXeVI0GaKPZsxWfi2376bXM060=', 'gAAAAABkgY_J8hSkxTRExiG6X3JcbpY6uv7dKGrHSxTb-qwfEYKO9zIAJ3zMx_9A4TZjbYR8XhiM83Ne5LFc_BR9y25ziRnr7Q==', '2000-08-05', 1, '$2b$12$0qHCxUbeDhF9CEkAmb1eD.yL42fb1rlOY.D.J3DXxZdNOY7etuQYC', 1, '2023-06-08 08:22:34'),
(5, 'Marcos', 'Noel', 'Female', 'gAAAAABkgZoV-0daUjEW0X-NpQRYxdK01Th0UOQ1D4SoaSQlcIbMD3ZSBrGjrZDxOX3TIkscJeRYa1kiNxmEiTHiqyctkSrXahQARVcGMFBr58R1-Zup9AI=', 'gAAAAABkgZoVa5t4OfnzV94OsSeoiLl7LRN7KmKV1A2HkWx7nfK26PsTsXHKlh-KJ7aqemkqdrVkRjKsQQ_qcvUbOyNsx4P3Cg==', '2000-08-05', 1, '$2b$12$G5s6YDZNpOOC.U7zn3BBDO.aTHMlqcstCypsouh26fc6vh5ikTdtG', 1, '2023-06-08 09:06:29');

-- --------------------------------------------------------

--
-- Table structure for table `Nurses`
--

CREATE TABLE `Nurses` (
  `nurse_id` int(11) NOT NULL,
  `surname` text NOT NULL,
  `others` text NOT NULL,
  `lab_id` int(11) NOT NULL,
  `gender` text NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `invoice_no` varchar(100) NOT NULL,
  `total_amount` int(11) NOT NULL,
  `reg_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ADMIN`
--
ALTER TABLE `ADMIN`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `bookings_fk0` (`member_id`),
  ADD KEY `bookings_fk1` (`dependant_id`),
  ADD KEY `bookings_fk2` (`test_id`),
  ADD KEY `bookings_fk3` (`lab_id`),
  ADD KEY `invoice_no` (`invoice_no`);

--
-- Indexes for table `dependants`
--
ALTER TABLE `dependants`
  ADD PRIMARY KEY (`dependant_id`),
  ADD KEY `dependants_fk0` (`member_id`);

--
-- Indexes for table `laboratories`
--
ALTER TABLE `laboratories`
  ADD PRIMARY KEY (`lab_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `lab_tests`
--
ALTER TABLE `lab_tests`
  ADD PRIMARY KEY (`test_id`),
  ADD KEY `lab_tests_fk0` (`lab_id`);

--
-- Indexes for table `lab_test_allocations`
--
ALTER TABLE `lab_test_allocations`
  ADD PRIMARY KEY (`allocation_id`),
  ADD KEY `nurse_id` (`nurse_id`,`invoice_no`),
  ADD KEY `lab_test_allocations_fk1` (`invoice_no`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`location_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`member_id`),
  ADD KEY `members_fk0` (`location_id`);

--
-- Indexes for table `Nurses`
--
ALTER TABLE `Nurses`
  ADD PRIMARY KEY (`nurse_id`),
  ADD KEY `lab_id` (`lab_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `invoice_no` (`invoice_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ADMIN`
--
ALTER TABLE `ADMIN`
  MODIFY `admin_id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `dependants`
--
ALTER TABLE `dependants`
  MODIFY `dependant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `laboratories`
--
ALTER TABLE `laboratories`
  MODIFY `lab_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `lab_tests`
--
ALTER TABLE `lab_tests`
  MODIFY `test_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `lab_test_allocations`
--
ALTER TABLE `lab_test_allocations`
  MODIFY `allocation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `location_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `member_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Nurses`
--
ALTER TABLE `Nurses`
  MODIFY `nurse_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_fk0` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`),
  ADD CONSTRAINT `bookings_fk1` FOREIGN KEY (`dependant_id`) REFERENCES `dependants` (`dependant_id`),
  ADD CONSTRAINT `bookings_fk2` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`test_id`),
  ADD CONSTRAINT `bookings_fk3` FOREIGN KEY (`lab_id`) REFERENCES `laboratories` (`lab_id`);

--
-- Constraints for table `dependants`
--
ALTER TABLE `dependants`
  ADD CONSTRAINT `dependants_fk0` FOREIGN KEY (`member_id`) REFERENCES `members` (`member_id`);

--
-- Constraints for table `lab_tests`
--
ALTER TABLE `lab_tests`
  ADD CONSTRAINT `lab_tests_fk0` FOREIGN KEY (`lab_id`) REFERENCES `laboratories` (`lab_id`);

--
-- Constraints for table `lab_test_allocations`
--
ALTER TABLE `lab_test_allocations`
  ADD CONSTRAINT `lab_test_allocations_fk0` FOREIGN KEY (`nurse_id`) REFERENCES `Nurses` (`nurse_id`),
  ADD CONSTRAINT `lab_test_allocations_fk1` FOREIGN KEY (`invoice_no`) REFERENCES `bookings` (`invoice_no`);

--
-- Constraints for table `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_fk0` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`);

--
-- Constraints for table `Nurses`
--
ALTER TABLE `Nurses`
  ADD CONSTRAINT `Nurses_fk0` FOREIGN KEY (`lab_id`) REFERENCES `laboratories` (`lab_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
