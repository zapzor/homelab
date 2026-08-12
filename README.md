# 🏠 Homelab

A single-node home lab built from a repurposed PC, grown from a few self-hosted services into a platform for learning Linux system administration, networking, and infrastructure automation. Runs on Proxmox VE with VLAN segmentation, automated backup validation, and VPN-secured remote access.

![Status](https://img.shields.io/badge/status-active-brightgreen) ![Proxmox](https://img.shields.io/badge/hypervisor-Proxmox%20VE-orange) ![Docker](https://img.shields.io/badge/containers-Docker-blue)
<img width="1000" alt="proxmox_metrics" src="https://github.com/user-attachments/assets/1207113c-eec1-4304-acb8-5229a0ba4626" />



---

## 📋 Overview

| | |
|---|---|
| **Hardware** | 1x repurposed PC |
| **Hypervisor** | Proxmox VE 9 |
| **Workloads** | 30+ VMs / LXC containers, Docker inside several |
| **Network** | TP-Link Archer C7/OpenWrt, TP-Link TLSG105PE, 3x Deco Mesh M4/OpenWrt  |

---

## 🖥️ Hardware

Repurposed PC:
| Component | Spec |
|---|---|
| CPU | i5-6400 |
| RAM | 32GB DDR4 |
| Storage | KINGSTON SA400S37480G (SATA 500GB, boot/host/workloads, LVM-thin) + ST2000VN004-2E4164 (SATA 2TB, data storage, ZFS) |
| GPU | GTX 1060 — passed through for transcoding |
| Network | Onboard 1GbE |

---

## 🧱 Virtualization Layer — Proxmox VE

Proxmox is installed directly on bare metal and hosts everything below.

- **Storage backend:** LVM-thin / directory + ZFS
- **Networking:** Linux bridge — see [Network](#-network)
- **Backup method:** vzdump to internal and off premise drive - see [Backups & Disaster Recovery](#-backups--disaster-recovery)

### VMs & LXC Containers


**Infrastructure:**
| Name | Type | Purpose | OS |
|---|---|---|---|
| **Wireguard** | LXC | VPN | Debian |
| **Mediaserver** | LXC | Media server / file storage | Debian |
| **Pi-hole** | LXC | DNS filtering | Debian |
| **Postgresql** | LXC | SQL database | Debian
| **Loki** | LXC | Log aggregation/SIEM | Debian
| **Docker** | LXC | Docker containers | Debian |
| **Grafana** | LXC | Data visualization | Debian |
| **Prometheus** | LXC | Event monitoring | Debian |
| **Proxmox Backup Server** | LXC | Backup platform | Debian |
| **Authelia** | LXC | SSO (single sign-on) | Debian |
| **Traefik** | LXC | Reverse proxy | Debian |
| **Tailscale** | LXC | Tailscale client/VPN | Debian |
| **OpenBao** | LXC | Secrets Manager | Debian |
| **Code Server** | LXC | Coding and IaC management | Debian |
| **Ntfy** | LXC | Notification service | Debian |
| **Alloy** | LXC | Data collector for Loki| Debian |
| **Windows** | VM | Windows Server 2022 - AD/GPO/RDS lab | Windows Server 2022 (evaluation) |

**Personal services:**
| Name | Type | Purpose | OS |
|---|---|---|---|
| **Vikunja** | LXC | TODO app | Debian |
| **Frigate** | LXC | CCTV monitoring | Debian |
| **Mqtt** | LXC | MQTT broker (home automation) | Debian |
| **Kali** | LXC | Pen testing | Debian |
| **Caliweb** | LXC | Ebook server | Debian |
| **Gramps** | LXC | Family tree | Debian |
| **Ollama** | LXC | LLM server | Debian |
| **Changedetection** | LXC | Monitors websites for changes | Debian |
| **Homepage** | LXC | Home lab dashboard | Debian |
| **Commafeed** | LXC | RSS server | Debian |
| **Navidrome** | LXC | Music server | Debian |
| **Home Assistant** | VM | Home automation platform | HAOS |

**Cloud:**
| Name | Type | Purpose | OS |
|---|---|---|---|
| **Headscale** | t4g.micro | Tailscale coordinator | Debian |

An EC2 instance running on AWS. Right now, I just use it as a control server for Tailscale but some day I'd like to expand it to host these docs on Gitea. On a separate instance of course.

**Docker:**
| Name | Type | Purpose | OS |
|---|---|---|---|
| Joplin server | Docker Container | Note sync | Debian |

A single Docker container runs inside the dedicated LXC above. Most services were previously running in Docker, but were migrated to LXC for lower overhead and better Proxmox integration. Docker is retained for services with complex dependencies or official Docker-only recommendations.

---

## 🌐 Network

| | |
|---|---|
| **Router/Firewall** | OpenWrt |
| **Switch** | Managed, TLSG105PE |
| **Wi-Fi** | Archer C7 Router, Deco Mesh M4 AP  |
| **VLANs** | 2 VLANs, one for IoT and another for management traffic. |
| **DNS/Ad-blocking** | Pi-hole, running as LXC above |
| **Remote access** | Tailscale |

---

## 🔒 Security

| Layer | Control |
|:---|:---|
| **Network segmentation** | 4 VLANs to isolate IoT, Guest, Management, and Main traffic |
| **Remote access** | Tailscale only; no services exposed to the internet |
| **DNS filtering** | Pi-hole blocks ads/malware at the network level |
| **Encryption** | TLS via Let's Encrypt for internal services; VPN tunnel for remote access |
| **Host hardening** | Proxmox web UI restricted to management VLAN; SSH key-based auth, root login disabled |

Running LXC containers with privileged flags (required for some bind mounts) does increase attack surface vs. unprivileged containers. While the attack surface is reduced by VPN-only access, I still minimize privileged containers as a defense-in-depth measure.

I also use an SSO service, Authelia, for MFA support and making tracking login details easier.

### Reverse Proxy / Access

- **Reverse proxy:** Back to Traefik. I originally used it, but switched to Nginx Proxy Manager as creating new entries was faster. Migrated back to Traefik for improved Authelia integration and easier automation since I got better at scripting. If I ever find one with proper LXC integration I'll use that as I need to configure a new entry manually every time I add a new service right now.
- **TLS:** Let's Encrypt via DNS challenge via Cloudflare
- **External exposure:** Tailscale VPN (Wireguard), with a Headscale instance hosted on an EC2. I previously just used standard Wireguard but that required me to expose a port to the internet... admittedly, that port didn't show up on scanners and thus was very low risk, but I don't like exposing ports so I switched to Tailscale.

---

## 💾 Backups & Disaster Recovery

Local backups are managed through Proxmox Backup Server (PBS). PBS has some advantages over a standard disk backup, such as deduplication, backup validation, and improved retention management. Previously just used vzdumps with native Proxmox features, but these weren't very reliable and I would have to restore a few times before one worked. PBS has solved this problem with the aforementioned features.

I then sync these backups to an S3 instance on AWS, using PBS. I previously synced them to a server hosted at another residence, but I wanted to get some experience with AWS and PBS offers a built in S3 API, so this seemed like a good opportunity to get some AWS experience. Depending on the costing, I may switch to a cheaper provider, or go back to my previous offsite self-hosted strategy.

| What | Method | Frequency | Destination |
|---|---|---|---|
| **VM/LXC snapshots** | vzdump | daily, weekly, monthly; ~250GB total backup set | local disk + cloud |
| **Docker volumes/configs** | rsync | Daily | workstation + cloud |
| **Documentation** | Git | On change | GitHub (this repo) |

**Recovery plan:** Proxmox host rebuild from ISO + restore latest vzdump backups; Docker configs pulled from workstation. Restore can take ~14 hours from cloud, ~1 hour onsite.

---

## 🛠️ Monitoring

I use Grafana for alerting with Prometheus and Loki configured as datasources. When I try to centralize my databases (for experimentation, not efficiency) I plan to add PostgreSQL as a datasource. My router firmware (OpenWRT) has a compatible Prometheus exporter so I don't need SNMP right now, but that would be the next thing on the list if I ever get network gear that requires it. I'd like to add CloudWatch as another when I expand my AWS infrastructure further.

Grafana is very useful for visualizing data on my infrastructure. I have Unified Alerts configured to alert me via an SMTP server (AWS SES) when certain conditions are met, such as a systemd service failing on the hypervisor or a workload running out of memory. I previously used Ntfy to push notifications to Telegram, but since I wanted AWS experience, and I prefer emails to push notifications for this stuff, I switched to SES.

I decided I needed an alerting/monitoring system after a drive died on me without warning. The data was backed up so nothing critical was lost, but I would have liked some advance warning before that happened, so setting up Grafana was the next step.

### Prometheus Alerts (`proxmox_nodes` + `proxmox_vms`, 30s eval)

| Alert | Severity | Query |
|-------|----------|-------|
| Node Down | critical | `up{job="pve"}` |
| High CPU | warning | `100 - avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100` |
| High Memory | critical | `(MemTotal - MemAvailable) / MemTotal * 100` |
| High Load | warning | `node_load1 / count(node_cpu_seconds_total{mode="idle"})` |
| Disk Full | warning | `(1 - filesystem_avail / filesystem_size) * 100` |
| Root Full | warning | same, `{mountpoint="/"}` |
| Low Inodes | warning | `files_free / files * 100` |
| Swap High | warning | `(SwapTotal - SwapFree) / SwapTotal * 100` |
| Net RX Errors | warning | `rate(node_network_receive_errs_total[5m])` |
| Net TX Errors | warning | `rate(node_network_transmit_errs_total[5m])` |
| ZFS Scrub Overdue | warning | `time() - node_zfs_zpool_scrub_time &gt; 35d` |
| CPU Temp | critical | `node_hwmon_temp_celsius{sensor=~"core.*"}` |
| SMART Failing | critical | `smartctl_device_smart_healthy == 0` |
| Reallocated Sectors | critical | `smartctl_device_reallocated_sector_ct &gt; 0` |
| Pending Sectors | warning | `smartctl_device_pending_sector_ct &gt; 0` |
| Systemd Failed | warning | `node_systemd_unit_state{state="failed"} == 1` |
| VM High CPU | warning | `pve_cpu_usage_ratio * 100` |
| VM High Memory | warning | `pve_memory_usage_bytes / pve_memory_size_bytes * 100` |
| Storage Full | warning | `pve_storage_used_bytes / pve_storage_size_bytes * 100` |

### Loki Alerts (`proxmox_logs`, 60s eval, 5m window)

| Alert | Severity | Query |
|-------|----------|-------|
| OOM Kill | critical | `count_over_time({job="proxmox-syslog"} \|= "Out of memory" [5m])` |
| Disk I/O Errors | critical | `... \|= "I/O error"` |
| Failed Logins | info | `... \|= "authentication failure"` (&gt;5) |
| Privilege Escalation | info | `... \|= "sudo:" \|~ "USER=root\|COMMAND="` |
| Kernel Panic | critical | `... \|~ "Kernel panic\|BUG:\|Call trace\|..."` |
| Segfault | warning | `... \|= "segfault"` |

---

## ⚙️ IaC

I’m starting to codify my homelab infrastructure with Terraform. Right now it's just a basic inventory of my lab environment, but I'd like to expand it to include CI/CD and use Ansible for configuration management.

---

## 🗺️ Roadmap

| Goal | Priority | Blocker |
|---|---|---|
| IaC | High | Learning Ansible and Terraform |
| Host docs on AWS + Gitea | Medium | Configuration |
| Another node for backups | Low | Another server. Expensive. |
| K3s LXC | Low | Migrating Docker and configuring K3s |

---

## 📸 Screenshots

<img width="1000" alt="proxmox_metrics" src="https://github.com/user-attachments/assets/f1e1c7dc-a786-48b4-91de-a02548d85263" />
<img width="1000" alt="Grafana dashboard showing resource utilization" src="https://github.com/user-attachments/assets/7d44e1c9-005b-4808-9088-94202115c88a" />
<img width="1000" alt="Grafana dashboard part 2" src="https://github.com/user-attachments/assets/d2df7b17-b993-4a47-86e4-389ae78a7116" />
