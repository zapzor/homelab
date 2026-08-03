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
| **Network** | TP-Link Archer C7/OpenWrt, TP-Link TLSG105PE, 3x Deco Mesh M4/OpenWrt  |

---

## 🎯 Skills Demonstrated

| Skill | Experience |
|:---|:---|
| **Virtualization** | Proxmox VE, VMs/LXC, GPU passthrough |
| **Linux** | Debian administration, shell scripting, systemd, troubleshooting |
| **Networking** | VLANs, OpenWrt, WireGuard, DNS, firewall configuration |
| **Docker** | Docker Compose, networking, persistent volumes |
| **Reverse Proxy** | Traefik, TLS, Let's Encrypt |
| **Monitoring** | Prometheus, Grafana, ntfy alerts |
| **Backup & Recovery** | Proxmox backups, rsync, recovery documentation |
| **Security** | Network segmentation, VPN-only access, Pi-hole/Unbound |
| **Hardware** | Home server build, storage planning, GPU passthrough |

---

## 🧠 Some Lessons Learned

Most of this was figured out during the initial setup. Once it works, it tends to keep working, short of a hardware failure or trying to change or upgrade something.

**Docker vs. LXC** — Started with Docker for everything because that's what tutorials use. Some services (Pi-hole, WireGuard) fought Docker networking or needed host-level stuff that containers hide. LXC also had better Proxmox integration and less overhead. I Moved those services to LXC and kept Docker for things like Immich where the official docs assume Docker and I didn't want to maintain a custom install.

**GPU passthrough** — I needed GPU passthrough for Ollama (used for running language models). Proxmox UI has a checkbox for PCI device passthrough. Checked it, booted the LXC, nothing. Turns out LXC containers need to be privileged for PCI passthrough. The UI didn't mention this at the time. From that I learned to prefer doing things through the command line for better feedback as the UI doesn't always provide all the necessary information, or abstracts it.

**AI** - I've had a mixed experience with AI. I find it is faster when troubleshooting basic issues or queries like "how do I get the amount of available storage on a drive in PowerShell?". On the other hand, when it comes to more complex or bespoke problems, it tends to falter or provide hallucinated information (though it has gotten better at even these problems lately, depending on the model).

Generally, my troubleshooting process is to find the issue, check the logs, if it's something simple I'll fix it on the spot, if not, I'll provide AI with those logs and context, and if AI fails to make progress within 5 minutes, I will refer to the docs or Google. This tends to result in the fastest troubleshooting process for me.

**Logs** — Before I started using Linux, most of my technical problem solving was just googling things like "internet broken". However, since Linux exposes more diagnostic information than Windows, I've learnt to check the logs before searching online. A lot of the time they're self-describing and the issue is immediately obvious. If not, having a detailed error log to search for troubleshooting steps is much easier than a vague Google search. Now I always check the logs first before resorting to Google.

**Backups** — I use vzdump for my backups, with daily/weekly/monthly backups, so I assumed that meant I was covered. First time I actually tried restoring a VM to test, it didn't work. I was initially concerned about data corruption, but I tried restoring again, this time with the drive connected directly to the server. The network connection had dropped mid-transfer. The main lesson was that a backup is only as good as the restore process. I now test restores and validate backups with checksums rather than assuming they are working.

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
| **Ansible** | LXC | Ansible controller | Debian |
| **Proxmox Backup Server** | LXC | Backup platform | Debian |
| **Authelia** | LXC | SSO (single sign-on) | Debian |
| **Traefik** | LXC | Reverse proxy | Debian |
| **Tailscale** | LXC | Tailscale client/VPN | Debian |
| **Terraform** | LXC | Infrastructure provisioning | Debian |
| **OpenBao** | LXC | Secrets Manager | Debian |
| **Code Server** | LXC | Self-hosted VSCode | Debian |
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
| **Home Assistant** | VM | Home automation platform | HAOS |

**Cloud:**
| Name | Type | Purpose | OS |
|---|---|---|---|
| **Headscale** | EC2, t4g.micro | Tailscale coordinator | Debian |


---

## 📦 Containerized Services (Docker)


| Service | Purpose | Runs On |
|---|---|---|
| Joplin server | Note sync | Docker |
| Immich | Photo backup | Docker |

Docker runs inside the dedicated LXC above. Most services were previously running in Docker, but were migrated to LXC for lower overhead (~50MB of RAM per container) and better Proxmox integration. Docker is retained for services with complex dependencies or official Docker-only recommendations.

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

- **Reverse proxy:** Back to Traefik. I originally used it, but switched to Nginx Proxy Manager as creating new entries was faster. Migrated back to Traefik for improved Authelia integration and easier automation since I got better at scripting. If I ever find one with proper LXC integration I'll use that as I need to configure a new entry manually every time I add a new service right now.
- **TLS:** Let's Encrypt via DNS challenge via Cloudflare
- **External exposure:** Tailscale VPN (Wireguard backend), with a Headscale instance hosted on an EC2. I previously just used Wireguard but that required me to expose a port to the internet... admittedly, that port didn't show up on scanners and thus was very low risk, but I don't like exposing ports so I switched to Tailscale.

---

## 💾 Backups & Disaster Recovery

| What | Method | Frequency | Destination |
|---|---|---|---|
| **VM/LXC snapshots** | vzdump | daily, weekly, monthly; ~250GB total backup set | local disk + cloud |
| **Docker volumes/configs** | rsync | Daily | workstation + cloud |
| **Documentation** | Git | On change | GitHub (this repo) |

**Recovery plan:** Proxmox host rebuild from ISO + restore latest vzdump backups; Docker configs pulled from workstation. Restore can take ~14 hours from cloud, ~1 hour onsite.

Local backups are managed through Proxmox Backup Server (PBS). PBS has some advantages over a standard disk backup, such as deduplication, backup validation, and improved retention management. Previously just used vzdumps with native Proxmox features, but these weren't very reliable and I would have to restore a few times before one worked. PBS has solved this problem with the aforementioned features.

I then sync these backups to an S3 instance on AWS, using PBS. I previously synced them to a server hosted at another residence, but I wanted to get some experience with AWS and PBS offers a built in S3 API, so this seemed like a good opportunity to get some AWS experience. Depending on the costing, I may switch to a cheaper provider, or go back to my previous offsite self-hosted strategy.

---

## 🛠️ Monitoring

- Prometheus and Loki + Grafana for service, logs, and resource monitoring. I have alerts configured for when I am nearing storage capacity, CPU temperature is high or when services have broken. I use Grafana for data visualisation. I set this up after a drive died on me with little warning and so naturally I tried to figure out if I could get some kind of alert system configured that would let me know if my drives are dying based on SMART stats.
- Notification method: Amazon SES (SMTP server). I previously used Ntfy to push notifications to Telegram, but since I wanted AWS experience, and I prefer emails to push notifications, I switched to SES. Depending on the costs...

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
