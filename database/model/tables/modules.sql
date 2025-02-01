CREATE TABLE `modules` (
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `name` varchar(80) NOT NULL,
  `architecture` varchar(32) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `version` varchar(32) NOT NULL,
  `added` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `keywords` varchar(1024) DEFAULT NULL,
  `downloads` int(11) NOT NULL DEFAULT 0,
  `repository` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`name`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;