-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 104.214.171.0:3306
-- Thời gian đã tạo: Th12 13, 2024 lúc 03:10 PM
-- Phiên bản máy phục vụ: 5.7.44
-- Phiên bản PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `ltw_user`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_data`
--

CREATE DATABASE IF NOT EXISTS ltw_user;
USE ltw_user;

CREATE TABLE `user_data` (
  `id` int(20) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `role` varchar(10) DEFAULT NULL,
  `email` varchar(25) NOT NULL,
  `time_allow` int(1) UNSIGNED NOT NULL DEFAULT '5',
  `last_time_blocked` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `user_data`
--

INSERT INTO `user_data` (`id`, `username`, `password`, `role`, `email`, `time_allow`, `last_time_blocked`) VALUES
(24, 'heheboi1', '12312312a', 'manager', 'fwef@gmail.com', 5, '2024-12-07 05:20:14'),
(25, 'johndoe1', '123123321', 'manager', 'johndoe@gmail.com', 5, '2024-12-10 18:42:46'),
(26, 'marysmith1', '123123123', 'manager', 'mary_smith@gmail.com', 5, '2024-12-07 19:46:44'),
(29, 'samueladams', '123secfesf', 'manager', 'samuel.adams@outlook.com', 5, NULL),
(45, 'cannguyen284', '02082004', 'manager', 'cannguyen1@gmail.com', 5, NULL),
(46, 'cannguyen2844', '02082004', 'manager', 'cannguyen2@gmail.com', 5, NULL),
(51, 'cannguyen123', '123123123', 'manager', 'cannguyen3@gmail.com', 6, '2024-12-07 05:19:38'),
(52, 'cannguyen1234', '123123123', 'publisher', 'cannguyen4@gmail.com', 5, NULL),
(59, 'test123cc', '12312312a', 'manager', 'testd@hcmut.com', 5, NULL),
(61, 'lmao1415', '123123123', 'manager', 'khang.tran@hcmut.edu.vn', 5, NULL),
(63, 'jondio123', '123123123', 'publisher', 'johndio@gmail.com', 5, NULL),
(65, 'khangtran', '123123123', 'publisher', 'khang.trancc@gmail.com', 5, NULL),
(70, 'khangtran12a', '123123123a', NULL, 'khang.trane@hcmut.edu.vn', 5, '2024-12-12 14:17:53'),
(74, 'lmao14159', '123123123', 'publisher', 'test23@gmail.com', 5, NULL),
(75, 'thailydeptrai', '12345678', 'publisher', 'lyvinhthai321@gmail.com', 5, NULL),
(76, 'toan123456', 'toan789520', NULL, 'toan01224551919@gmail.com', 5, NULL),
(78, 'khangtran1', '123123123', NULL, 'khang.tran@gmail.com', 5, NULL),
(79, 'khangtranwef', '123123123', NULL, 'gmail@hcmut.edu.vn', 5, NULL);

--
-- Bẫy `user_data`
--
DELIMITER $$
CREATE TRIGGER `after_user_data_insert` AFTER INSERT ON `user_data` FOR EACH ROW BEGIN
  INSERT INTO user_info (user_id, display_name)
  VALUES (NEW.id, 'little monkey');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete` AFTER DELETE ON `user_data` FOR EACH ROW BEGIN
    IF OLD.role = 'manager' THEN
    	SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Manager khong the bi xoa';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert` BEFORE INSERT ON `user_data` FOR EACH ROW BEGIN
  IF NOT NEW.password REGEXP '^[a-zA-Z0-9]{8,15}$' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password must be between 8 and 15 characters and contain only letters and numbers.';
  END IF;

IF NOT NEW.username REGEXP '^[a-zA-Z0-9]{8,15}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Username must be between 8 and 15 characters and contain no special characters.';
    END IF;

IF NOT NEW.email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$' THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Email is not valid.';
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update` BEFORE UPDATE ON `user_data` FOR EACH ROW BEGIN
	IF NOT NEW.password REGEXP '^[a-zA-Z0-9]{8,15}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Password must be between 8 and 15 characters and contain only letters and numbers.';
    END IF;
    
    IF NOT NEW.email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Email is not valid.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_role` BEFORE UPDATE ON `user_data` FOR EACH ROW BEGIN
    	IF NEW.role != 'publisher' AND NEW.role != 'manager' THEN
        	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Role phai la publisher hoac manager';
        END IF;
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_time_allow` BEFORE UPDATE ON `user_data` FOR EACH ROW BEGIN
    IF NEW.time_allow = 0 THEN
        SET NEW.last_time_blocked = NOW();
        SET NEW.time_allow = 6;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_info`
--

CREATE TABLE `user_info` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `display_name` varchar(25) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `img_url` varchar(255) NOT NULL DEFAULT 'https://cdn-icons-png.flaticon.com/128/149/149071.png',
  `vip_level` int(11) NOT NULL DEFAULT '0',
  `credits` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Đang đổ dữ liệu cho bảng `user_info`
--

INSERT INTO `user_info` (`user_id`, `display_name`, `img_url`, `vip_level`, `credits`) VALUES
(24, 'big mÄƒn kÃ¬', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 5001),
(25, 'John Doe', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 2124),
(26, 'little monkey', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 49980),
(29, 'cho can thieu nang', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 180),
(45, 'little monkey', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 0),
(46, 'little monkey', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 0),
(51, 'little monkey', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 0),
(52, 'Cấn Nguyên 4', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 9955),
(59, 'little monkey', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 0),
(61, 'little monkey', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 0),
(63, 'John Dio', 'https://i.pinimg.com/474x/eb/43/82/eb43822479ccfc4b12b670b5d06c2132.jpg', 0, 119),
(65, 'little monkeyyy', 'https://cdn-icons-png.flaticon.com/128/149/149071.png', 0, 485),
(70, 'little monkey', 'https://i.sstatic.net/l60Hf.png', 0, 5),
(74, 'little monkey', 'https://i.pinimg.com/474x/0e/d7/32/0ed7322dcfed454f7b0b4067b97f9b21.jpg', 0, 0),
(75, 'little monkey', 'https://i.sstatic.net/l60Hf.png', 0, 570),
(76, 'little monkey', 'https://i.sstatic.net/l60Hf.png', 0, 0),
(78, 'little monkey', 'active', 0, 0),
(79, 'displayname', 'https://i.pinimg.com/474x/13/7f/3c/137f3c467d17f32dfcbb510765770729.jpg', 0, 490);

--
-- Bẫy `user_info`
--
DELIMITER $$
CREATE TRIGGER `before_update_credits` BEFORE UPDATE ON `user_info` FOR EACH ROW BEGIN
    IF NEW.credits < 0 THEN
    	SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Thanh toan that bai';
    END IF;

INSERT INTO ltw_history.payment (user_id, amount)
    VALUES (NEW.user_id, NEW.credits - OLD.credits);
END
$$
DELIMITER ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `user_data`
--
ALTER TABLE `user_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `username` (`username`) USING BTREE,
  ADD UNIQUE KEY `email` (`email`) USING BTREE;

--
-- Chỉ mục cho bảng `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `unique_user_foreign` (`user_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `user_data`
--
ALTER TABLE `user_data`
  MODIFY `id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `user_info`
--
ALTER TABLE `user_info`
  ADD CONSTRAINT `khoa_cua_user` FOREIGN KEY (`user_id`) REFERENCES `user_data` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
