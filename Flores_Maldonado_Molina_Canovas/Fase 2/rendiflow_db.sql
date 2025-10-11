-- --------------------------------------------------------
-- Host:                         No.
-- Server version:               PostgreSQL 17.6 on aarch64-unknown-linux-musl, compiled by gcc (Alpine 14.2.0) 14.2.0, 64-bit
-- Server OS:                    
-- HeidiSQL Version:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES  */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for function public.update_updated_at_column
DELIMITER //
CREATE FUNCTION "update_updated_at_column"() RETURNS UNKNOWN AS $$ 
		BEGIN
			NEW.updated_at = CURRENT_TIMESTAMP;
			RETURN NEW;
		END;
		 $$//
DELIMITER ;

-- Dumping structure for table public.bun_migrations
CREATE TABLE IF NOT EXISTS "bun_migrations" (
	"id" SERIAL NOT NULL,
	"name" VARCHAR NULL DEFAULT NULL,
	"group_id" BIGINT NULL DEFAULT NULL,
	"migrated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
);

-- Data exporting was unselected.

-- Dumping structure for table public.bun_migration_locks
CREATE TABLE IF NOT EXISTS "bun_migration_locks" (
	"id" SERIAL NOT NULL,
	"table_name" VARCHAR NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("table_name")
);

-- Data exporting was unselected.

-- Dumping structure for table public.categories
CREATE TABLE IF NOT EXISTS "categories" (
	"id" TEXT NOT NULL,
	"company_id" TEXT NULL DEFAULT NULL,
	"code" VARCHAR(100) NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"system" BOOLEAN NOT NULL DEFAULT false,
	"active" BOOLEAN NOT NULL DEFAULT true,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_categories_company_id" ON "" ("company_id");
CREATE INDEX "idx_categories_code" ON "" ("code");;

-- Data exporting was unselected.

-- Dumping structure for table public.companies
CREATE TABLE IF NOT EXISTS "companies" (
	"id" TEXT NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"rut" VARCHAR(50) NULL DEFAULT NULL,
	"tax_id" VARCHAR(100) NULL DEFAULT NULL,
	"tax_id_type" VARCHAR(20) NULL DEFAULT NULL,
	"active" BOOLEAN NOT NULL DEFAULT true,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"country" INTEGER NOT NULL,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_companies_name" ON "" ("name");
CREATE INDEX "idx_companies_rut" ON "" ("rut");;

-- Data exporting was unselected.

-- Dumping structure for table public.credentials
CREATE TABLE IF NOT EXISTS "credentials" (
	"id" TEXT NOT NULL,
	"user_id" UUID NOT NULL,
	"type" VARCHAR(50) NOT NULL,
	"hash" BYTEA NOT NULL,
	"algorithm" VARCHAR(255) NOT NULL,
	"enabled" BOOLEAN NOT NULL DEFAULT true,
	"last_used_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_credentials_user_id" ON "" ("user_id");;

-- Data exporting was unselected.

-- Dumping structure for table public.extraction_records
CREATE TABLE IF NOT EXISTS "extraction_records" (
	"id" TEXT NOT NULL,
	"receipt_id" TEXT NOT NULL,
	"company_id" TEXT NOT NULL,
	"extraction_data" JSONB NOT NULL,
	"confidence_score" NUMERIC(3,2) NULL DEFAULT NULL,
	"extracted_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_extraction_records_receipt_id" ON "" ("receipt_id");;

-- Data exporting was unselected.

-- Dumping structure for table public.identities
CREATE TABLE IF NOT EXISTS "identities" (
	"id" TEXT NOT NULL,
	"user_id" UUID NOT NULL,
	"type" VARCHAR(50) NOT NULL,
	"provider" VARCHAR(100) NOT NULL,
	"external_subject" VARCHAR(255) NULL DEFAULT NULL,
	"value" VARCHAR(255) NOT NULL,
	"email_hash" BYTEA NULL DEFAULT NULL,
	"enabled" BOOLEAN NOT NULL DEFAULT true,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_identities_user_id" ON "" ("user_id");
CREATE INDEX "idx_identities_type_value" ON "" ("type", "value");;

-- Data exporting was unselected.

-- Dumping structure for table public.memberships
CREATE TABLE IF NOT EXISTS "memberships" (
	"id" TEXT NOT NULL,
	"company_id" TEXT NOT NULL,
	"role" VARCHAR(50) NOT NULL,
	"permissions" JSONB NULL DEFAULT NULL,
	"active" BOOLEAN NOT NULL DEFAULT true,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"user_id" UUID NOT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("user_id", "company_id"),
	CONSTRAINT "fk_memberships_user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
)
CREATE INDEX "idx_memberships_company_id" ON "" ("company_id");;

-- Data exporting was unselected.

-- Dumping structure for table public.monthly_reports
CREATE TABLE IF NOT EXISTS "monthly_reports" (
	"id" TEXT NOT NULL,
	"company_id" TEXT NOT NULL,
	"user_id" UUID NULL DEFAULT NULL,
	"year" INTEGER NOT NULL,
	"month" INTEGER NOT NULL,
	"status" VARCHAR(50) NOT NULL DEFAULT 'generating',
	"total_net" BIGINT NOT NULL DEFAULT 0,
	"total_vat" BIGINT NOT NULL DEFAULT 0,
	"total_gross" BIGINT NOT NULL DEFAULT 0,
	"category_breakdown" JSONB NULL DEFAULT NULL,
	"generated_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"failed_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_monthly_reports_company_id" ON "" ("company_id");
CREATE INDEX "idx_monthly_reports_year_month" ON "" ("year", "month");;

-- Data exporting was unselected.

-- Dumping structure for table public.prompts
CREATE TABLE IF NOT EXISTS "prompts" (
	"id" SERIAL NOT NULL,
	"prompt" TEXT NOT NULL,
	"created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
);

-- Data exporting was unselected.

-- Dumping structure for table public.receipts
CREATE TABLE IF NOT EXISTS "receipts" (
	"id" TEXT NOT NULL,
	"company_id" TEXT NOT NULL,
	"user_id" UUID NOT NULL,
	"supplier_rut" VARCHAR(50) NULL DEFAULT NULL,
	"supplier_tax_id" VARCHAR(100) NULL DEFAULT NULL,
	"supplier_name" VARCHAR(255) NULL DEFAULT NULL,
	"folio" VARCHAR(255) NOT NULL,
	"issue_date" TIMESTAMPTZ NOT NULL,
	"currency" VARCHAR(3) NOT NULL DEFAULT 'CLP',
	"net_amount" BIGINT NOT NULL,
	"vat_amount" BIGINT NOT NULL,
	"total_amount" BIGINT NOT NULL,
	"category_id" TEXT NULL DEFAULT NULL,
	"notes" TEXT NULL DEFAULT NULL,
	"status" VARCHAR(50) NOT NULL DEFAULT 'pending_processing',
	"source" VARCHAR(50) NOT NULL DEFAULT 'upload',
	"pdf417_raw" TEXT NULL DEFAULT NULL,
	"duplicate_key" BYTEA NULL DEFAULT NULL,
	"has_image" BOOLEAN NOT NULL DEFAULT false,
	"processed_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"supplier_country" INTEGER NULL DEFAULT NULL,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_receipts_status" ON "" ("status");
CREATE INDEX "idx_receipts_issue_date" ON "" ("issue_date");
CREATE INDEX "idx_receipts_duplicate_key" ON "" ("duplicate_key");
CREATE INDEX "idx_receipts_company_id" ON "" ("company_id");
CREATE INDEX "idx_receipts_user_id" ON "" ("user_id");;

-- Data exporting was unselected.

-- Dumping structure for table public.receipt_images
CREATE TABLE IF NOT EXISTS "receipt_images" (
	"id" TEXT NOT NULL,
	"receipt_id" TEXT NOT NULL,
	"company_id" TEXT NOT NULL,
	"kind" VARCHAR(50) NOT NULL DEFAULT 'original',
	"bucket" VARCHAR(255) NOT NULL,
	"object_key" VARCHAR(500) NOT NULL,
	"mime_type" VARCHAR(100) NOT NULL,
	"size_bytes" BIGINT NOT NULL,
	"width" INTEGER NULL DEFAULT NULL,
	"height" INTEGER NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_receipt_images_receipt_id" ON "" ("receipt_id");;

-- Data exporting was unselected.

-- Dumping structure for table public.receipt_items
CREATE TABLE IF NOT EXISTS "receipt_items" (
	"id" TEXT NOT NULL,
	"receipt_id" TEXT NOT NULL,
	"description" TEXT NOT NULL,
	"quantity" NUMERIC(10,3) NOT NULL,
	"unit_price" BIGINT NOT NULL,
	"total_price" BIGINT NOT NULL,
	"currency" TEXT NOT NULL DEFAULT 'CLP',
	"sku" TEXT NULL DEFAULT NULL,
	"notes" TEXT NULL DEFAULT NULL,
	"line_order" INTEGER NOT NULL DEFAULT 0,
	"created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"emoji" TEXT NULL DEFAULT NULL,
	"emoji_code_points" TEXT NULL DEFAULT NULL,
	"color" TEXT NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fk_receipt_items_receipt" FOREIGN KEY ("receipt_id") REFERENCES "receipts" ("id") ON UPDATE NO ACTION ON DELETE CASCADE
)
CREATE INDEX "idx_receipt_items_receipt_id" ON "" ("receipt_id");
CREATE INDEX "idx_receipt_items_line_order" ON "" ("receipt_id", "line_order");;

-- Data exporting was unselected.

-- Dumping structure for table public.refresh_tokens
CREATE TABLE IF NOT EXISTS "refresh_tokens" (
	"id" TEXT NOT NULL,
	"user_id" UUID NOT NULL,
	"token_hash" BYTEA NOT NULL,
	"expires_at" TIMESTAMPTZ NOT NULL,
	"revoked_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_refresh_tokens_user_id" ON "" ("user_id");
CREATE INDEX "idx_refresh_tokens_expires_at" ON "" ("expires_at");;

-- Data exporting was unselected.

-- Dumping structure for table public.users
CREATE TABLE IF NOT EXISTS "users" (
	"id" UUID NOT NULL DEFAULT gen_random_uuid(),
	"email" VARCHAR(255) NOT NULL,
	"first_name" VARCHAR(255) NOT NULL,
	"last_name" VARCHAR(255) NOT NULL,
	"primary_role" VARCHAR(50) NOT NULL DEFAULT 'user',
	"mfa_enabled" BOOLEAN NOT NULL DEFAULT false,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"last_login_at" TIMESTAMPTZ NULL DEFAULT NULL,
	"display_name" VARCHAR(255) NULL DEFAULT NULL,
	"country" INTEGER NOT NULL,
	"phone" VARCHAR(20) NULL DEFAULT NULL,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_users_email" ON "" ("email");
CREATE INDEX "idx_users_created_at" ON "" ("created_at");
CREATE INDEX "idx_users_primary_role" ON "" ("primary_role");;

-- Data exporting was unselected.

-- Dumping structure for table public.validation_snapshots
CREATE TABLE IF NOT EXISTS "validation_snapshots" (
	"id" TEXT NOT NULL,
	"receipt_id" TEXT NOT NULL,
	"company_id" TEXT NOT NULL,
	"snapshot_data" JSONB NOT NULL,
	"created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ("id")
)
CREATE INDEX "idx_validation_snapshots_receipt_id" ON "" ("receipt_id");;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
