SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

CREATE DATABASE IF NOT EXISTS `swifiic` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `swifiic`;

DROP TABLE IF EXISTS `App`;
CREATE TABLE IF NOT EXISTS `App` (
  `AppId` varchar(64) NOT NULL DEFAULT '',
  `AppName` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`AppId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `AppLedger`;
CREATE TABLE IF NOT EXISTS `AppLedger` (
  `LogId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `EventNotes` varchar(256) DEFAULT NULL,
  `ReqUserId` int(11) DEFAULT NULL,
  `ReqAppId` int(11) DEFAULT NULL,
  `ReqAppRole` varchar(64) DEFAULT NULL,
  `ReqDeviceId` int(11) DEFAULT NULL,
  `CreditDeviceId` int(11) DEFAULT NULL,
  `DebitDeviceId` int(11) DEFAULT NULL,
  `Details` varchar(1024) DEFAULT NULL,
  `TimeReq` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `TimeCommitted` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ReqOrCommitID` bigint(20) DEFAULT NULL,
  `DevSeqId` bigint(20) DEFAULT NULL,
  `Value` int(11) DEFAULT NULL,
  `Status` enum('audited','success','failed','aborted','commit-pending','ack-pending','others') DEFAULT NULL,
  `StatusNotes` varchar(64) DEFAULT NULL,
  `AlibiDevDetails` varchar(256) DEFAULT NULL,
  `AuditLogId` bigint(20) DEFAULT NULL,
  `AuditNotes` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LogId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `AppUserMaps`;
CREATE TABLE IF NOT EXISTS `AppUserMaps` (
  `AppId` varchar(64) NOT NULL DEFAULT '',
  `UserId` int(11) NOT NULL DEFAULT '0',
  `Role` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`AppId`,`UserId`,`Role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Audit`;
CREATE TABLE IF NOT EXISTS `Audit` (
  `AuditId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `AuditNotes` varchar(256) DEFAULT NULL,
  `StartedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CompletedAt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `FirstAffectedOperatorLogId` bigint(20) unsigned DEFAULT NULL,
  `LastAffectedOperatorLogId` bigint(20) unsigned DEFAULT NULL,
  `NumAffectedOperatorLogId` int(10) unsigned DEFAULT NULL,
  `FirstAffectedAppLogId` bigint(20) unsigned DEFAULT NULL,
  `LastAffectedAppLogId` bigint(20) unsigned DEFAULT NULL,
  `NumAffectedAppLogId` int(10) unsigned DEFAULT NULL,
  `NumValueTransfers` int(10) unsigned DEFAULT NULL,
  `TotalValueTransferAmount` int(10) unsigned DEFAULT NULL,
  `AuditType` enum('periodic','user-requested','billing','others') DEFAULT NULL,
  PRIMARY KEY (`AuditId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `Device`;
CREATE TABLE IF NOT EXISTS `Device` (
  `DeviceID` int(11) NOT NULL AUTO_INCREMENT,
  `MAC` varchar(64) DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `CreatedLedgerEntry` bigint(20) DEFAULT NULL,
  `Notes` varchar(64) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `PeriodicAuditTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `PeriodicAuditNotes` varchar(256) DEFAULT NULL,
  `LastAuditedActiveityAt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`DeviceID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;


DROP TABLE IF EXISTS `OperatorLedger`;
CREATE TABLE IF NOT EXISTS `OperatorLedger` (
  `LogId` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `EventNotes` varchar(256) DEFAULT NULL,
  `ReqUserId` int(11) DEFAULT NULL,
  `ReqDeviceId` int(11) DEFAULT NULL,
  `Details` varchar(1024) DEFAULT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `AuditLogId` bigint(20) DEFAULT NULL,
  `AuditNotes` bigint(20) DEFAULT NULL,
  `CreditUserId` int(11) DEFAULT NULL,
  `DebitUserId` int(11) DEFAULT NULL,
  `Amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`LogId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=269 ;



DROP TABLE IF EXISTS `User`;
CREATE TABLE IF NOT EXISTS `User` (
  `UserId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(64) DEFAULT NULL,
  `EmailAddress` varchar(64) DEFAULT NULL,
  `MobileNumber` varchar(32) DEFAULT NULL,
  `Address` varchar(256) DEFAULT NULL,
  `AddressVerificationNotes` varchar(256) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `CreatedLedgerId` bigint(20) DEFAULT NULL,
  `RemainingCreditPostAudit` int(11) DEFAULT NULL,
  `Status` enum('active','suspended','deleted','operator') DEFAULT NULL,
  `Password` varchar(128) DEFAULT NULL,
  `ImageFile` blob,
  `IdProofFile` blob,
  `AddrProofFile` blob,
  `Alias` varchar(32) DEFAULT NULL,
  `ProfilePic` blob,
  `LastAuditedActivityAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DtnId` varchar(64) DEFAULT NULL,
  `MacAddress` varchar(64) DEFAULT NULL,
  `TimeOfLastUpdateFromApp` datetime DEFAULT NULL,
  PRIMARY KEY (`UserId`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

INSERT INTO `User` (`UserId`, `Name`, `EmailAddress`, `MobileNumber`, `Address`, `AddressVerificationNotes`, `CreateTime`, `CreatedLedgerId`, `RemainingCreditPostAudit`, `Status`, `Password`, `ImageFile`, `IdProofFile`, `AddrProofFile`, `Alias`, `ProfilePic`, `LastAuditedActivityAt`, `DtnId`, `MacAddress`, `TimeOfLastUpdateFromApp`) VALUES
(3, 'SWiFiIC Operator', 'temp@gmail.com', '9876543210', 'India', 'Default', now(), 0, 0, 'operator', 'simple', 0xffd8ffe000104a46494600010100000100010000ffdb00840009060712131214140e141415141714141414161714151717181e141c181718151618191f2a201a1a251b171422312231292b2e2e2f171f3338362c3734393a2d010a0a0a0e0d0e1b10101b2c242025342c2c2c2c2f2c2c2c342c2c342c2c3734302d2c342c2c2c2c2f2c2c342c2e2c2c2c2c2c2c2c342c2c342f2c2c2b2b2c2c2cffc00011080066006603011100021101031101ffc4001b00000202030100000000000000000000000004050601030702ffc4003d100001030202060606070900000000000001000203041105210612314161711314325191a10722425281c115232462d2f0f13343537283a2b1d1e1ffc400190101000301010000000000000000000000000203040501ffc4002f110002010303020307040300000000000000010203111204213113413251810514225261a1b13371c1f05391d1ffda000c03010002110311003f00ee2801002023f1dc661a488cb50eb346407b4e3b9ad1bcab295295596312152a469c729150d5c4310f5a490d1539d91b3399c3ef3b2d5b8fd16fb50a1b2594bec63bd5adbdf15f719a5d01c3dbdb63e43bdcf9092798160a32d7577c597a1ead2525cddfa9eea74130d70ca22d3ded7b87fc5e475b5d77fb1ebd2517d84be87aea2f5b0ea874f18ccd3cf99b7731ff00a29f528d6daa4717e688a855a5e095d7932c9a2fa4d15634ea831cac369627769a7e638ac75f4f2a2ecf8eccd346b46aadb9ee89c5417020040080100203cc8f0012e20000924ec006d2512b83975155fd2158eaa9738a23ab4cc3b067db23bcdafe0bb5d3e852c172f93959f5aa64f85c16ceb6b26068cccf5b4c0f730eb6980ccc1ab4c0f332ada50d745232b69b2998407db63dbdceefcb2f05ae8c54e0e94b8edf433d596125523c9d0b04c4d9530b268f6385eddc7783c8ae45483849c5f63a709a9c5490f2812040080100202b1e922b4c7412eaed935621fd4363e575af450cab2fa6e67d54b1a4ca7e0368da58385be192eb5757b339749db6261b32cee25d91b04aa389ee40654c4647874ca4a279911d8b4b766af791e4aea31b4ae5756578d87fd17551699e03b1aed76f276df307c561f68c6d514bcd1b7432bc1af23a02e71b410020040080a6fa541f6369dc27889f15bbd9ff00ade8cc9acfd2ff00456e18b3c9751b39691211b4aa5d8b11bdac2a373d02c29706891a54958f18854464ed574590639a023edb35bf86dbf9ac1ed17e1f537e856cce92b986f0400801002021b4bf0ceb1493443b4584b79b731e615b42a74ea2915d586707128ba3f374b135ded0f55e378737220f15d9a9b338f15727218150e44d21a653aadc89d8cba9d148585668158a445a236ad81a093b00baba2ee56d0efa33a427a5a870edbbd5e4321f9e2b9baca99d5b2e16c7534b0c69fefb97b590d008010020040080e73a4b873e86a0d4c2d2e824379da3d93ef85d2d356538f4a5cf67fc1835345c5f523ebff49dc2e68a6607c4e0e07b8f91e2bca8a50766571b4b824d94ca9732c54d997d32f14c3a6c46aa36b412e5741b96c8ae49229d56e756cbd053671dfeb1e365b7b415656abd18e2bc4fec4a8d1ea3bbe3f274ac3285b0c6d8d9b1a2cb9674469002004008010020397e97634eae98d3d393d5a376abcb7f7cf1ec03ee0fcee5d9d269d528f527cfe11cbd5577378478fc8f61ba3ad886b3247324fb86cd1c2dbd79535193b5b610a365cee4b455956ccaf1483bc82d3f1b1b792a1c294bcd1627389edf88553b2d589bc733f3454e92f33d729b12abc33a66913cae24ecd5c80e6378e0ac8d6c1fc288ba49add95ec3677e1d517b5e17102468d96dcf67fa57d6a51d4c2eb9feec5346a4a84ecf83a9d3ced7b4398416b80208e2b88d34ecceba77362f002004008010153f4858cba285b0406d3d412c69dec68edc9c2c0f9ad9a2a2a73ca5c232eaaae11b2e595dc028d9101aa3268d56fccf35d1ad26f639f495b726c4cb3625f91eba65e627b9074c988c8c19d7b89e644762cc0f667b47e48575178b2babf1218d02c4cc6e34b21cb37444f76f6acfafa3bf517a9a74756eb07e85ed734dc0801002004072aa8aaeb5573d46d603d5e0eed56769c39bbe6bb9461d3a6a3df9671ebcf39b7e887a0160bd96e416c32d2556c95cf762bcd85d858a6c2ecf0e257a2e6894953445b232a2ec736467698e0e1f30ac9454e2e2fb9e425849491d3f0eaa12c6c7b763802b8124d3b33b69dd5d0caf0f41002021f4bb11eaf473c80d9c18433f99deab6df13e4aed3d3ea558c4aab4f0a6d948c328ba38a38fdd600799ccf992bb1295db67212b6c494512a9b2490cb22506c958da2151c8f6c64c2990b1a9f1292679615922534c8b4273c57042b1322d160d03a9faa74476b1c6dc8ae6eb618d5bf9ee74f4b2ca9fec5a56434820040543d241bc74d17b3255c4d7710dbbade202dda15f1c9f92664d63f812f362a6137bf1cd6ac8c4e26f8a3506c21c8e255b64d2186c2a191ed81d0a642c2f244a699e34292c6ac4c8b42ae814f23cc4ce8ac9ab56e68d8e07c951ae578c59ab46f768bd2e71b81002021b4b3041570165ece043e370dad737610ada359d29e48aead355238b2994b8f3e03d1e251b9ae1974ad6ddaee240f92e82c2aef4dfa339ee33a7e35ea59286a60945e2918ee4e17f88da1553538f28947197049329952e64fa66e6c0a2e64d5307408a61d334c94ea6a641c04aa351bda23c55b1ca5c106a2882c4f18637d56664ec033279056da34f7a8cf14653da2890d0ec224d733ce356e2cc6efcf79e2b16a2bbaafe8b836d1a4a9afa97059cb8100200402b5b87c528b4ac0e1c4202b35ba014ee3788ba33c0abe1a9ab0d94bf92a950a72e511efd1baa8bf6554e039bd59ef6df8a29fa10f764b86d1af5b106e5d601e64fe15e7bc43fc687425f3b33d3d7ef99be27f0a7bc43e4479d07f3336c7435926d9dbfde53de9af0c523df768f76c760d107bb39a7711dcdf57fc66a12d4d597726a8c17626f0dd1da7873630177bc733e6a86ee5a4b040080101fffd9, 0xffd8ffe000104a46494600010100000100010000ffdb00840009060712131214140e141415141714141414161714151717181e141c181718151618191f2a201a1a251b171422312231292b2e2e2f171f3338362c3734393a2d010a0a0a0e0d0e1b10101b2c242025342c2c2c2c2f2c2c2c342c2c342c2c3734302d2c342c2c2c2c2f2c2c342c2e2c2c2c2c2c2c2c342c2c342f2c2c2b2b2c2c2cffc00011080066006603011100021101031101ffc4001b00000202030100000000000000000000000004050601030702ffc4003d100001030202060606070900000000000001000203041105210612314161711314325191a10722425281c115232462d2f0f13343537283a2b1d1e1ffc400190101000301010000000000000000000000000203040501ffc4002f110002010303020307040300000000000000010203111204213113413251810514225261a1b13371c1f05391d1ffda000c03010002110311003f00ee2801002023f1dc661a488cb50eb346407b4e3b9ad1bcab295295596312152a469c729150d5c4310f5a490d1539d91b3399c3ef3b2d5b8fd16fb50a1b2594bec63bd5adbdf15f719a5d01c3dbdb63e43bdcf9092798160a32d7577c597a1ead2525cddfa9eea74130d70ca22d3ded7b87fc5e475b5d77fb1ebd2517d84be87aea2f5b0ea874f18ccd3cf99b7731ff00a29f528d6daa4717e688a855a5e095d7932c9a2fa4d15634ea831cac369627769a7e638ac75f4f2a2ecf8eccd346b46aadb9ee89c5417020040080100203cc8f0012e20000924ec006d2512b83975155fd2158eaa9738a23ab4cc3b067db23bcdafe0bb5d3e852c172f93959f5aa64f85c16ceb6b26068cccf5b4c0f730eb6980ccc1ab4c0f332ada50d745232b69b2998407db63dbdceefcb2f05ae8c54e0e94b8edf433d596125523c9d0b04c4d9530b268f6385eddc7783c8ae45483849c5f63a709a9c5490f2812040080100202b1e922b4c7412eaed935621fd4363e575af450cab2fa6e67d54b1a4ca7e0368da58385be192eb5757b339749db6261b32cee25d91b04aa389ee40654c4647874ca4a279911d8b4b766af791e4aea31b4ae5756578d87fd17551699e03b1aed76f276df307c561f68c6d514bcd1b7432bc1af23a02e71b410020040080a6fa541f6369dc27889f15bbd9ff00ade8cc9acfd2ff00456e18b3c9751b39691211b4aa5d8b11bdac2a373d02c29706891a54958f18854464ed574590639a023edb35bf86dbf9ac1ed17e1f537e856cce92b986f0400801002021b4bf0ceb1493443b4584b79b731e615b42a74ea2915d586707128ba3f374b135ded0f55e378737220f15d9a9b338f15727218150e44d21a653aadc89d8cba9d148585668158a445a236ad81a093b00baba2ee56d0efa33a427a5a870edbbd5e4321f9e2b9baca99d5b2e16c7534b0c69fefb97b590d008010020040080e73a4b873e86a0d4c2d2e824379da3d93ef85d2d356538f4a5cf67fc1835345c5f523ebff49dc2e68a6607c4e0e07b8f91e2bca8a50766571b4b824d94ca9732c54d997d32f14c3a6c46aa36b412e5741b96c8ae49229d56e756cbd053671dfeb1e365b7b415656abd18e2bc4fec4a8d1ea3bbe3f274ac3285b0c6d8d9b1a2cb9674469002004008010020397e97634eae98d3d393d5a376abcb7f7cf1ec03ee0fcee5d9d269d528f527cfe11cbd5577378478fc8f61ba3ad886b3247324fb86cd1c2dbd79535193b5b610a365cee4b455956ccaf1483bc82d3f1b1b792a1c294bcd1627389edf88553b2d589bc733f3454e92f33d729b12abc33a66913cae24ecd5c80e6378e0ac8d6c1fc288ba49add95ec3677e1d517b5e17102468d96dcf67fa57d6a51d4c2eb9feec5346a4a84ecf83a9d3ced7b4398416b80208e2b88d34ecceba77362f002004008010153f4858cba285b0406d3d412c69dec68edc9c2c0f9ad9a2a2a73ca5c232eaaae11b2e595dc028d9101aa3268d56fccf35d1ad26f639f495b726c4cb3625f91eba65e627b9074c988c8c19d7b89e644762cc0f667b47e48575178b2babf1218d02c4cc6e34b21cb37444f76f6acfafa3bf517a9a74756eb07e85ed734dc0801002004072aa8aaeb5573d46d603d5e0eed56769c39bbe6bb9461d3a6a3df9671ebcf39b7e887a0160bd96e416c32d2556c95cf762bcd85d858a6c2ecf0e257a2e6894953445b232a2ec736467698e0e1f30ac9454e2e2fb9e425849491d3f0eaa12c6c7b763802b8124d3b33b69dd5d0caf0f41002021f4bb11eaf473c80d9c18433f99deab6df13e4aed3d3ea558c4aab4f0a6d948c328ba38a38fdd600799ccf992bb1295db67212b6c494512a9b2490cb22506c958da2151c8f6c64c2990b1a9f1292679615922534c8b4273c57042b1322d160d03a9faa74476b1c6dc8ae6eb618d5bf9ee74f4b2ca9fec5a56434820040543d241bc74d17b3255c4d7710dbbade202dda15f1c9f92664d63f812f362a6137bf1cd6ac8c4e26f8a3506c21c8e255b64d2186c2a191ed81d0a642c2f244a699e34292c6ac4c8b42ae814f23cc4ce8ac9ab56e68d8e07c951ae578c59ab46f768bd2e71b81002021b4b3041570165ece043e370dad737610ada359d29e48aead355238b2994b8f3e03d1e251b9ae1974ad6ddaee240f92e82c2aef4dfa339ee33a7e35ea59286a60945e2918ee4e17f88da1553538f28947197049329952e64fa66e6c0a2e64d5307408a61d334c94ea6a641c04aa351bda23c55b1ca5c106a2882c4f18637d56664ec033279056da34f7a8cf14653da2890d0ec224d733ce356e2cc6efcf79e2b16a2bbaafe8b836d1a4a9afa97059cb8100200402b5b87c528b4ac0e1c4202b35ba014ee3788ba33c0abe1a9ab0d94bf92a950a72e511efd1baa8bf6554e039bd59ef6df8a29fa10f764b86d1af5b106e5d601e64fe15e7bc43fc687425f3b33d3d7ef99be27f0a7bc43e4479d07f3336c7435926d9dbfde53de9af0c523df768f76c760d107bb39a7711dcdf57fc66a12d4d597726a8c17626f0dd1da7873630177bc733e6a86ee5a4b040080101fffd9, 0xffd8ffe000104a46494600010100000100010000ffdb00840009060712131214140e141415141714141414161714151717181e141c181718151618191f2a201a1a251b171422312231292b2e2e2f171f3338362c3734393a2d010a0a0a0e0d0e1b10101b2c242025342c2c2c2c2f2c2c2c342c2c342c2c3734302d2c342c2c2c2c2f2c2c342c2e2c2c2c2c2c2c2c342c2c342f2c2c2b2b2c2c2cffc00011080066006603011100021101031101ffc4001b00000202030100000000000000000000000004050601030702ffc4003d100001030202060606070900000000000001000203041105210612314161711314325191a10722425281c115232462d2f0f13343537283a2b1d1e1ffc400190101000301010000000000000000000000000203040501ffc4002f110002010303020307040300000000000000010203111204213113413251810514225261a1b13371c1f05391d1ffda000c03010002110311003f00ee2801002023f1dc661a488cb50eb346407b4e3b9ad1bcab295295596312152a469c729150d5c4310f5a490d1539d91b3399c3ef3b2d5b8fd16fb50a1b2594bec63bd5adbdf15f719a5d01c3dbdb63e43bdcf9092798160a32d7577c597a1ead2525cddfa9eea74130d70ca22d3ded7b87fc5e475b5d77fb1ebd2517d84be87aea2f5b0ea874f18ccd3cf99b7731ff00a29f528d6daa4717e688a855a5e095d7932c9a2fa4d15634ea831cac369627769a7e638ac75f4f2a2ecf8eccd346b46aadb9ee89c5417020040080100203cc8f0012e20000924ec006d2512b83975155fd2158eaa9738a23ab4cc3b067db23bcdafe0bb5d3e852c172f93959f5aa64f85c16ceb6b26068cccf5b4c0f730eb6980ccc1ab4c0f332ada50d745232b69b2998407db63dbdceefcb2f05ae8c54e0e94b8edf433d596125523c9d0b04c4d9530b268f6385eddc7783c8ae45483849c5f63a709a9c5490f2812040080100202b1e922b4c7412eaed935621fd4363e575af450cab2fa6e67d54b1a4ca7e0368da58385be192eb5757b339749db6261b32cee25d91b04aa389ee40654c4647874ca4a279911d8b4b766af791e4aea31b4ae5756578d87fd17551699e03b1aed76f276df307c561f68c6d514bcd1b7432bc1af23a02e71b410020040080a6fa541f6369dc27889f15bbd9ff00ade8cc9acfd2ff00456e18b3c9751b39691211b4aa5d8b11bdac2a373d02c29706891a54958f18854464ed574590639a023edb35bf86dbf9ac1ed17e1f537e856cce92b986f0400801002021b4bf0ceb1493443b4584b79b731e615b42a74ea2915d586707128ba3f374b135ded0f55e378737220f15d9a9b338f15727218150e44d21a653aadc89d8cba9d148585668158a445a236ad81a093b00baba2ee56d0efa33a427a5a870edbbd5e4321f9e2b9baca99d5b2e16c7534b0c69fefb97b590d008010020040080e73a4b873e86a0d4c2d2e824379da3d93ef85d2d356538f4a5cf67fc1835345c5f523ebff49dc2e68a6607c4e0e07b8f91e2bca8a50766571b4b824d94ca9732c54d997d32f14c3a6c46aa36b412e5741b96c8ae49229d56e756cbd053671dfeb1e365b7b415656abd18e2bc4fec4a8d1ea3bbe3f274ac3285b0c6d8d9b1a2cb9674469002004008010020397e97634eae98d3d393d5a376abcb7f7cf1ec03ee0fcee5d9d269d528f527cfe11cbd5577378478fc8f61ba3ad886b3247324fb86cd1c2dbd79535193b5b610a365cee4b455956ccaf1483bc82d3f1b1b792a1c294bcd1627389edf88553b2d589bc733f3454e92f33d729b12abc33a66913cae24ecd5c80e6378e0ac8d6c1fc288ba49add95ec3677e1d517b5e17102468d96dcf67fa57d6a51d4c2eb9feec5346a4a84ecf83a9d3ced7b4398416b80208e2b88d34ecceba77362f002004008010153f4858cba285b0406d3d412c69dec68edc9c2c0f9ad9a2a2a73ca5c232eaaae11b2e595dc028d9101aa3268d56fccf35d1ad26f639f495b726c4cb3625f91eba65e627b9074c988c8c19d7b89e644762cc0f667b47e48575178b2babf1218d02c4cc6e34b21cb37444f76f6acfafa3bf517a9a74756eb07e85ed734dc0801002004072aa8aaeb5573d46d603d5e0eed56769c39bbe6bb9461d3a6a3df9671ebcf39b7e887a0160bd96e416c32d2556c95cf762bcd85d858a6c2ecf0e257a2e6894953445b232a2ec736467698e0e1f30ac9454e2e2fb9e425849491d3f0eaa12c6c7b763802b8124d3b33b69dd5d0caf0f41002021f4bb11eaf473c80d9c18433f99deab6df13e4aed3d3ea558c4aab4f0a6d948c328ba38a38fdd600799ccf992bb1295db67212b6c494512a9b2490cb22506c958da2151c8f6c64c2990b1a9f1292679615922534c8b4273c57042b1322d160d03a9faa74476b1c6dc8ae6eb618d5bf9ee74f4b2ca9fec5a56434820040543d241bc74d17b3255c4d7710dbbade202dda15f1c9f92664d63f812f362a6137bf1cd6ac8c4e26f8a3506c21c8e255b64d2186c2a191ed81d0a642c2f244a699e34292c6ac4c8b42ae814f23cc4ce8ac9ab56e68d8e07c951ae578c59ab46f768bd2e71b81002021b4b3041570165ece043e370dad737610ada359d29e48aead355238b2994b8f3e03d1e251b9ae1974ad6ddaee240f92e82c2aef4dfa339ee33a7e35ea59286a60945e2918ee4e17f88da1553538f28947197049329952e64fa66e6c0a2e64d5307408a61d334c94ea6a641c04aa351bda23c55b1ca5c106a2882c4f18637d56664ec033279056da34f7a8cf14653da2890d0ec224d733ce356e2cc6efcf79e2b16a2bbaafe8b836d1a4a9afa97059cb8100200402b5b87c528b4ac0e1c4202b35ba014ee3788ba33c0abe1a9ab0d94bf92a950a72e511efd1baa8bf6554e039bd59ef6df8a29fa10f764b86d1af5b106e5d601e64fe15e7bc43fc687425f3b33d3d7ef99be27f0a7bc43e4479d07f3336c7435926d9dbfde53de9af0c523df768f76c760d107bb39a7711dcdf57fc66a12d4d597726a8c17626f0dd1da7873630177bc733e6a86ee5a4b040080101fffd9, 'operator', 0xffd8ffe000104a46494600010100000100010000ffdb0084000906070807121412101316161417151a1b18181512191e1c1817161917251b19181c2021282c1f2228271f1f24362d27292b2e2f2e1c2b3338332c37282f3032010a0a0a0505050e05050e2b1913192b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2bffc00011080066006603012200021101031101ffc4001c0001000203010101000000000000000000000608040507010302ffc4003a100001030203040704090501000000000001000203041105063107122161133241517181b1224272a13373829192b2c1d2d315236274c214ffc40014010100000000000000000000000000000000ffc40014110100000000000000000000000000000000ffda000c03010002110311003f00ee28888088b4f9b71b665ea496a0f12d6d980f6bddc1a3ef41a7cf19f6872b0e8da3a5a822e2306c1a0e8e79ecf0d4f2d5722c5f68199b1426f3ba369f761f600f31c7e6a3957533d6bdd24ae2e7bc92e71d492be48362ccc18db0dc55d45ffd993f7293603b51cc186102670a867689383adc9e07a82a10882cee58cc987e668ba581da707b0f598eee70fd742b70ab2e4dcc3365aaa64cd2772e1b2b7b1d193c7cc6a3985662291b280e69b82010791d107e911101111011110172fdbb55be3829a20783e4738f3e8da2df997505c9b6f50b88a37f6032b7cdc2323f2941c8d11101111078ac96ce6adf5d86d2bdc6e7a3dd27eadce6fe8ab72b11b2985d06154c0f6891de4f96423d504b511101111011110142f6b785ff0052c3e4701ed424483c07077c895345f39e18ea1ae63c02d7021c0e8411620a0a9c8b739bf01932dd5494e6fba0de327de8ddd53cfb8f30b4c8088883f74f0bea5ed637ace7068f171b0569b07a166190450b748e36b47d9002e31b1ccb7fd4ea4d5483fb701f67b9d291c3f08e3e365dcd0111101111011110111104576879561ccd4c6c2d3c60ba270d6f6ea1e47d78aae60df8ab179cb3c61597e37b448d7d46e9dd89a6e4388e05f6ea8f1f255d00b20f567e03863f1aa9869da6c64786dfb86ae3e4013e4b016db2962acc0eb29ea1c2ed8dfed5871dd735cd75b9d9c50591c170aa4c161641036cc60b0ef27b49ef27559cb0309c6b0cc65bbf4d33241dbbae171c9c3507c567a02222022220222e61b4fda04b8638d251bad2dbfb920f72e3aadff2e7d882499b73ee0f96aec73ba49adf46c22e3e33a37cf8f25c8330ed0f306397064e8633ee4571c39bb53f21c9455ce73c9249249b924dc927b495e202222022220fa52d4cf48e0f89ee63c68e6b883f7853dcb7b56c630f21b5404f1f7f0120f03a3bcc79ae7c882cf65dccb8566366fd3481c47598783dbf137f5d16dd553c3710abc2e46cb03cb246e8e1e87bc722ac06cf738c79aa13bc03678ec2468d0df47b791f91412c4444055367aa92b9ce95fd69097bbc5c6e7d55b255df3f64cadcb933dec639d4ce712c78170d04f51ddd6e7a8f3411244440444404444044440530d9255494f8a40d6e920918ef0113ddeac0a1e38aeb5b21c9b594d2ff00eea961659a444d70b38ef0b1791d82d702fadefdc83ada22202fcbd8d9010e0083a8238144410fc5f665963123bc2230bbbe176e8fc1c5bf700a2f5bb1869fa1ab23eb22bfa1088834f51b22c6a33eccf01f1df1ff00256054eccb1ea7d5f4fe5249fc6bc44184cc8d8b3cee87437f8dff00b16c60d96e3f371e929adf5927f1af51067d2ec7f1697af510b7e16bddea1ab7741b1aa36fd3d4bddc98c0df99ba2209860591b2ee0443a280178f7e425eebf7827abf640523444044441fffd9, now(), 'dtn://opertor-mobile.dtn', '00:00:00:00:00:00', '2015-01-01 00:00:00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
