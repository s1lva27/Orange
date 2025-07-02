-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 03/07/2025 às 01:05
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `orange`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `comentarios`
--

CREATE TABLE `comentarios` (
  `id` int(11) NOT NULL,
  `id_publicacao` int(11) DEFAULT NULL,
  `utilizador_id` int(11) DEFAULT NULL,
  `conteudo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `comentarios`
--

INSERT INTO `comentarios` (`id`, `id_publicacao`, `utilizador_id`, `conteudo`, `data`) VALUES
(105, 224, 78, 'a', '2025-06-27 21:00:26'),
(106, 224, 78, 'a', '2025-06-27 21:00:28'),
(107, 221, 78, 'a', '2025-06-27 21:00:37'),
(108, 226, 78, 'as', '2025-06-27 21:07:38'),
(109, 226, 78, 'asssassssas', '2025-06-27 21:07:40'),
(110, 227, 78, 'a', '2025-06-27 22:47:51'),
(111, 230, 89, 'assas', '2025-06-27 23:07:14'),
(112, 230, 78, 'asssas', '2025-06-27 23:15:38'),
(113, 231, 78, 'as', '2025-06-27 23:15:49'),
(114, 231, 89, 'asas', '2025-06-27 23:21:38'),
(115, 231, 89, 'asas', '2025-06-27 23:21:39'),
(116, 231, 89, 'asas', '2025-06-27 23:21:40'),
(117, 225, 78, 'ASSA', '2025-06-27 23:26:43'),
(118, 224, 78, 'AAAAAAAAAAAAAAAAAAAAAAAAAAA', '2025-06-27 23:26:47'),
(119, 235, 89, 'ola', '2025-06-27 23:30:20'),
(120, 233, 78, 'assasas', '2025-06-27 23:33:01'),
(121, 236, 78, 'asasa', '2025-06-27 23:40:40'),
(122, 235, 78, 'asassasa', '2025-06-27 23:40:44'),
(123, 237, 91, 'ola', '2025-06-28 18:06:04'),
(125, 252, 78, 'asas', '2025-07-02 16:28:57'),
(126, 253, 79, 'asas', '2025-07-02 16:29:12');

-- --------------------------------------------------------

--
-- Estrutura para tabela `conversas`
--

CREATE TABLE `conversas` (
  `id` int(11) NOT NULL,
  `utilizador1_id` int(11) NOT NULL,
  `utilizador2_id` int(11) NOT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultima_atividade` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `conversas`
--

INSERT INTO `conversas` (`id`, `utilizador1_id`, `utilizador2_id`, `data_criacao`, `ultima_atividade`) VALUES
(1, 78, 89, '2025-06-27 10:24:46', '2025-07-02 20:44:41'),
(3, 78, 86, '2025-06-27 10:54:05', '2025-07-02 20:35:25'),
(4, 86, 89, '2025-06-27 10:55:37', '2025-06-27 19:14:13'),
(7, 82, 78, '2025-06-27 11:05:52', '2025-07-02 22:35:21'),
(8, 79, 89, '2025-06-27 19:03:53', '2025-07-02 11:00:08'),
(9, 78, 91, '2025-06-28 18:08:57', '2025-07-02 22:54:51'),
(10, 78, 90, '2025-07-02 20:16:15', '2025-07-02 20:45:03'),
(11, 78, 92, '2025-07-02 20:16:32', '2025-07-02 20:16:32');

-- --------------------------------------------------------

--
-- Estrutura para tabela `mensagens`
--

CREATE TABLE `mensagens` (
  `id` int(11) NOT NULL,
  `conversa_id` int(11) NOT NULL,
  `remetente_id` int(11) NOT NULL,
  `conteudo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_envio` timestamp NOT NULL DEFAULT current_timestamp(),
  `lida` tinyint(1) NOT NULL DEFAULT 0,
  `tipo_mensagem` enum('text','shared_post') NOT NULL DEFAULT 'text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `mensagens`
--

INSERT INTO `mensagens` (`id`, `conversa_id`, `remetente_id`, `conteudo`, `data_envio`, `lida`, `tipo_mensagem`) VALUES
(1, 1, 78, 'ola', '2025-06-27 10:24:56', 1, 'text'),
(5, 1, 89, 'ola', '2025-06-27 10:43:09', 1, 'text'),
(6, 1, 78, 'gay de merda', '2025-06-27 10:43:37', 1, 'text'),
(7, 1, 78, 'a', '2025-06-27 10:49:29', 1, 'text'),
(8, 1, 78, 'a', '2025-06-27 10:49:34', 1, 'text'),
(9, 1, 78, 'a', '2025-06-27 10:49:34', 1, 'text'),
(10, 1, 78, 'a', '2025-06-27 10:49:34', 1, 'text'),
(11, 1, 78, 'a', '2025-06-27 10:49:34', 1, 'text'),
(12, 1, 78, 'a', '2025-06-27 10:49:35', 1, 'text'),
(13, 1, 78, 'a', '2025-06-27 10:49:35', 1, 'text'),
(14, 1, 78, 'aaa', '2025-06-27 10:49:35', 1, 'text'),
(15, 1, 78, 'a', '2025-06-27 10:49:36', 1, 'text'),
(16, 1, 78, 'a', '2025-06-27 10:49:36', 1, 'text'),
(18, 7, 82, 'ola', '2025-06-27 11:05:56', 1, 'text'),
(19, 7, 78, 'boas mano', '2025-06-27 11:06:13', 1, 'text'),
(20, 3, 78, 'gostosa rabuda', '2025-06-27 11:14:28', 1, 'text'),
(21, 1, 89, 'aaaa', '2025-06-27 11:52:32', 1, 'text'),
(22, 1, 89, 'aaa', '2025-06-27 11:52:33', 1, 'text'),
(23, 1, 89, 'aaa', '2025-06-27 11:52:34', 1, 'text'),
(24, 1, 78, 'a', '2025-06-27 12:13:38', 1, 'text'),
(25, 1, 78, 'a', '2025-06-27 12:13:39', 1, 'text'),
(26, 1, 78, 'a', '2025-06-27 12:13:39', 1, 'text'),
(27, 1, 78, 'a', '2025-06-27 12:13:39', 1, 'text'),
(28, 1, 78, 'a', '2025-06-27 12:13:39', 1, 'text'),
(29, 1, 78, 'a', '2025-06-27 12:13:39', 1, 'text'),
(30, 1, 78, 'a', '2025-06-27 12:13:40', 1, 'text'),
(31, 1, 78, 'a', '2025-06-27 12:13:40', 1, 'text'),
(32, 1, 78, 'a', '2025-06-27 12:13:40', 1, 'text'),
(33, 1, 78, 'a', '2025-06-27 12:13:40', 1, 'text'),
(34, 1, 78, 'a', '2025-06-27 12:13:40', 1, 'text'),
(35, 1, 78, 'a', '2025-06-27 12:13:40', 1, 'text'),
(36, 1, 78, 'a', '2025-06-27 12:13:41', 1, 'text'),
(37, 1, 78, 'a', '2025-06-27 12:13:41', 1, 'text'),
(38, 1, 78, 'a', '2025-06-27 12:13:41', 1, 'text'),
(39, 1, 78, 'a', '2025-06-27 12:13:41', 1, 'text'),
(40, 1, 78, 'a', '2025-06-27 12:13:41', 1, 'text'),
(41, 1, 78, 'a', '2025-06-27 12:13:41', 1, 'text'),
(42, 1, 78, 'a', '2025-06-27 12:13:42', 1, 'text'),
(43, 1, 78, 'a', '2025-06-27 12:13:42', 1, 'text'),
(44, 1, 78, 'a', '2025-06-27 12:13:42', 1, 'text'),
(45, 1, 78, 'a', '2025-06-27 12:13:42', 1, 'text'),
(46, 1, 78, 'a', '2025-06-27 12:13:42', 1, 'text'),
(47, 1, 78, 'a', '2025-06-27 12:13:42', 1, 'text'),
(48, 1, 78, 'a', '2025-06-27 12:13:43', 1, 'text'),
(49, 1, 78, 'a', '2025-06-27 12:13:43', 1, 'text'),
(50, 1, 78, 'a', '2025-06-27 12:13:43', 1, 'text'),
(51, 1, 78, 'a', '2025-06-27 12:13:43', 1, 'text'),
(52, 1, 78, 'a', '2025-06-27 12:13:43', 1, 'text'),
(53, 1, 78, 'a', '2025-06-27 12:13:43', 1, 'text'),
(54, 1, 78, 'a', '2025-06-27 12:13:44', 1, 'text'),
(55, 1, 78, 'a', '2025-06-27 12:13:44', 1, 'text'),
(56, 1, 78, 'a', '2025-06-27 12:13:44', 1, 'text'),
(57, 1, 78, 'a', '2025-06-27 12:13:44', 1, 'text'),
(58, 1, 78, 'a', '2025-06-27 12:13:44', 1, 'text'),
(59, 1, 78, 'a', '2025-06-27 12:13:44', 1, 'text'),
(60, 1, 78, 'a', '2025-06-27 12:13:45', 1, 'text'),
(61, 1, 89, 'as', '2025-06-27 17:59:34', 1, 'text'),
(62, 1, 89, 'a', '2025-06-27 17:59:37', 1, 'text'),
(63, 1, 89, 'a', '2025-06-27 17:59:39', 1, 'text'),
(64, 1, 89, 'a', '2025-06-27 17:59:39', 1, 'text'),
(65, 1, 89, 'a', '2025-06-27 17:59:39', 1, 'text'),
(66, 1, 89, 'a', '2025-06-27 17:59:39', 1, 'text'),
(67, 1, 89, 'a', '2025-06-27 17:59:40', 1, 'text'),
(68, 1, 89, 'a', '2025-06-27 17:59:40', 1, 'text'),
(69, 1, 89, 'a', '2025-06-27 17:59:40', 1, 'text'),
(70, 1, 89, 'a', '2025-06-27 17:59:40', 1, 'text'),
(73, 1, 89, 'pov', '2025-06-27 17:59:47', 1, 'text'),
(74, 7, 82, 'boas', '2025-06-27 18:00:12', 1, 'text'),
(75, 3, 78, 'a', '2025-06-27 18:55:46', 1, 'text'),
(76, 3, 78, 'asass', '2025-06-27 19:02:31', 1, 'text'),
(77, 1, 78, 'a', '2025-06-27 19:03:31', 1, 'text'),
(78, 1, 78, 'a', '2025-06-27 19:03:43', 1, 'text'),
(79, 8, 79, 'a', '2025-06-27 19:03:55', 1, 'text'),
(80, 8, 79, 'a', '2025-06-27 19:03:56', 1, 'text'),
(81, 4, 89, 'a', '2025-06-27 19:10:43', 1, 'text'),
(82, 4, 89, 'sua gostosa rabuda', '2025-06-27 19:10:53', 1, 'text'),
(83, 8, 89, 'a', '2025-06-27 19:10:57', 1, 'text'),
(84, 8, 89, 'a', '2025-06-27 19:11:00', 1, 'text'),
(85, 8, 89, 'a', '2025-06-27 19:11:01', 1, 'text'),
(86, 8, 89, 'a', '2025-06-27 19:11:01', 1, 'text'),
(87, 8, 89, 'a', '2025-06-27 19:11:01', 1, 'text'),
(88, 8, 89, 'a', '2025-06-27 19:11:01', 1, 'text'),
(89, 8, 89, 'a', '2025-06-27 19:11:01', 1, 'text'),
(90, 8, 89, 'a', '2025-06-27 19:11:02', 1, 'text'),
(91, 8, 89, 'a', '2025-06-27 19:11:02', 1, 'text'),
(92, 8, 89, 'a', '2025-06-27 19:11:02', 1, 'text'),
(93, 4, 86, 'seu porco', '2025-06-27 19:12:36', 1, 'text'),
(94, 4, 86, 'a', '2025-06-27 19:12:41', 1, 'text'),
(95, 4, 86, 'a', '2025-06-27 19:12:45', 1, 'text'),
(96, 4, 86, 'a', '2025-06-27 19:12:48', 1, 'text'),
(97, 4, 86, 'a', '2025-06-27 19:12:51', 1, 'text'),
(98, 4, 86, 'a', '2025-06-27 19:12:52', 1, 'text'),
(99, 4, 86, 'gostoso', '2025-06-27 19:13:07', 1, 'text'),
(100, 4, 89, 'a', '2025-06-27 19:13:17', 1, 'text'),
(101, 4, 89, 'a', '2025-06-27 19:13:30', 1, 'text'),
(102, 4, 89, 'a', '2025-06-27 19:13:33', 1, 'text'),
(103, 4, 86, 'gostoso', '2025-06-27 19:13:57', 1, 'text'),
(104, 4, 86, 'asas', '2025-06-27 19:14:13', 1, 'text'),
(105, 3, 78, 'a', '2025-06-27 19:28:49', 1, 'text'),
(106, 3, 78, 'a', '2025-06-27 19:28:50', 1, 'text'),
(107, 3, 78, 'a', '2025-06-27 19:28:50', 1, 'text'),
(108, 3, 78, 'a', '2025-06-27 19:28:50', 1, 'text'),
(109, 3, 78, 'a', '2025-06-27 19:28:51', 1, 'text'),
(110, 3, 78, 'a', '2025-06-27 19:28:51', 1, 'text'),
(111, 3, 78, 'a', '2025-06-27 19:28:51', 1, 'text'),
(112, 1, 78, 'a', '2025-06-27 23:18:27', 1, 'text'),
(113, 1, 78, 'a', '2025-06-27 23:18:28', 1, 'text'),
(114, 1, 78, 'a', '2025-06-27 23:18:28', 1, 'text'),
(115, 1, 78, 'a', '2025-06-27 23:18:28', 1, 'text'),
(116, 3, 78, 'A', '2025-06-27 23:27:16', 0, 'text'),
(120, 9, 78, 'ass', '2025-06-28 18:09:06', 1, 'text'),
(121, 9, 78, 'asasas', '2025-06-28 18:09:13', 1, 'text'),
(122, 9, 91, 'aaasas', '2025-06-28 18:09:43', 1, 'text'),
(123, 1, 89, 'asasas', '2025-06-28 18:10:08', 1, 'text'),
(124, 8, 79, 'nengue', '2025-07-02 11:00:08', 1, 'text'),
(125, 1, 78, 'asasas', '2025-07-02 15:39:08', 1, 'text'),
(126, 1, 78, 'asas', '2025-07-02 15:39:09', 1, 'text'),
(127, 1, 78, 'AS', '2025-07-02 16:00:55', 0, 'text'),
(128, 9, 78, '📤 Publicação partilhada por Afonso Silva\n\n👤 @silvarealz14 (Afonso Silva)\n📅 02/07/2025 20:11\n\n📝 asas\n\n📊 Enquete: asa\n⏱️ Enquete ativa\n🗳️ Total de votos: 1\n\n▫️ 1122 (100%)\n▫️ 12 (0%)\n\n🔗 Ver publicação: localhost/frontend/perfil.php?id=78#post-256', '2025-07-02 19:58:03', 0, 'text'),
(129, 10, 78, '{\"type\":\"shared_post\",\"shared_by\":{\"id\":\"78\",\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\"},\"message\":\"\",\"post\":{\"id\":255,\"author\":{\"id\":78,\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\",\"photo\":\"perfil_67ccd1cce44eb.jpeg\"},\"content\":\"asas\",\"type\":\"post\",\"date\":\"2025-07-02 17:29:37\",\"likes\":0,\"medias\":[],\"poll\":null},\"timestamp\":\"2025-07-02 22:16:15\"}', '2025-07-02 20:16:15', 0, 'shared_post'),
(130, 11, 78, '{\"type\":\"shared_post\",\"shared_by\":{\"id\":\"78\",\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\"},\"message\":\"\",\"post\":{\"id\":256,\"author\":{\"id\":78,\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\",\"photo\":\"perfil_67ccd1cce44eb.jpeg\"},\"content\":\"asas\",\"type\":\"poll\",\"date\":\"2025-07-02 20:11:36\",\"likes\":0,\"medias\":[],\"poll\":{\"id\":10,\"pergunta\":\"asa\",\"data_expiracao\":\"2025-07-03 21:11:36\",\"total_votos\":1,\"expirada\":false,\"opcoes\":[{\"opcao_texto\":\"1122\",\"votos\":1},{\"opcao_texto\":\"12\",\"votos\":0}]}},\"timestamp\":\"2025-07-02 22:16:32\"}', '2025-07-02 20:16:32', 0, 'shared_post'),
(131, 3, 78, '{\"type\":\"shared_post\",\"shared_by\":{\"id\":\"78\",\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\"},\"message\":\"\",\"post\":{\"id\":255,\"author\":{\"id\":78,\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\",\"photo\":\"perfil_67ccd1cce44eb.jpeg\"},\"content\":\"asas\",\"type\":\"post\",\"date\":\"2025-07-02 17:29:37\",\"likes\":0,\"medias\":[],\"poll\":null},\"timestamp\":\"2025-07-02 22:35:25\"}', '2025-07-02 20:35:25', 0, 'shared_post'),
(132, 1, 78, '{\"type\":\"shared_post\",\"shared_by\":{\"id\":\"78\",\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\"},\"message\":\"\",\"post\":{\"id\":255,\"author\":{\"id\":78,\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\",\"photo\":\"perfil_67ccd1cce44eb.jpeg\"},\"content\":\"asas\",\"type\":\"post\",\"date\":\"2025-07-02 17:29:37\",\"likes\":0,\"medias\":[],\"poll\":null},\"timestamp\":\"2025-07-02 22:44:41\"}', '2025-07-02 20:44:41', 0, 'shared_post'),
(133, 10, 78, '{\"type\":\"shared_post\",\"shared_by\":{\"id\":\"78\",\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\"},\"message\":\"\",\"post\":{\"id\":249,\"author\":{\"id\":89,\"name\":\"Gouveia\",\"nick\":\"gougou\",\"photo\":\"default-profile.jpg\"},\"content\":\"asas\",\"type\":\"poll\",\"date\":\"2025-07-01 21:39:33\",\"likes\":3,\"medias\":[],\"poll\":{\"id\":9,\"pergunta\":\"asas\",\"data_expiracao\":\"2025-07-02 22:39:33\",\"total_votos\":6,\"expirada\":true,\"opcoes\":[{\"opcao_texto\":\"1\",\"votos\":4},{\"opcao_texto\":\"2\",\"votos\":2}]}},\"timestamp\":\"2025-07-02 22:45:03\"}', '2025-07-02 20:45:03', 0, 'shared_post'),
(134, 7, 78, '{\"type\":\"shared_post\",\"shared_by\":{\"id\":\"78\",\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\"},\"message\":\"\",\"post_link\":\"http:\\/\\/localhost\\/orange\\/frontend\\/publicacao.php?id=258\",\"post\":{\"id\":258,\"author\":{\"id\":78,\"name\":\"Afonso Silva\",\"nick\":\"silvarealz14\",\"photo\":\"perfil_67ccd1cce44eb.jpeg\"},\"content\":\"asassasas\",\"type\":\"post\",\"date\":\"2025-07-02 23:35:07\",\"likes\":1,\"medias\":[],\"poll\":null},\"timestamp\":\"2025-07-03 00:35:21\"}', '2025-07-02 22:35:21', 0, 'shared_post'),
(135, 9, 78, 'assas', '2025-07-02 22:54:51', 0, 'text');

-- --------------------------------------------------------

--
-- Estrutura para tabela `notificacoes`
--

CREATE TABLE `notificacoes` (
  `id` int(11) NOT NULL,
  `utilizador_id` int(11) NOT NULL COMMENT 'Quem recebe a notificação',
  `remetente_id` int(11) NOT NULL COMMENT 'Quem causou a notificação',
  `tipo` enum('like','comment','follow','save','unfollow') NOT NULL,
  `publicacao_id` int(11) DEFAULT NULL COMMENT 'ID da publicação (para likes, comments, saves)',
  `comentario_id` int(11) DEFAULT NULL COMMENT 'ID do comentário (para comentários)',
  `mensagem` text NOT NULL COMMENT 'Texto da notificação',
  `lida` tinyint(1) NOT NULL DEFAULT 0,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `notificacoes`
--

INSERT INTO `notificacoes` (`id`, `utilizador_id`, `remetente_id`, `tipo`, `publicacao_id`, `comentario_id`, `mensagem`, `lida`, `data_criacao`) VALUES
(1, 86, 78, 'comment', 224, 105, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 21:00:26'),
(2, 86, 78, 'follow', NULL, NULL, 'Afonso Silva começou a seguir-te', 1, '2025-06-27 21:01:18'),
(3, 86, 78, 'like', 227, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 21:03:40'),
(6, 78, 86, 'like', 221, NULL, 'Matilde Alves deu like na sua publicação', 1, '2025-06-27 21:07:17'),
(7, 78, 86, 'like', 220, NULL, 'Matilde Alves deu like na sua publicação', 1, '2025-06-27 21:07:19'),
(8, 86, 78, 'comment', 226, 108, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 21:07:38'),
(9, 86, 78, 'comment', 227, 110, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 22:47:51'),
(11, 78, 89, 'like', 231, NULL, 'Gouveia deu like na sua publicação', 1, '2025-06-27 23:07:11'),
(12, 78, 89, 'save', 231, NULL, 'Gouveia guardou a sua publicação', 1, '2025-06-27 23:07:11'),
(13, 78, 89, 'like', 230, NULL, 'Gouveia deu like na sua publicação', 1, '2025-06-27 23:07:13'),
(14, 78, 89, 'comment', 230, 111, 'Gouveia comentou na sua publicação', 1, '2025-06-27 23:07:14'),
(15, 78, 89, 'like', 229, NULL, 'Gouveia deu like na sua publicação', 1, '2025-06-27 23:07:16'),
(16, 78, 89, 'like', 228, NULL, 'Gouveia deu like na sua publicação', 1, '2025-06-27 23:07:17'),
(17, 78, 89, 'save', 229, NULL, 'Gouveia guardou a sua publicação', 1, '2025-06-27 23:07:18'),
(18, 86, 89, 'like', 227, NULL, 'Gouveia deu like na sua publicação', 1, '2025-06-27 23:07:19'),
(19, 78, 89, 'follow', NULL, NULL, 'Gouveia começou a seguir-te', 1, '2025-06-27 23:07:23'),
(20, 78, 89, 'comment', 231, 114, 'Gouveia comentou na sua publicação', 1, '2025-06-27 23:21:38'),
(21, 86, 78, 'like', 224, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:26:39'),
(22, 86, 78, 'like', 225, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:26:40'),
(23, 86, 78, 'like', 226, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:26:41'),
(24, 86, 78, 'comment', 225, 117, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 23:26:43'),
(25, 89, 78, 'like', 236, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:32:54'),
(26, 89, 78, 'like', 235, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:32:56'),
(29, 89, 78, 'comment', 233, 120, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 23:33:01'),
(30, 89, 78, 'follow', NULL, NULL, 'Afonso Silva começou a seguir-te', 1, '2025-06-27 23:33:07'),
(31, 89, 78, 'comment', 236, 121, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 23:40:40'),
(32, 89, 78, 'comment', 235, 122, 'Afonso Silva comentou na sua publicação', 1, '2025-06-27 23:40:44'),
(33, 89, 78, 'like', 234, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:40:46'),
(34, 89, 78, 'like', 233, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-27 23:40:47'),
(35, 78, 89, 'like', 221, NULL, 'Gouveia deu like na sua publicação', 1, '2025-06-27 23:51:36'),
(37, 78, 91, 'like', 237, NULL, 'Antonio deu like na sua publicação', 1, '2025-06-28 18:05:47'),
(38, 78, 91, 'comment', 237, 123, 'Antonio comentou na sua publicação', 1, '2025-06-28 18:06:04'),
(39, 91, 78, 'like', 238, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-06-28 18:06:25'),
(41, 78, 91, 'follow', NULL, NULL, 'Antonio começou a seguir-te', 1, '2025-06-28 18:08:43'),
(42, 91, 78, 'follow', NULL, NULL, 'Afonso Silva começou a seguir-te', 1, '2025-06-28 18:08:47'),
(43, 78, 89, '', 246, NULL, 'Gouveia votou na sua poll', 1, '2025-06-30 10:16:09'),
(44, 78, 89, '', 248, NULL, 'Gouveia votou na sua poll', 1, '2025-07-01 11:27:49'),
(45, 91, 89, 'follow', NULL, NULL, 'Gouveia começou a seguir-te', 1, '2025-07-02 10:56:33'),
(46, 89, 91, '', 249, NULL, 'Antonio votou na sua poll', 1, '2025-07-02 10:59:18'),
(47, 89, 86, '', 249, NULL, 'Matilde Alves votou na sua poll', 1, '2025-07-02 10:59:31'),
(49, 89, 82, '', 249, NULL, 'Tomas votou na sua poll', 1, '2025-07-02 10:59:47'),
(50, 89, 79, '', 249, NULL, 'Afonso Silva votou na sua poll', 1, '2025-07-02 11:00:00'),
(51, 89, 85, 'like', 250, NULL, 'Luisa deu like na sua publicação', 1, '2025-07-02 12:05:07'),
(57, 89, 78, 'like', 249, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-07-02 15:39:22'),
(58, 89, 78, 'like', 250, NULL, 'Afonso Silva deu like na sua publicação', 1, '2025-07-02 15:39:23'),
(59, 85, 89, 'follow', NULL, NULL, 'Gouveia começou a seguir-te', 0, '2025-07-02 15:39:52'),
(60, 78, 79, 'comment', 253, 126, 'Afonso Silva comentou na sua publicação', 1, '2025-07-02 16:29:12');

-- --------------------------------------------------------

--
-- Estrutura para tabela `perfis`
--

CREATE TABLE `perfis` (
  `id_perfil` int(11) NOT NULL,
  `id_utilizador` int(11) NOT NULL,
  `biografia` varchar(255) DEFAULT '',
  `foto_perfil` varchar(255) DEFAULT 'images/default-profile.jpg',
  `data_criacao` date NOT NULL DEFAULT current_timestamp(),
  `foto_capa` varchar(255) DEFAULT 'images/default.png',
  `x` varchar(255) NOT NULL DEFAULT '',
  `linkedin` varchar(255) NOT NULL DEFAULT '',
  `github` varchar(255) NOT NULL DEFAULT '',
  `ocupacao` varchar(255) NOT NULL,
  `pais` varchar(255) NOT NULL DEFAULT '',
  `cidade` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `perfis`
--

INSERT INTO `perfis` (`id_perfil`, `id_utilizador`, `biografia`, `foto_perfil`, `data_criacao`, `foto_capa`, `x`, `linkedin`, `github`, `ocupacao`, `pais`, `cidade`) VALUES
(4, 78, 'aluno mais arrependido do curso q escolheu', 'perfil_67ccd1cce44eb.jpeg', '2025-02-04', 'capa_684ca5aa37e7d.jpg', 'https://x.com/_afonso_silvaa', 'https://www.linkedin.com/in/afonso-silva-7b65552b2/', 'https://github.com/s1lva27', 'Estudante', 'Hungria', 'Szombathely'),
(5, 79, '', 'default-profile.jpg', '2025-02-05', 'default-capa.png', '', '', '', '', 'BÃ©lgica', 'Aalst'),
(6, 80, '', 'perfil_67abd8605e695.jpg', '2025-02-11', 'capa_67abd8410575c.png', '', '', '', '', '', ''),
(8, 82, '', 'default-profile.jpg', '2025-02-12', 'default-capa.png', '', '', '', '', '', ''),
(9, 83, '', 'default-profile.jpg', '2025-02-12', 'default-capa.png', '', '', '', '', '', ''),
(11, 85, '', 'default-profile.jpg', '2025-03-09', 'default-capa.png', '', '', '', '', '', ''),
(12, 86, 'moro na granja do ulmeiro', 'perfil_683df190346dc.jpg', '2025-06-02', 'capa_683df19770367.jpg', '', '', '', 'Estudante', 'Portugal', 'Lisboa'),
(13, 87, 'Yo soy di eslovacia', 'perfil_683f10b0c2fe2.jpg', '2025-06-03', 'capa_683f10bbc993d.jpg', '', '', '', 'Stripper', 'Polónia', 'Katowice'),
(15, 89, '', 'default-profile.jpg', '2025-06-10', 'default-capa.png', 'asas', 'asas', 'https://github.com/s1lva27/Orange/blob/master/frontend/css/style_index.css', '', 'Irlanda', 'Dublin'),
(16, 90, '', 'default-profile.jpg', '2025-06-19', 'default-capa.png', '', '', '', '', '', ''),
(17, 91, 'asasdasd', 'perfil_68602f5ac3d54.jpg', '2025-06-28', 'capa_68602f668d7b0.png', '', '', '', 'Professor', 'Hungria', 'Miskolc'),
(18, 92, '', 'default-profile.jpg', '2025-07-02', 'default-capa.png', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `polls`
--

CREATE TABLE `polls` (
  `id` int(11) NOT NULL,
  `publicacao_id` int(11) NOT NULL,
  `pergunta` varchar(500) NOT NULL,
  `data_expiracao` datetime NOT NULL,
  `total_votos` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `polls`
--

INSERT INTO `polls` (`id`, `publicacao_id`, `pergunta`, `data_expiracao`, `total_votos`) VALUES
(1, 240, 'asas', '2025-06-29 20:14:33', 3),
(2, 242, 'O duarte é gay?', '2025-06-30 16:24:28', 1),
(3, 243, 'preferem oq', '2025-06-30 16:30:43', 1),
(4, 244, 'preferem oq', '2025-06-30 16:34:14', 1),
(5, 245, 'asedddasd', '2025-06-30 16:34:28', 1),
(6, 246, 'asasas?', '2025-07-01 11:58:59', 2),
(7, 247, 'qual preferem?', '2025-07-01 14:18:54', 1),
(8, 248, 'asass', '2025-07-02 13:26:11', 2),
(9, 249, 'asas', '2025-07-02 22:39:33', 6),
(10, 256, 'asa', '2025-07-03 21:11:36', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `poll_opcoes`
--

CREATE TABLE `poll_opcoes` (
  `id` int(11) NOT NULL,
  `poll_id` int(11) NOT NULL,
  `opcao_texto` varchar(200) NOT NULL,
  `votos` int(11) DEFAULT 0,
  `ordem` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `poll_opcoes`
--

INSERT INTO `poll_opcoes` (`id`, `poll_id`, `opcao_texto`, `votos`, `ordem`) VALUES
(1, 1, '1', 1, 0),
(2, 1, '2', 2, 1),
(3, 2, '12', 0, 1),
(4, 2, '12', 1, 2),
(5, 3, 'banana', 1, 1),
(6, 3, 'maçã', 0, 2),
(7, 4, 'banana', 1, 1),
(8, 4, 'maçã', 0, 2),
(9, 5, 'asdas', 0, 1),
(10, 5, 'asdasd', 1, 2),
(11, 6, 'asd', 1, 1),
(12, 6, 'asdasd', 1, 2),
(13, 7, 'sporting', 1, 1),
(14, 7, 'benfica', 0, 2),
(15, 8, '1112', 1, 1),
(16, 8, '12', 1, 2),
(17, 9, '1', 4, 1),
(18, 9, '2', 2, 2),
(19, 10, '1122', 1, 1),
(20, 10, '12', 0, 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `poll_votos`
--

CREATE TABLE `poll_votos` (
  `id` int(11) NOT NULL,
  `poll_id` int(11) NOT NULL,
  `opcao_id` int(11) NOT NULL,
  `utilizador_id` int(11) NOT NULL,
  `data_voto` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `poll_votos`
--

INSERT INTO `poll_votos` (`id`, `poll_id`, `opcao_id`, `utilizador_id`, `data_voto`) VALUES
(1, 1, 1, 78, '2025-06-28 18:14:36'),
(2, 1, 2, 89, '2025-06-28 18:14:49'),
(4, 2, 4, 78, '2025-06-29 14:24:37'),
(5, 4, 7, 78, '2025-06-29 14:34:16'),
(6, 6, 12, 78, '2025-06-30 09:59:13'),
(7, 6, 11, 89, '2025-06-30 10:16:09'),
(8, 5, 10, 78, '2025-06-30 11:50:02'),
(9, 3, 5, 78, '2025-06-30 11:50:10'),
(10, 7, 13, 78, '2025-07-01 11:18:57'),
(11, 8, 15, 78, '2025-07-01 11:26:12'),
(12, 8, 16, 89, '2025-07-01 11:27:49'),
(13, 9, 17, 89, '2025-07-01 20:39:34'),
(14, 9, 18, 91, '2025-07-02 10:59:18'),
(15, 9, 17, 86, '2025-07-02 10:59:31'),
(17, 9, 18, 82, '2025-07-02 10:59:47'),
(18, 9, 17, 79, '2025-07-02 11:00:00'),
(19, 10, 19, 78, '2025-07-02 19:11:39');

-- --------------------------------------------------------

--
-- Estrutura para tabela `publicacao_likes`
--

CREATE TABLE `publicacao_likes` (
  `id` int(11) NOT NULL,
  `publicacao_id` int(11) DEFAULT NULL,
  `utilizador_id` int(11) DEFAULT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `publicacao_likes`
--

INSERT INTO `publicacao_likes` (`id`, `publicacao_id`, `utilizador_id`, `data`) VALUES
(191, 223, 89, '2025-06-27 11:27:51'),
(193, 223, 86, '2025-06-27 20:49:23'),
(194, 222, 86, '2025-06-27 20:49:24'),
(195, 221, 78, '2025-06-27 21:00:35'),
(196, 223, 78, '2025-06-27 21:00:44'),
(197, 227, 78, '2025-06-27 21:03:40'),
(200, 221, 86, '2025-06-27 21:07:17'),
(201, 220, 86, '2025-06-27 21:07:19'),
(202, 231, 89, '2025-06-27 23:07:11'),
(203, 230, 89, '2025-06-27 23:07:13'),
(204, 229, 89, '2025-06-27 23:07:16'),
(205, 228, 89, '2025-06-27 23:07:17'),
(206, 227, 89, '2025-06-27 23:07:19'),
(207, 224, 78, '2025-06-27 23:26:39'),
(208, 225, 78, '2025-06-27 23:26:40'),
(209, 226, 78, '2025-06-27 23:26:41'),
(210, 236, 78, '2025-06-27 23:32:54'),
(211, 235, 78, '2025-06-27 23:32:56'),
(214, 234, 78, '2025-06-27 23:40:46'),
(215, 233, 78, '2025-06-27 23:40:47'),
(216, 236, 89, '2025-06-27 23:41:39'),
(217, 221, 89, '2025-06-27 23:51:36'),
(218, 237, 91, '2025-06-28 18:05:47'),
(219, 237, 78, '2025-06-28 18:06:00'),
(220, 238, 78, '2025-06-28 18:06:25'),
(221, 246, 78, '2025-06-30 09:59:05'),
(222, 249, 89, '2025-07-01 20:39:39'),
(223, 250, 85, '2025-07-02 12:05:07'),
(226, 249, 78, '2025-07-02 15:39:22'),
(227, 250, 78, '2025-07-02 15:39:23'),
(228, 252, 78, '2025-07-02 16:28:42'),
(230, 258, 78, '2025-07-02 22:35:11');

-- --------------------------------------------------------

--
-- Estrutura para tabela `publicacao_medias`
--

CREATE TABLE `publicacao_medias` (
  `id` int(11) NOT NULL,
  `publicacao_id` int(11) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `content_warning` enum('none','nudity','violence') NOT NULL DEFAULT 'none',
  `ordem` int(11) NOT NULL DEFAULT 0,
  `tipo` enum('imagem','video') NOT NULL DEFAULT 'imagem'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `publicacao_medias`
--

INSERT INTO `publicacao_medias` (`id`, `publicacao_id`, `url`, `content_warning`, `ordem`, `tipo`) VALUES
(139, 234, 'pub_1751066993_0_685f2971d7e11.jpg', 'none', 0, 'imagem'),
(140, 235, 'pub_1751067008_0_685f29807abd6.jpg', 'none', 0, 'imagem'),
(141, 235, 'pub_1751067008_1_685f29807c012.jpg', 'none', 1, 'imagem'),
(142, 235, 'pub_1751067008_2_685f29807dab7.png', 'none', 2, 'imagem'),
(143, 235, 'pub_1751067008_3_685f29807e24b.png', 'none', 3, 'imagem'),
(144, 236, 'pub_1751067056_0_685f29b0b5df2.mp4', 'none', 0, 'video'),
(145, 239, 'pub_1751134299_0_6860305b061e3.png', 'none', 0, 'imagem'),
(146, 239, 'pub_1751134299_1_6860305b0705d.png', 'none', 1, 'imagem'),
(147, 239, 'pub_1751134299_2_6860305b07777.png', 'none', 2, 'imagem'),
(148, 239, 'pub_1751134299_3_6860305b092f5.png', 'none', 3, 'imagem'),
(149, 239, 'pub_1751134299_4_6860305b09a07.png', 'none', 4, 'imagem'),
(150, 250, 'pub_1751402403_0_686447a3c1ca5.mp4', 'none', 0, 'video'),
(151, 253, 'pub_1751473727_0_68655e3f29940.mp4', 'none', 0, 'video');

-- --------------------------------------------------------

--
-- Estrutura para tabela `publicacao_salvas`
--

CREATE TABLE `publicacao_salvas` (
  `id` int(11) NOT NULL,
  `utilizador_id` int(11) NOT NULL,
  `publicacao_id` int(11) NOT NULL,
  `data_salvamento` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `publicacao_salvas`
--

INSERT INTO `publicacao_salvas` (`id`, `utilizador_id`, `publicacao_id`, `data_salvamento`) VALUES
(133, 89, 231, '2025-06-27 23:07:11'),
(134, 89, 229, '2025-06-27 23:07:18'),
(135, 78, 231, '2025-06-27 23:15:42'),
(136, 89, 235, '2025-06-27 23:30:24'),
(137, 78, 237, '2025-06-28 18:10:45'),
(138, 78, 240, '2025-06-28 18:15:35'),
(139, 78, 246, '2025-06-30 10:08:51'),
(140, 89, 249, '2025-07-02 10:51:02'),
(142, 78, 252, '2025-07-02 16:28:53'),
(143, 78, 259, '2025-07-02 22:55:45');

-- --------------------------------------------------------

--
-- Estrutura para tabela `publicacoes`
--

CREATE TABLE `publicacoes` (
  `id_publicacao` int(11) NOT NULL,
  `id_utilizador` int(11) NOT NULL,
  `conteudo` text NOT NULL,
  `tipo` enum('post','poll') DEFAULT 'post',
  `categoria` varchar(100) DEFAULT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `deletado_em` datetime NOT NULL,
  `likes` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `publicacoes`
--

INSERT INTO `publicacoes` (`id_publicacao`, `id_utilizador`, `conteudo`, `tipo`, `categoria`, `data_criacao`, `deletado_em`, `likes`) VALUES
(220, 78, 'asas', 'post', NULL, '2025-06-26 15:47:24', '0000-00-00 00:00:00', 1),
(221, 78, 'asas', 'post', NULL, '2025-06-26 15:47:25', '0000-00-00 00:00:00', 3),
(222, 78, 'asas', 'post', NULL, '2025-06-26 15:47:26', '0000-00-00 00:00:00', 1),
(223, 78, 'as', 'post', NULL, '2025-06-27 10:24:39', '0000-00-00 00:00:00', 3),
(224, 86, 'ãsas', 'post', NULL, '2025-06-27 20:06:19', '0000-00-00 00:00:00', 1),
(225, 86, 'a', 'post', NULL, '2025-06-27 21:03:30', '0000-00-00 00:00:00', 1),
(226, 86, 'a', 'post', NULL, '2025-06-27 21:03:31', '0000-00-00 00:00:00', 1),
(227, 86, 'assasas', 'post', NULL, '2025-06-27 21:03:32', '0000-00-00 00:00:00', 2),
(228, 78, 'sasaas', 'post', NULL, '2025-06-27 23:06:39', '0000-00-00 00:00:00', 1),
(229, 78, 'sadddddasd', 'post', NULL, '2025-06-27 23:06:40', '0000-00-00 00:00:00', 1),
(230, 78, 'asddasdasd', 'post', NULL, '2025-06-27 23:06:42', '0000-00-00 00:00:00', 1),
(231, 78, 'assdddassdasssd', 'post', NULL, '2025-06-27 23:06:44', '0000-00-00 00:00:00', 1),
(232, 89, 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA', 'post', NULL, '2025-06-27 23:29:45', '0000-00-00 00:00:00', 0),
(233, 89, 'Ola', 'post', NULL, '2025-06-27 23:29:48', '0000-00-00 00:00:00', 1),
(234, 89, 'ola', 'post', NULL, '2025-06-27 23:29:53', '0000-00-00 00:00:00', 1),
(235, 89, 'ola', 'post', NULL, '2025-06-27 23:30:08', '0000-00-00 00:00:00', 1),
(236, 89, '', 'post', NULL, '2025-06-27 23:30:56', '0000-00-00 00:00:00', 2),
(237, 78, 'asas', 'post', NULL, '2025-06-28 18:05:42', '0000-00-00 00:00:00', 2),
(238, 91, 'asas', 'post', NULL, '2025-06-28 18:06:22', '0000-00-00 00:00:00', 1),
(239, 78, '', 'post', NULL, '2025-06-28 18:11:39', '0000-00-00 00:00:00', 0),
(240, 78, 'asa', 'poll', NULL, '2025-06-28 18:14:33', '0000-00-00 00:00:00', 0),
(241, 78, 'assssaass', 'post', NULL, '2025-06-28 18:26:12', '0000-00-00 00:00:00', 0),
(242, 78, 'asas', 'poll', NULL, '2025-06-29 14:24:28', '0000-00-00 00:00:00', 0),
(243, 78, '', 'poll', NULL, '2025-06-29 14:30:43', '0000-00-00 00:00:00', 0),
(244, 78, '', 'poll', NULL, '2025-06-29 14:34:14', '0000-00-00 00:00:00', 0),
(245, 78, 'asd', 'poll', NULL, '2025-06-29 14:34:28', '0000-00-00 00:00:00', 0),
(246, 78, 'saad', 'poll', NULL, '2025-06-30 09:58:59', '0000-00-00 00:00:00', 1),
(247, 78, 'perfunta importante', 'poll', NULL, '2025-07-01 11:18:54', '0000-00-00 00:00:00', 0),
(248, 78, 'asas', 'poll', NULL, '2025-07-01 11:26:11', '0000-00-00 00:00:00', 0),
(249, 89, 'asas', 'poll', NULL, '2025-07-01 20:39:33', '0000-00-00 00:00:00', 3),
(250, 89, '', 'post', NULL, '2025-07-01 20:40:03', '0000-00-00 00:00:00', 3),
(252, 78, 'asas', 'post', NULL, '2025-07-02 16:28:37', '0000-00-00 00:00:00', 1),
(253, 78, '', 'post', NULL, '2025-07-02 16:28:47', '0000-00-00 00:00:00', 0),
(255, 78, 'asas', 'post', NULL, '2025-07-02 16:29:37', '0000-00-00 00:00:00', 0),
(256, 78, 'asas', 'poll', NULL, '2025-07-02 19:11:36', '0000-00-00 00:00:00', 0),
(258, 78, 'asassasas', 'post', NULL, '2025-07-02 22:35:07', '0000-00-00 00:00:00', 1),
(259, 78, 'asas', 'post', NULL, '2025-07-02 22:55:41', '0000-00-00 00:00:00', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `seguidores`
--

CREATE TABLE `seguidores` (
  `id_seguidor` int(11) NOT NULL,
  `id_seguido` int(11) NOT NULL,
  `data_seguido` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Despejando dados para a tabela `seguidores`
--

INSERT INTO `seguidores` (`id_seguidor`, `id_seguido`, `data_seguido`) VALUES
(78, 78, '2025-06-03 21:25:00'),
(78, 79, '2025-06-13 22:17:29'),
(78, 80, '2025-06-13 22:17:39'),
(78, 82, '2025-06-13 22:22:34'),
(78, 86, '2025-06-27 21:01:18'),
(78, 89, '2025-06-27 23:33:07'),
(78, 91, '2025-06-28 18:08:47'),
(79, 78, '2025-06-25 14:08:17'),
(79, 80, '2025-06-25 14:07:58'),
(79, 82, '2025-06-25 17:28:22'),
(86, 78, '2025-06-27 20:09:09'),
(86, 89, '2025-06-27 10:55:21'),
(87, 78, '2025-06-03 15:12:47'),
(87, 86, '2025-06-03 15:12:41'),
(89, 78, '2025-06-27 23:07:23'),
(89, 85, '2025-07-02 15:39:52'),
(89, 86, '2025-06-27 10:55:06'),
(89, 91, '2025-07-02 10:56:33'),
(91, 78, '2025-06-28 18:08:43');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tipos_utilizador`
--

CREATE TABLE `tipos_utilizador` (
  `id_tipos_utilizador` int(11) NOT NULL,
  `tipo_utilizador` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tipos_utilizador`
--

INSERT INTO `tipos_utilizador` (`id_tipos_utilizador`, `tipo_utilizador`) VALUES
(0, 'utilizador'),
(2, 'admin');

-- --------------------------------------------------------

--
-- Estrutura para tabela `utilizadores`
--

CREATE TABLE `utilizadores` (
  `id` int(11) NOT NULL,
  `nome_completo` varchar(255) NOT NULL DEFAULT 'NOVO_UTILIZADOR',
  `email` varchar(255) NOT NULL,
  `palavra_passe` varchar(255) NOT NULL,
  `data_nascimento` date DEFAULT NULL,
  `nick` varchar(50) NOT NULL,
  `id_tipos_utilizador` int(11) DEFAULT 0,
  `data_criacao` timestamp(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `utilizadores`
--

INSERT INTO `utilizadores` (`id`, `nome_completo`, `email`, `palavra_passe`, `data_nascimento`, `nick`, `id_tipos_utilizador`, `data_criacao`) VALUES
(78, 'Afonso Silva', 'imafonsosilva@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2007-12-27', 'silvarealz14', 2, '2025-02-04 17:34:09.071263'),
(79, 'Afonso Silva', 'afonso22roblox@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2002-12-11', 's.ilvaaa', 0, '2025-02-05 11:19:20.330537'),
(80, 'Joao', 'jomao@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2010-11-11', 'joaofps', 2, '2025-02-11 23:05:22.674980'),
(82, 'Tomas', 'tomas@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2002-10-22', 'tomas13', 0, '2025-02-12 07:39:53.000266'),
(83, 'Joana', 'joanaa@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2003-03-03', 'joana12', 0, '2025-02-12 07:40:20.294933'),
(85, 'Luisa', 'luisaa@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2005-12-12', 'luisafofinha', 0, '2025-03-09 14:16:04.740615'),
(86, 'Matilde Alves', 'matildealves@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2007-12-05', 'matxiudi', 0, '2025-06-02 18:45:26.635706'),
(87, 'Duarte Lopes', 'duarte.v.lopeo@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2007-11-16', 'dudzfn', 0, '2025-06-03 15:10:42.570645'),
(89, 'Gouveia', 'gouveuaaa@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '1999-11-11', 'gougou', 0, '2025-06-10 18:45:10.639913'),
(90, 'Zdoca', 'david.fcg07@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '2000-11-11', 'zddeis', 0, '2025-06-19 16:43:17.104718'),
(91, 'Antonio', 'ammarcelos@gmail.com', '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257', '1973-06-26', 'marcelo', 2, '2025-06-28 18:04:39.186718'),
(92, 'Celia Maria Antunes Matos Silva', 'celia@gmail.com', '*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9', '2003-12-12', 'celia', 2, '2025-07-02 11:27:33.479357');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_utilizador` (`utilizador_id`),
  ADD KEY `idx_data` (`data`),
  ADD KEY `idx_publicacao_utilizador` (`id_publicacao`,`utilizador_id`);

--
-- Índices de tabela `conversas`
--
ALTER TABLE `conversas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_conversation` (`utilizador1_id`,`utilizador2_id`),
  ADD KEY `utilizador2_id` (`utilizador2_id`),
  ADD KEY `idx_ultima_atividade` (`ultima_atividade`);

--
-- Índices de tabela `mensagens`
--
ALTER TABLE `mensagens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversa_id` (`conversa_id`),
  ADD KEY `remetente_id` (`remetente_id`),
  ADD KEY `idx_data_envio` (`data_envio`),
  ADD KEY `idx_lida` (`lida`),
  ADD KEY `idx_tipo_mensagem` (`tipo_mensagem`);

--
-- Índices de tabela `notificacoes`
--
ALTER TABLE `notificacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `utilizador_id` (`utilizador_id`),
  ADD KEY `remetente_id` (`remetente_id`),
  ADD KEY `publicacao_id` (`publicacao_id`),
  ADD KEY `comentario_id` (`comentario_id`),
  ADD KEY `idx_data_criacao` (`data_criacao`),
  ADD KEY `idx_lida` (`lida`),
  ADD KEY `idx_utilizador_lida` (`utilizador_id`,`lida`),
  ADD KEY `idx_tipo_data` (`tipo`,`data_criacao`);

--
-- Índices de tabela `perfis`
--
ALTER TABLE `perfis`
  ADD PRIMARY KEY (`id_perfil`),
  ADD KEY `id_utilizador` (`id_utilizador`);

--
-- Índices de tabela `polls`
--
ALTER TABLE `polls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publicacao_id` (`publicacao_id`);

--
-- Índices de tabela `poll_opcoes`
--
ALTER TABLE `poll_opcoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `poll_id` (`poll_id`);

--
-- Índices de tabela `poll_votos`
--
ALTER TABLE `poll_votos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_poll` (`poll_id`,`utilizador_id`),
  ADD KEY `opcao_id` (`opcao_id`),
  ADD KEY `utilizador_id` (`utilizador_id`);

--
-- Índices de tabela `publicacao_likes`
--
ALTER TABLE `publicacao_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unq_like` (`publicacao_id`,`utilizador_id`),
  ADD KEY `utilizador_id` (`utilizador_id`),
  ADD KEY `idx_data` (`data`);

--
-- Índices de tabela `publicacao_medias`
--
ALTER TABLE `publicacao_medias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `publicacao_id` (`publicacao_id`);

--
-- Índices de tabela `publicacao_salvas`
--
ALTER TABLE `publicacao_salvas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `utilizador_id` (`utilizador_id`),
  ADD KEY `publicacao_id` (`publicacao_id`);

--
-- Índices de tabela `publicacoes`
--
ALTER TABLE `publicacoes`
  ADD PRIMARY KEY (`id_publicacao`),
  ADD KEY `id_utilizador` (`id_utilizador`);

--
-- Índices de tabela `seguidores`
--
ALTER TABLE `seguidores`
  ADD PRIMARY KEY (`id_seguidor`,`id_seguido`),
  ADD KEY `id_seguido` (`id_seguido`);

--
-- Índices de tabela `tipos_utilizador`
--
ALTER TABLE `tipos_utilizador`
  ADD PRIMARY KEY (`id_tipos_utilizador`);

--
-- Índices de tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `nome_usuario` (`nick`),
  ADD KEY `id_tipos_utilizador` (`id_tipos_utilizador`) USING BTREE;

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT de tabela `conversas`
--
ALTER TABLE `conversas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `mensagens`
--
ALTER TABLE `mensagens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT de tabela `notificacoes`
--
ALTER TABLE `notificacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de tabela `perfis`
--
ALTER TABLE `perfis`
  MODIFY `id_perfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `polls`
--
ALTER TABLE `polls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `poll_opcoes`
--
ALTER TABLE `poll_opcoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de tabela `poll_votos`
--
ALTER TABLE `poll_votos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de tabela `publicacao_likes`
--
ALTER TABLE `publicacao_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=231;

--
-- AUTO_INCREMENT de tabela `publicacao_medias`
--
ALTER TABLE `publicacao_medias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT de tabela `publicacao_salvas`
--
ALTER TABLE `publicacao_salvas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=144;

--
-- AUTO_INCREMENT de tabela `publicacoes`
--
ALTER TABLE `publicacoes`
  MODIFY `id_publicacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=260;

--
-- AUTO_INCREMENT de tabela `tipos_utilizador`
--
ALTER TABLE `tipos_utilizador`
  MODIFY `id_tipos_utilizador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `utilizadores`
--
ALTER TABLE `utilizadores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `comentarios`
--
ALTER TABLE `comentarios`
  ADD CONSTRAINT `comentarios_ibfk_1` FOREIGN KEY (`id_publicacao`) REFERENCES `publicacoes` (`id_publicacao`),
  ADD CONSTRAINT `comentarios_ibfk_2` FOREIGN KEY (`utilizador_id`) REFERENCES `utilizadores` (`id`),
  ADD CONSTRAINT `fk_publicacao` FOREIGN KEY (`id_publicacao`) REFERENCES `publicacoes` (`id_publicacao`) ON DELETE CASCADE;

--
-- Restrições para tabelas `conversas`
--
ALTER TABLE `conversas`
  ADD CONSTRAINT `conversas_ibfk_1` FOREIGN KEY (`utilizador1_id`) REFERENCES `utilizadores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `conversas_ibfk_2` FOREIGN KEY (`utilizador2_id`) REFERENCES `utilizadores` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `mensagens`
--
ALTER TABLE `mensagens`
  ADD CONSTRAINT `mensagens_ibfk_1` FOREIGN KEY (`conversa_id`) REFERENCES `conversas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `mensagens_ibfk_2` FOREIGN KEY (`remetente_id`) REFERENCES `utilizadores` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `notificacoes`
--
ALTER TABLE `notificacoes`
  ADD CONSTRAINT `notificacoes_ibfk_1` FOREIGN KEY (`utilizador_id`) REFERENCES `utilizadores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notificacoes_ibfk_2` FOREIGN KEY (`remetente_id`) REFERENCES `utilizadores` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notificacoes_ibfk_3` FOREIGN KEY (`publicacao_id`) REFERENCES `publicacoes` (`id_publicacao`) ON DELETE CASCADE,
  ADD CONSTRAINT `notificacoes_ibfk_4` FOREIGN KEY (`comentario_id`) REFERENCES `comentarios` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `perfis`
--
ALTER TABLE `perfis`
  ADD CONSTRAINT `perfis_ibfk_1` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id`);

--
-- Restrições para tabelas `polls`
--
ALTER TABLE `polls`
  ADD CONSTRAINT `polls_ibfk_1` FOREIGN KEY (`publicacao_id`) REFERENCES `publicacoes` (`id_publicacao`) ON DELETE CASCADE;

--
-- Restrições para tabelas `poll_opcoes`
--
ALTER TABLE `poll_opcoes`
  ADD CONSTRAINT `poll_opcoes_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `poll_votos`
--
ALTER TABLE `poll_votos`
  ADD CONSTRAINT `poll_votos_ibfk_1` FOREIGN KEY (`poll_id`) REFERENCES `polls` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `poll_votos_ibfk_2` FOREIGN KEY (`opcao_id`) REFERENCES `poll_opcoes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `poll_votos_ibfk_3` FOREIGN KEY (`utilizador_id`) REFERENCES `utilizadores` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `publicacao_likes`
--
ALTER TABLE `publicacao_likes`
  ADD CONSTRAINT `publicacao_likes_ibfk_1` FOREIGN KEY (`publicacao_id`) REFERENCES `publicacoes` (`id_publicacao`),
  ADD CONSTRAINT `publicacao_likes_ibfk_2` FOREIGN KEY (`utilizador_id`) REFERENCES `utilizadores` (`id`);

--
-- Restrições para tabelas `publicacao_medias`
--
ALTER TABLE `publicacao_medias`
  ADD CONSTRAINT `publicacao_medias_ibfk_1` FOREIGN KEY (`publicacao_id`) REFERENCES `publicacoes` (`id_publicacao`);

--
-- Restrições para tabelas `publicacao_salvas`
--
ALTER TABLE `publicacao_salvas`
  ADD CONSTRAINT `publicacao_salvas_ibfk_1` FOREIGN KEY (`utilizador_id`) REFERENCES `utilizadores` (`id`),
  ADD CONSTRAINT `publicacao_salvas_ibfk_2` FOREIGN KEY (`publicacao_id`) REFERENCES `publicacoes` (`id_publicacao`);

--
-- Restrições para tabelas `publicacoes`
--
ALTER TABLE `publicacoes`
  ADD CONSTRAINT `publicacoes_ibfk_1` FOREIGN KEY (`id_utilizador`) REFERENCES `utilizadores` (`id`);

--
-- Restrições para tabelas `seguidores`
--
ALTER TABLE `seguidores`
  ADD CONSTRAINT `seguidores_ibfk_1` FOREIGN KEY (`id_seguidor`) REFERENCES `utilizadores` (`id`),
  ADD CONSTRAINT `seguidores_ibfk_2` FOREIGN KEY (`id_seguido`) REFERENCES `utilizadores` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
