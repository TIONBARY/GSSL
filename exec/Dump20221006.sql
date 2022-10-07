-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: j7a204.p.ssafy.io    Database: drdoc
-- ------------------------------------------------------
-- Server version	5.7.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(1000) NOT NULL,
  `created_time` datetime(6) NOT NULL,
  `image` varchar(256) DEFAULT NULL,
  `title` varchar(20) NOT NULL,
  `views` int(11) NOT NULL DEFAULT '0',
  `type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKe5hsetbh2ymggmo102uisw591` (`type_id`),
  KEY `FKfyf1fchnby6hndhlfaidier1r` (`user_id`),
  CONSTRAINT `FKe5hsetbh2ymggmo102uisw591` FOREIGN KEY (`type_id`) REFERENCES `type` (`id`),
  CONSTRAINT `FKfyf1fchnby6hndhlfaidier1r` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (1,'토실토실하니 귀여워요~','2022-10-06 21:52:15.613000','20221006215215-image_picker6656487174656486855.jpg','제가 키우는 북극곰입니다.',0,1,2),(2,'오랜만에 나온 산책에 즐거운 해피~','2022-10-06 21:53:55.995000','20221006215355-image_picker9080902921242995866.jpg','산책 나와서 신난 해피',0,1,3),(3,'ㅋㅋㅋㅋ 너무 귀엽 ㅋㅋㅋㅋ','2022-10-06 21:54:44.159000','20221006215444-image_picker5399450416620137482.png','우리 젠킨스 똑똑해요~~',0,1,1),(4,'예쁘죠?','2022-10-06 21:55:01.110000','20221006215501-image_picker2034763983517381374.jpg','우리 절미',0,1,4),(5,'어떻게 훈육해야 할까요 ㅠㅠ','2022-10-06 21:55:29.012000','20221006215528-image_picker7484087818004672488.png','자꾸 남의 밥을 뺏어먹어요 ㅠㅠ',0,3,1),(6,'애기시절입니다~','2022-10-06 21:55:52.977000','20221006215552-image_picker5348663523015082691.jpg','멍멍이에요.',0,1,2),(7,'진돗개가 좋아하는 장난감은 뭐가 있나요?','2022-10-06 21:56:30.021000',NULL,'진돗개 최애 장난감',0,3,4),(8,'이게 맞나요','2022-10-06 21:57:19.885000',NULL,'애기가 맨날 잠만 자는데',0,3,2),(9,'저희집 멍뭉인데 좀 억울하게 생겼어요','2022-10-06 21:57:48.452000','20221006215748-image_picker7862093261786257338.jpg','저희집 멍뭉이에요',0,1,5),(10,'개가 건강한지 궁금해요.','2022-10-06 21:58:13.130000',NULL,'안녕하세요. 질문이 있어요.',0,3,2),(11,'우리 해피가 갑자기 토하네요 ㅠㅠ','2022-10-06 21:58:46.973000',NULL,'역삼에 동물병원 있나요?',0,3,3),(12,'ㅠㅠ','2022-10-06 21:59:54.127000','20221006215954-image_picker5526884104025145747.jpg','내일 병원 예약했습니다',0,2,1),(13,'정상이랍니다^^','2022-10-06 22:00:20.958000','20221006220020-image_picker1652742868070366511.jpg','다행스럽게도',0,2,4),(15,'백내장이라네요 ㅠㅠ','2022-10-06 22:09:41.816000','20221006220941-image_picker1700034064137668235.jpg','해피 진단결과',0,2,3),(16,'얼른 병원 가야겠어요.','2022-10-06 22:15:58.721000','20221006221558-image_picker7917753779256875908.jpg','백내장..?',0,2,2);
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` varchar(1000) NOT NULL,
  `time` datetime(6) NOT NULL,
  `board_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlij9oor1nav89jeat35s6kbp1` (`board_id`),
  KEY `FK8kcum44fvpupyw6f5baccx25c` (`user_id`),
  CONSTRAINT `FK8kcum44fvpupyw6f5baccx25c` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FKlij9oor1nav89jeat35s6kbp1` FOREIGN KEY (`board_id`) REFERENCES `board` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,'예쁘네요~~','2022-10-06 21:54:05.737000',1,4),(2,'귀엽죠?','2022-10-06 21:56:14.099000',6,2),(3,'애들은 원래 자는게 일이래요','2022-10-06 21:57:41.284000',8,1),(4,'누가 젠킨스인가요?','2022-10-06 21:58:39.193000',3,5),(5,'소리나는거 좋아해요','2022-10-06 21:58:45.361000',7,2),(6,'저희 집 강아지는 장난감 사준건 안 좋아하고 제 방석만 뺏어가요 ㅠㅠ','2022-10-06 21:58:51.746000',7,1),(7,'애기가 완전 털찐이네요','2022-10-06 22:00:44.984000',1,5),(8,'오른쪽애입니다~','2022-10-06 22:01:00.462000',3,1),(9,'ㅠㅠ 얼른 낫길 기도할게요','2022-10-06 22:01:14.699000',12,4),(10,'진짜 배우 이시언씨인가요','2022-10-06 22:02:20.800000',4,1),(11,'네 안녕하세요','2022-10-06 22:04:12.326000',4,4),(12,'혼난거같은데요','2022-10-06 22:12:22.509000',9,4),(13,'헉 얼른 가보세요!','2022-10-06 22:15:10.716000',11,2);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `journal`
--

DROP TABLE IF EXISTS `journal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `journal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `part` varchar(10) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `picture` varchar(256) NOT NULL,
  `result` varchar(10) NOT NULL,
  `symptom` varchar(10) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjaueygmi2gs6yi766n25ptvnp` (`user_id`),
  CONSTRAINT `FKjaueygmi2gs6yi766n25ptvnp` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `journal`
--

LOCK TABLES `journal` WRITE;
/*!40000 ALTER TABLE `journal` DISABLE KEYS */;
INSERT INTO `journal` VALUES (1,'2022-10-06 21:57:08','눈',1,'20221006215708-scaled_image_picker7960359695464328071.png','궤양성각막질환',NULL,1),(2,'2022-10-06 21:59:00','눈',2,'20221006215900-scaled_image_picker2717734582517664172.jpg','정상',NULL,4),(3,'2022-10-06 22:06:31','눈',0,'20221006220630-scaled_image_picker7957206628793250166.png','백내장',NULL,3),(4,'2022-10-06 22:08:20','눈',3,'20221006220819-scaled_image_picker7957206628793250166.png','백내장',NULL,3),(5,'2022-10-06 22:10:11','눈',5,'20221006221011-scaled_image_picker58487757725273070.jpg','안검염',NULL,2),(6,'2022-10-06 22:13:37','눈',5,'20221006221337-scaled_image_picker4728128250358595726.jpg','결막염',NULL,2),(7,'2022-10-06 22:16:57','눈',7,'20221006221656-scaled_image_picker3638766851305242832.png','안검내반증',NULL,6),(8,'2022-10-06 22:18:06','눈',7,'20221006221806-scaled_image_picker884789941538078618.jpg','안검염',NULL,6),(9,'2022-10-06 22:19:16','눈',7,'20221006221915-scaled_image_picker1549161463697547757.jpg','백내장',NULL,6);
/*!40000 ALTER TABLE `journal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kind`
--

DROP TABLE IF EXISTS `kind`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kind` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kind`
--

LOCK TABLES `kind` WRITE;
/*!40000 ALTER TABLE `kind` DISABLE KEYS */;
INSERT INTO `kind` VALUES (1,'골든 리트리버'),(2,'래브라도 리트리버'),(3,'그레이트 데인'),(4,'그레이트 피레네'),(5,'그레이하운드'),(6,'이탈리안 그레이하운드'),(7,'뉴펀들랜드'),(8,'닥스훈트'),(9,'웰시코기'),(10,'달마티안'),(11,'도베르만 핀셔'),(12,'미니어처 핀셔'),(13,'라사 압소'),(14,'시츄'),(15,'페키니즈'),(16,'로트바일러'),(17,'말티즈'),(18,'바셋 하운드'),(19,'버니즈 마운틴 도그'),(20,'베들링턴 테리어'),(21,'벨지안 말리노이즈'),(22,'셰퍼드'),(23,'보더 콜리'),(24,'셔틀랜드 시프도그'),(25,'보르조이'),(26,'복서'),(27,'불독'),(28,'프렌치 불독'),(29,'불 테리어'),(30,'보스턴 테리어'),(31,'아메리칸 스태퍼드셔 테리어'),(32,'브리아드'),(33,'비글'),(34,'비숑 프리제'),(35,'비어디드 콜리'),(36,'올드 잉글리시 시프도그'),(37,'파피용'),(38,'사모예드'),(39,'삽살개'),(40,'샤페이'),(41,'세인트 버나드'),(42,'스피츠'),(43,'시베리안 허스키'),(44,'시베리안 라이카'),(45,'알래스칸 맬러뮤트'),(46,'아프간 하운드'),(47,'요크셔 테리어'),(48,'잉글리시 세터'),(49,'아이리시 세터'),(50,'잉글리시 코커 스패니얼'),(51,'아메리칸 코커 스패니얼'),(52,'카발리에 킹 찰스 시패니얼'),(53,'자이언트 슈나우저'),(54,'미니어처 슈나우저'),(55,'재패니즈 친'),(56,'잭 러셀 테리어'),(57,'폭스 테리어'),(58,'진돗개'),(59,'시바'),(60,'차우차우'),(61,'차이니즈 크레스티드'),(62,'치와와'),(63,'캐리 블루 테리어'),(64,'콜리'),(65,'쿠이커혼제'),(66,'토이 푸들'),(67,'티베탄 마스티프'),(68,'퍼그'),(69,'포메라니안'),(70,'포인터');
/*!40000 ALTER TABLE `kind` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `animal_pic` varchar(256) DEFAULT NULL,
  `birth` datetime(6) NOT NULL,
  `death` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(50) DEFAULT NULL,
  `diseases` varchar(15) DEFAULT NULL,
  `gender` varchar(1) NOT NULL,
  `name` varchar(10) NOT NULL,
  `neutralize` bit(1) NOT NULL,
  `species` bit(1) NOT NULL,
  `weight` float DEFAULT NULL,
  `kind_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKntr6wwscb1hgy99cfathgv3hi` (`kind_id`),
  KEY `FK9hxka0oqkd15dmqstdarori08` (`user_id`),
  CONSTRAINT `FK9hxka0oqkd15dmqstdarori08` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FKntr6wwscb1hgy99cfathgv3hi` FOREIGN KEY (`kind_id`) REFERENCES `kind` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` VALUES (1,'20221006215359-image_picker8898918094303883678.png','2018-06-21 00:00:00.000000',0,'','','M','젠킨스',_binary '\0',_binary '\0',0,67,1),(2,'20221006215348-image_picker6510170978834159654.jpg','2020-10-14 00:00:00.000000',0,'','','M','절미',_binary '\0',_binary '\0',0,58,4),(3,'20221006215607-image_picker5888016984923715385.jpg','2018-10-03 00:00:00.000000',0,'귀여운 해피','','M','해피',_binary '',_binary '\0',3.7,59,3),(4,'20221006215617-image_picker8609090529431737067.jpg','2022-05-07 00:00:00.000000',0,'','없음','M','마리',_binary '',_binary '\0',3.5,38,5),(5,'20221006223249-20221006222945-20221006222938-20221006222808-20221006222801-20221006221713-20221006221655-20221006220113-image_picker4700067253872950753.jpg','2020-10-01 00:00:00.000000',1,'남자아이에요.','없습니다.','M','뭉치칫',_binary '',_binary '\0',3.3,69,2),(6,'20221006220802-image_picker5875630986535981357.png','2021-05-03 00:00:00.000000',0,'','','F','초코',_binary '\0',_binary '\0',0,9,1),(7,'20221006220925-image_picker8842563261962558320.jpg','2018-10-02 00:00:00.000000',0,'세상에서 제일 귀여운 땅콩이에요!','안검염','M','땅콩이',_binary '',_binary '\0',5,66,6),(8,'20221006221055-image_picker103932460520031850.jpg','2020-10-08 00:00:00.000000',0,'시바견은 국룰입니다.','없음','F','세콩이',_binary '\0',_binary '\0',3,59,6);
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refresh_token`
--

DROP TABLE IF EXISTS `refresh_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_token` (
  `rt_id` int(11) NOT NULL AUTO_INCREMENT,
  `rt_expire_time` datetime(6) DEFAULT NULL,
  `rt_key` varchar(255) DEFAULT NULL,
  `rt_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`rt_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_token`
--

LOCK TABLES `refresh_token` WRITE;
/*!40000 ALTER TABLE `refresh_token` DISABLE KEYS */;
INSERT INTO `refresh_token` VALUES (1,'2022-10-13 22:10:27.045000','junsoo1','eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqdW5zb28xIiwiZXhwIjoxNjY1NjY2NjI3fQ.Qrm9ukH8-efwBv85I-RKJbkTqgtI3xQG4KIdTaPN1iTtAZ-8Wd1BnWvffpl3oNL4IgyRTGTen07giZhzSjf3Ng'),(3,'2022-10-13 22:17:23.090000','dddalang4','eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkZGRhbGFuZzQiLCJleHAiOjE2NjU2NjcwNDN9.xS35qcRoTwK2kpUNh0p4vzfPLFA92MZF75Mfmn-6QIUY_OED8C87vyE7LSoohUmZ-ujdyJr6qgzwmAnZE_9LQw'),(4,'2022-10-13 22:34:47.182000','ssafy204','eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzc2FmeTIwNCIsImV4cCI6MTY2NTY2ODA4N30.RP2xAisLCuYmyOiHIgFQVjgK_PvxiZusHYvcEBK-_NSaCZrUmzZch0uHmMD3eTjgf4Dx8L4Ede_MC3bn7AOwMg'),(5,'2022-10-13 21:54:01.377000','ssafy12345','eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2NjU2NjU2NDF9.gYJ738Z4t0wuSL1JWavvGsFaFkTwb53HcVOGiADj53cJN6G1gkRblUnvDZxHzGzoTAO1UsPIuykWooH5hAaVPA'),(6,'2022-10-13 22:14:11.011000','junwoo0127','eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqdW53b28wMTI3IiwiZXhwIjoxNjY1NjY2ODUxfQ.ZR0L0c4DM5CZNXyrgWpOHYZqB13o49FaTVQVsPGZ5qph1AvxP9A58HrHzip85rbYJvV2RIgwsgRe_BdbF5oiMw'),(7,'2022-10-13 22:28:07.199000','ssafy12345','eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzc2FmeTEyMzQ1IiwiZXhwIjoxNjY1NjY3Njg3fQ.XRae85dD52xnxCb4RppCs4IFNOyZmL5rB5Mcr3JR7XHz0SUNnukmSV5FTFyua29ckzZecr-W9byynlB_Qtwpqw'),(8,'2022-10-13 22:36:58.546000','ehgns017','eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2NjU2NjgyMTh9.hQLxXjB8hdzFJqw2V_EmJC6TAzu0kXkKTZM20UkQooON4h1DETaD45kBwXhHs3Ex5i8EP93wBeEXu2S8AgdbhA');
/*!40000 ALTER TABLE `refresh_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type`
--

DROP TABLE IF EXISTS `type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type`
--

LOCK TABLES `type` WRITE;
/*!40000 ALTER TABLE `type` DISABLE KEYS */;
INSERT INTO `type` VALUES (1,'자랑'),(2,'공유'),(3,'질문');
/*!40000 ALTER TABLE `type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `introduce` varchar(50) DEFAULT NULL,
  `is_left` tinyint(1) NOT NULL DEFAULT '0',
  `member_id` varchar(20) NOT NULL,
  `nickname` varchar(10) NOT NULL,
  `password` varchar(256) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `phone` varchar(11) NOT NULL,
  `profile_pic` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_9o3wj6v6neithkdwrtelcbo96` (`member_id`),
  UNIQUE KEY `UK_n4swgcf30j6bmtb4l4cjryuym` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'junsoohan94@gmail.com','M','',0,'junsoo1','멍집사','$2a$10$P.AIfBmKhwm4rrAM3SZx9uSD4JWXmqUlRT09h2abP3lt/87qAl1Hy',1,'01041262364','20221006215806-image_picker6763214380382832123.png'),(2,'ssafy@ssafy.com','M','자기소개 수정',0,'ehgns017','뭉치아빠','$2a$10$yviEGrIW/bQRpwbwzCftM.II0T8Hz6Rs7dnZB9htnyueN/6WcnM7u',5,'01012341234','20221006215343-20221006215252-20221006214815-image_picker7213559654158891636.jpg'),(3,'dddalang4@naver.com','M','안녕하세요',0,'dddalang4','워너비강형욱','$2a$10$MVwCqMVl5sjzCsfozs0cB.KQ/dxgB40wXEyD8GYfD/m0Qt4GyqtO2',3,'01043009340','20221006215440-20221006215213-image_picker7693380494735467856.jpg'),(4,'tldjs@ssafy.com','M','안녕하세요. 상도동 주민 이시언입니다.',0,'ssafy204','이시언','$2a$10$EgtO6ZDCDyo8wevH98WoNenTv1vmZiTsfm8u4txgZ5xOWa83UNG12',2,'01012345678','20221006215313-image_picker4934097874551283909.jpg'),(5,'ssafy12345@ssafy.com','F','',0,'ssafy12345','마리언니','$2a$10$8qh9iPVWN3ZBukoIMaZO1.e79SvKv32tqvEvBohdy.4edoOEJlEF.',4,'01000000000',NULL),(6,'junwoo0127@naver.com','M','강형욱이 될 남자 김준우입니다.',0,'junwoo0127','싸피강형욱','$2a$10$vIgkUZOGUtkYfGZVIrINyuQoO8QZ4h9kVXo1d5.ho28LNhtTTZKAq',7,'01089216098','20221006220729-image_picker618704079552129607.jpg');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `walk`
--

DROP TABLE IF EXISTS `walk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `walk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distance` int(11) NOT NULL,
  `end_time` datetime(6) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3vcl8w8lw52fpofpgr2696ysa` (`user_id`),
  CONSTRAINT `FK3vcl8w8lw52fpofpgr2696ysa` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `walk`
--

LOCK TABLES `walk` WRITE;
/*!40000 ALTER TABLE `walk` DISABLE KEYS */;
INSERT INTO `walk` VALUES (1,6,'2022-10-06 22:02:38.426327','2022-10-06 22:02:28.860537',2),(2,220,'2022-10-06 22:12:40.670932','2022-10-06 22:10:49.716861',1),(3,220,'2022-10-06 22:12:40.670932','2022-10-06 22:10:49.716861',6),(4,0,'2022-10-06 22:21:43.632804','2022-10-06 22:21:40.087373',6);
/*!40000 ALTER TABLE `walk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `walk_pet`
--

DROP TABLE IF EXISTS `walk_pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `walk_pet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pet_id` int(11) NOT NULL,
  `walk_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2b91ffmieom7opfk9t77l7p4l` (`pet_id`),
  KEY `FKevgpd93ygfpomdgt2oyor3m9l` (`walk_id`),
  CONSTRAINT `FK2b91ffmieom7opfk9t77l7p4l` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FKevgpd93ygfpomdgt2oyor3m9l` FOREIGN KEY (`walk_id`) REFERENCES `walk` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `walk_pet`
--

LOCK TABLES `walk_pet` WRITE;
/*!40000 ALTER TABLE `walk_pet` DISABLE KEYS */;
INSERT INTO `walk_pet` VALUES (1,5,1),(2,1,2),(4,7,3),(5,8,3),(6,7,4);
/*!40000 ALTER TABLE `walk_pet` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-06 22:44:45
