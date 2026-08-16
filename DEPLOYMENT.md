# CareerForge AI Deployment Guide

## cPanel upload
Upload all files to your hosting account. Point the domain document root to `public/` when possible; otherwise keep the included root `.htaccess`.

## Database
1. Create a MySQL 8 database in cPanel.
2. Create a database user and assign all privileges.
3. Import `database/schema.sql` with phpMyAdmin.
4. Copy `config/config.example.php` to `config/config.local.php` and enter credentials.

## PHP
Use PHP 8.2 or newer with PDO MySQL, cURL, mbstring, JSON, OpenSSL, fileinfo, and GD/Imagick if available.

## Admin setup
Run `/install` after upload to create the first Super Admin, configure app URL, SMTP, OAuth, AI providers, payment providers, and then lock the installer.

## SMTP
Configure host, port, username, password, encryption, from email, and from name in Admin → Email Settings. Send a test email before enabling verification.

## Google OAuth
Create OAuth credentials in Google Cloud, set the redirect URL shown in Admin → Google Login, and paste client ID/secret. Google login remains optional.

## AI providers
Go to Admin → AI Providers and add OpenAI, Gemini, Anthropic, or an OpenAI-compatible provider. Set model names manually, priority, temperature, token limits, and cost estimates.

## Payments
Configure Stripe, Razorpay, Cashfree, or PayU credentials in Admin → Payments. Always verify webhooks/server callbacks before activating subscriptions.

## Cron jobs
Configure cPanel cron commands:

```bash
/usr/local/bin/php /home/ACCOUNT/public_html/cron/subscriptions.php
/usr/local/bin/php /home/ACCOUNT/public_html/cron/email_queue.php
/usr/local/bin/php /home/ACCOUNT/public_html/cron/cleanup.php
/usr/local/bin/php /home/ACCOUNT/public_html/cron/analytics.php
```

## SSL and security checklist
Enable SSL, set secure cookies to true, rotate the app security key, remove write access from code directories, keep backups outside public web paths, and lock `/install` after completion.

## Production test checklist
Registration, login, verification, reset, CV CRUD, AI success/failure/fallback, credit deduction, ATS scan, PDF print/export, public CV, payments, admin login, provider management, SMTP, mobile layouts, and database relationships.
