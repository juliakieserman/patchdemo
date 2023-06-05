CREATE DATABASE IF NOT EXISTS patchdemo;

USE patchdemo;

CREATE TABLE IF NOT EXISTS wikis (
	wiki VARCHAR(32) NOT NULL,
	creator VARCHAR(255) NOT NULL,
	created DATETIME NOT NULL,
	patches TEXT,
	announcedTasks TEXT,
	PRIMARY KEY (wiki)
);

CREATE TABLE IF NOT EXISTS patches (
	patch VARCHAR(16) NOT NULL,
	status VARCHAR(16) NOT NULL,
	subject TEXT NOT NULL,
	message TEXT NOT NULL,
	updated DATETIME NOT NULL,
	PRIMARY KEY (patch)
);

CREATE TABLE IF NOT EXISTS tasks (
	task INT UNSIGNED NOT NULL,
	title TEXT NOT NULL,
	updated DATETIME NOT NULL,
	PRIMARY KEY(task)
);

-- NB: ADD COLUMN IF NOT EXISTS requires Maria DB >=10.219
ALTER TABLE `wikis`
	ADD COLUMN IF NOT EXISTS `timeToCreate` SMALLINT UNSIGNED NULL DEFAULT NULL AFTER `announcedTasks`;

ALTER TABLE `wikis`
	ADD INDEX IF NOT EXISTS `created` (`created`);

ALTER TABLE `wikis`
	ADD COLUMN IF NOT EXISTS `deleted` BIT NOT NULL DEFAULT 0 AFTER `timeToCreate`;

ALTER TABLE `tasks`
	ADD COLUMN IF NOT EXISTS `status` VARCHAR(16) NOT NULL AFTER `title`;

ALTER TABLE `wikis`
	ADD COLUMN IF NOT EXISTS `branch` VARCHAR(64) NOT NULL AFTER `patches`;

ALTER TABLE `wikis`
	ADD COLUMN IF NOT EXISTS `landingPage` VARCHAR(255) NULL DEFAULT NULL AFTER `announcedTasks`;

-- The default is initally set to 1 so any existing wikis are marked as installed
-- This only runs if the column doesn't exist yet
ALTER TABLE `wikis`
	ADD COLUMN IF NOT EXISTS `ready` BIT NOT NULL DEFAULT 1 AFTER `deleted`;

-- ...but we actually want the default to be zero
ALTER TABLE `wikis`
	CHANGE COLUMN `ready` `ready` BIT NOT NULL DEFAULT 0 AFTER `deleted`;

ALTER TABLE `wikis`
	ADD COLUMN IF NOT EXISTS `repos` TEXT NULL AFTER `branch`;
