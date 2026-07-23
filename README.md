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

Most of this was figured out during setup. Once it works, it tends to keep working, short of a hardware failure (in my experience). Things generally break when you try changing something without first reviewing the documentation.

**Docker vs. LXC** — Started with Docker for everything because that's what tutorials use. Some services (Pi-hole, WireGuard) fought Docker networking or needed host-level stuff that containers hide. Moved them to LXC. Kept Docker for things like Immich where the official docs assume Docker and I didn't want to maintain a custom install.

**GPU passthrough** — I needed gpu passthrough for Ollama (used for running language models). Proxmox UI has a checkbox for PCI device passthrough. Checked it, booted the LXC, nothing. Turns out LXC containers need to be privileged for PCI passthrough. The UI didn't mention this at the time, so from that I learned to prefer doing things through the command line for better feedback.

**Storage** — Initially, I used a 150GB drive for the boot drive, thinking it would be sufficient. But as the number of services grew, I realised I would need more storage. I upgraded to a larger SSD a few months later. Should have planned for 2–3x from the start.

**Network segmentation** — IoT VLAN wasn't hard to configure, but it was annoying to retrofit after already having a few devices on the main LAN and having to reconfigure some smart home gear. Do the VLANs first.

**Backups** — vzdump runs daily incrementals and weekly fulls. I assumed that meant I was covered. First time I actually tried restoring a VM to test, it didn't work. I was initially concerned about data corruption, but I tried restoring again, this time with the drive connected directly to the server. Turns out the network connection dropped mid-transfer. Now I validate backups with checksums before trusting them.

---

## 🖥️ Hardware

Repurposed PC:
| Component | Spec |
|---|---|
| CPU | i5-6400 |
| RAM | 32GB DDR4 |
| Storage | KINGSTON SA400S37480G (SATA 500GB boot/lvm) + ST2000VN004-2E4164 (SATA 2TB backup/media storage) |
| GPU | GTX 1060 — passed through for transcoding |
| Network | Onboard 1GbE |

---

## 🧱 Virtualization Layer — Proxmox VE

Proxmox is installed directly on bare metal and hosts everything below.

- **Storage backend:** LVM-thin / directory
- **Networking:** Linux bridge — see [Network](#-network)
- **Backup method:** vzdump to internal and external (off premise) drive

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
| **Home Assistant** | VM | Home automation platform | HAOS |
| **Grafana** | LXC | Data visualization | Debian |
| **Prometheus** | LXC | Event monitoring | Debian |
| **Kali** | LXC | Pen testing | Kali Linux |
| **Windows** | VM | Windows Server 2022 — AD/GPO/RDS lab | Windows Server 2022 (evaluation) |


---

## 📦 Containerized Services (Docker)


| Service | Purpose | Runs On |
|---|---|---|
| Joplin server | Note sync | Docker |
| Immich | Photo backup | Docker |

Docker runs inside the dedicated LXC above. Most services were previously running in Docker, but were migrated to LXC for lower overhead (~50MB of RAM per container) and better proxmox integration. Docker is retained for services with complex dependency trees or official Docker-only recommendations.

---

## 🌐 Network

| | |
|---|---|
| **Router/Firewall** | OpenWrt |
| **Switch** | Managed, TLSG105PE |
| **Wi-Fi** | Archer C7 Router, Deco Mesh M4 AP  |
| **VLANs** | 1 VLAN to isolate IoT, planned expansion for server and management traffic |
| **DNS/Ad-blocking** | Pi-hole, running as LXC above |
| **Remote access** | WireGuard |

---

## 🔒 Security

| Layer | Control |
|:---|:---|
| **Network segmentation** | 1 VLAN to isolate IoT, planned expansion for server and management traffic |
| **Remote access** | WireGuard only; no services exposed to the internet |
| **DNS filtering** | Pi-hole blocks ads/malware at the network level |
| **Encryption** | TLS via Let's Encrypt for internal services; VPN tunnel for remote access |
| **Host hardening** | Proxmox web UI restricted to management VLAN; SSH key-based auth, root login disabled |

Running LXC containers with privileged flags (required for some bind mounts) increases attack surface vs. unprivileged containers. While the attack surface is reduced by VPN-only access, I still plan to minimize privileged containers as a defense-in-depth measure. Evaluating Proxmox Backup Server as part of recovery hardening.

### Reverse Proxy / Access

- **Reverse proxy:** Nginx Proxy Manager
- **TLS:** Let's Encrypt via DNS challenge
- **External exposure:** None — LAN + VPN only

---

## 💾 Backups & Disaster Recovery

Since this is a single point of failure, backups matter more than usual here:

| What | Method | Frequency | Destination |
|---|---|---|---|
| **VM/LXC snapshots** | vzdump | daily, weekly; ~250GB total backup set | local disk + cloud |
| **Docker volumes/configs** | rsync | Daily | workstation + cloud |
| **Documentation** | Git | On change | GitHub (this repo) |

**Recovery plan:** Proxmox host rebuild from ISO + restore latest vzdump backups; Docker configs pulled from workstation. Restore can take ~14 hours from cloud, ~1 hour onsite. My "cloud" is a old laptop with a 2TB disk, hosted offsite. Since cloud restores have been unreliable in my experience, I have an rsync cronjob configured which syncs the vzdumps to the cloud with checksum validation. In the event I need to restore from the cloud, I have a local disk I can rsync those vzdumps to, then restore from that disk.

---

## 🛠️ Monitoring

- Grafana + Prometheus for service and resource monitoring
- Notification method —  ntfy alerts on service downtime

---

## 🗺️ Roadmap

| Goal | Priority | Blocker |
|---|---|---|
| Proxmox Backup Server | High | Need another server |
| Automate backup testing | High | PBS deployment |
| Ansible automation | Medium | Learning Ansible |
| VLAN-isolated DNS | Low | Need another switch |
| Separate server VLAN | Low | Need another switch |

---

## 📸 Network Diagram / Screenshots

<img width="1000" alt="Network Diagram" src="https://github.com/user-attachments/assets/0ef7ed96-d031-4423-91ca-46bb580d9ea6" />
<img width="1000" alt="proxmox_metrics" src="https://github.com/user-attachments/assets/f1e1c7dc-a786-48b4-91de-a02548d85263" />
<img width="1000" alt="Grafana dashboard showing resource utilization" src="https://github.com/user-attachments/assets/7d44e1c9-005b-4808-9088-94202115c88a" />
<img width="1000" alt="Grafana dashboard part 2" src="https://github.com/user-attachments/assets/d2df7b17-b993-4a47-86e4-389ae78a7116" />
