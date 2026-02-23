# Dao — Technical Infrastructure

Technical infrastructure supporting the Dao nonprofit and community.

## Hosting Philosophy
- **Cloud (Digital Ocean, etc.):** Services that must be 24/7 and immediately available (e.g., messaging, critical comms)
- **Self-hosted (Synology):** Everything else — favor Synology to reduce ongoing cloud costs. Brief downtime (e.g., ~1 hour) is acceptable.

## Services

### Mattermost
- **URL:** `mm.tongde.us`
- **Host:** Digital Ocean (keep — messaging is critical, must be 24/7)
- **Stack:** Mattermost v9 (Docker), Postgres, Nginx
  - Containers: `docker-mattermost-1`, `docker-postgres-1`, `nginx_mattermost`
  - Location: `/home/mattermost/docker`
  - SSL: `/etc/letsencrypt/live/mm.tongde.us/` (mounted into `nginx_mattermost`)
  - Restart Mattermost: `docker restart docker-mattermost-1`
  - Restart Nginx: `docker restart nginx_mattermost`
  - SSL renewal: `sudo certbot renew --force-renewal --webroot -w /var/lib/docker/volumes/shared-webroot/_data`
  - Keep both Certbot systemd timer and cron job active — do not remove either

### Ghost (Blog/Publishing)
- **URLs:** `en.tongde.us` (English), `zh.tongde.us` (Chinese, port 2369)
- **Host:** Digital Ocean (same Droplet as Mattermost; Nginx routes between them)
- `en.tongde.us` moved from `philmd.info`

### Ebooks Platform
- **URL:** `books.tongde.us`
- **Current host:** External (not yet self-hosted)
- **Plan:** Migrate to Synology — downtime of ~1 hour acceptable, no need for 24/7 uptime
- **Status:** [ ] To do

## To-Do
- [ ] Migrate `books.tongde.us` to Synology self-hosted

## Notes
- Hostinger shared hosting account also in use (hosts multiple websites) — details TBD
