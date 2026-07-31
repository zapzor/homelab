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
| **Workloads** | 25+ VMs / LXC containers, Docker inside several |
| **Network** | TP-Link Archer C7/OpenWrt, TP-Link TLSG105PE  |

---

## 🎯 Skills Demonstrated

| Skill | Experience |
|:---|:---|
| **Virtualization** | Proxmox VE, VMs/LXC, GPU passthrough |
| **Linux** | Debian administration, shell scripting, systemd, troubleshooting |
| **Networking** | VLANs, OpenWrt, WireGuard, DNS, firewall configuration |
| **Docker** | Docker Compose, networking, persistent volumes |
| **Reverse Proxy** | Nginx Proxy Manager, TLS, Let's Encrypt |
| **Monitoring** | Prometheus, Grafana, ntfy alerts |
| **Backup & Recovery** | Proxmox backups, rsync, recovery documentation |
| **Security** | Network segmentation, VPN-only access, Pi-hole/Unbound |
| **Hardware** | Home server build, storage planning, GPU passthrough |

---

## 🧠 Some Lessons Learned

Most of this was figured out during the initial setup. Once it works, it tends to keep working, short of a hardware failure or trying to change or upgrade something. 

**Docker vs. LXC** — Started with Docker for everything because that's what tutorials use. Some services (Pi-hole, WireGuard) fought Docker networking or needed host-level stuff that containers hide. LXC also had better proxmox integration and less overhead. Moved them to LXC. Kept Docker for things like Immich where the official docs assume Docker and I didn't want to maintain a custom install.

**GPU passthrough** — I needed gpu passthrough for Ollama (used for running language models). Proxmox UI has a checkbox for PCI device passthrough. Checked it, booted the LXC, nothing. Turns out LXC containers need to be privileged for PCI passthrough. The UI didn't mention this at the time, so from that I learned to prefer doing things through the command line for better feedback.

**Storage** — Initially, I used a 125GB drive for the boot drive, thinking it would be sufficient. But as the number of services grew, I realised I would need more storage. I upgraded to a larger SSD a few months later. Should have planned for 2–3x from the start.

**Logs** — Before I started using Linux, most of my technical problem solving was just googling things like "internet broken". However, since Linux exposes more information than Windows, I've learnt to check the logs before searching online. A lot of the time they're self-describing and the issue is immediately obvious. If not, having a detailed error log to search for troubleshooting steps is much easier than a vague google search. So now I always check the logs before resorting to google.

**Backups** — I use vzdump for my backups, with dailies, weeklies, and monthlies. I assumed that meant I was covered. First time I actually tried restoring a VM to test, it didn't work. I was initially concerned about data corruption, but I tried restoring again, this time with the drive connected directly to the server. The network connection dropped mid-transfer. Since then, I validate backups with checksums before trusting them.

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
- **Backup method:** vzdump to internal and external (off premise) drive - see [Backups & Disaster Recovery](#-backups--disaster-recovery)

### VMs & LXC Containers

| Name | Type | Purpose | OS |
|---|---|---|---|
| **Wireguard** | LXC | VPN | Debian |
| **Mediaserver** | LXC | Media server / file storage | Debian |
| **Pi-hole** | LXC | DNS filtering | Debian |
| **Postgresql** | LXC | SQL Database | Debian
| **Loki** | LXC | Log aggregation/SIEM | Debian
| **Docker** | LXC | Docker containers | Debian |
| **Changedetection** | LXC | Monitors websites for changes | Debian |
| **Nginx proxy manager** | LXC | Reverse proxy | Debian |
| **Frigate** | LXC | CCTV monitoring | Debian |
| **Grafana** | LXC | Data visualization | Debian |
| **Prometheus** | LXC | Event monitoring | Debian |
| **Kali** | LXC | Pen testing | Debian |
| **Ansible** | LXC | Ansible controller | Debian |
| **Proxmox Backup Server** | LXC | Backup platform | Debian |
| **Infisical** | LXC | Secrets management | Debian |
| **Authelia** | LXC | SSO (single sign-on) | Debian |
| **Windows** | VM | Windows Server 2022 — AD/GPO/RDS lab | Windows Server 2022 (evaluation) |
| **Home Assistant** | VM | Home automation platform | HAOS |


---

## 📦 Containerized Services (Docker)


| Service | Purpose | Runs On |
|---|---|---|
| Joplin server | Note sync | Docker |
| Immich | Photo backup | Docker |

Docker runs inside the dedicated LXC above. Most services were previously running in Docker, but were migrated to LXC for lower overhead (~50MB of RAM per container) and better proxmox integration. Docker is retained for services with complex dependencies or official Docker-only recommendations.

---

## 🌐 Network

| | |
|---|---|
| **Router/Firewall** | OpenWrt |
| **Switch** | Managed, TLSG105PE |
| **Wi-Fi** | Archer C7 Router, Deco Mesh M4 AP  |
| **VLANs** | 2 VLANs, one for IoT and another for management traffic. |
| **DNS/Ad-blocking** | Pi-hole, running as LXC above |
| **Remote access** | WireGuard |

---

## 🔒 Security

| Layer | Control |
|:---|:---|
| **Network segmentation** | 4 VLANs to isolate IoT, Guest, Management, and Main traffic |
| **Remote access** | WireGuard only; no services exposed to the internet |
| **DNS filtering** | Pi-hole blocks ads/malware at the network level |
| **Encryption** | TLS via Let's Encrypt for internal services; VPN tunnel for remote access |
| **Host hardening** | Proxmox web UI restricted to management VLAN; SSH key-based auth, root login disabled |

Running LXC containers with privileged flags (required for some bind mounts) does increase attack surface vs. unprivileged containers. While the attack surface is reduced by VPN-only access, I still minimize privileged containers as a defense-in-depth measure.

I also use an SSO service, Authelia, for MFA support and making tracking login details easier.

### Reverse Proxy / Access

- **Reverse proxy:** Nginx Proxy Manager
- **TLS:** Let's Encrypt via DNS challenge
- **External exposure:** None — LAN + VPN only

---

## 💾 Backups & Disaster Recovery

| What | Method | Frequency | Destination |
|---|---|---|---|
| **VM/LXC snapshots** | vzdump | daily, weekly, monthly; ~250GB total backup set | local disk + cloud |
| **Docker volumes/configs** | rsync | Daily | workstation + cloud |
| **Documentation** | Git | On change | GitHub (this repo) |

**Recovery plan:** Proxmox host rebuild from ISO + restore latest vzdump backups; Docker configs pulled from workstation. Restore can take ~14 hours from cloud, ~1 hour onsite. 

Local backups are managed through Proxmox Backup Server (PBS). PBS has some advantages over a standard disk backup, such as deduplication, backup validation, and improved retention management. 

I then sync these backups to an S3 instance on AWS, using PBS. I previously synced them to a server hosted at another residence, but I wanted to get some experience with AWS and PBS offers a built in S3 API, so this seemed like a good opportunity to do so. Depending on the costing, I may switch to a cheaper provider, or go back to my previous offsite self-hosted strategy.

---

## 🛠️ Monitoring

- Prometheus and Loki + Grafana for service, logs, and resource monitoring. They alert me of things like storage capacity, CPU temperature and broken services.
- Notification method — Amazon SES (SMTP server). I previously used ntfy to push notifications to Telegram, but since I wanted AWS experience, I switched to SES. Depending on the costs...

---

## 🗺️ Roadmap

| Goal | Priority | Blocker |
|---|---|---|
| IaC | High | Learning Ansible and Terraform |
| Another node for backups | Medium | Another server |
| K3s instance | Low | Migrating Docker and configuring K3s |

---

## 📸 Network Diagram / Screenshots

<img width="1000" alt="Network Diagram" src="https://github.com/user-attachments/assets/0ef7ed96-d031-4423-91ca-46bb580d9ea6" />
<img width="1000" alt="proxmox_metrics" src="https://github.com/user-attachments/assets/f1e1c7dc-a786-48b4-91de-a02548d85263" />
<img width="1000" alt="Grafana dashboard showing resource utilization" src="https://github.com/user-attachments/assets/7d44e1c9-005b-4808-9088-94202115c88a" />
<img width="1000" alt="Grafana dashboard part 2" src="https://github.com/user-attachments/assets/d2df7b17-b993-4a47-86e4-389ae78a7116" />
