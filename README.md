# 🏠 HomeLab

A single-node home lab built on a repurposed PC, running Proxmox as the hypervisor with a mix of VMs, LXC containers, and Docker workloads.

![Status](https://img.shields.io/badge/status-active-brightgreen) ![Proxmox](https://img.shields.io/badge/hypervisor-Proxmox%20VE-orange) ![Docker](https://img.shields.io/badge/containers-Docker-blue)

---

## 📋 Overview

| | |
|---|---|
| **Hardware** | 1x repurposed PC |
| **Hypervisor** | Proxmox VE 9 |
| **Workloads** | 15+ VMs / LXC containers, Docker inside several |
| **Network** | TP-Link Archer C7/OpenWrt, TLSG105PE  |
| **Uptime target** | 24x7 |

This lab started as a way to self-host services, and has grown into a small self-hosted platform for media, home automation, dev/test, backups, etc..

---

## 🖥️ Hardware

Repurposed PC:
| Component | Spec |
|---|---|
| CPU | i5-6400 |
| RAM | 32GB DDR4 |
| Storage | 1TB NVMe boot + 2x2TB backup/media storage |
| GPU | GTX 1060 — passed through for transcoding |
| Network | Onboard 1GbE |

> 💡 *Note: single-node setups mean no hardware redundancy — see [Backups](#-backups--disaster-recovery) for how failure is handled.*

---

## 🧱 Virtualization Layer — Proxmox VE

Proxmox is installed directly on bare metal and hosts everything below.

- **Storage backend:** LVM-thin / directory
- **Networking:** Linux bridge — see [Network](#-network)
- **Backup method:** vzdump to internal and external (off premise) drive

### VMs & LXC Containers

| Name | Type | Purpose | OS |
|---|---|---|---|
| Wireguard | LXC | VPN | Debian |
| Turnkey | LXC | Media server / file storage | Debian |
| Pi-hole | LXC | DNS filtering | Debian |
| Docker | LXC | Docker containers | Debian |
| changedetection | LXC | Monitors websites for changes | Debian |
| Audiobookshelf | LXC | Audiobook storage | Debian |
| Nginx proxy manager | LXC | reverse proxy | Debian |
| Frigate | LXC | CCTV monitoring | Debian |
| mqtt | LXC | Home automation protocol | Debian |
| Caliweb | LXC | epub storage | Debian |
| Home Assistant | VM | Home automation platform | HAOS |
| Grafana | LXC | Data visualization | Debian |
| Prometheus | LXC | Event monitoring | Debian |
| Kali | LXC | Pen testing | Kali Linux |
| Homepage | LXC | Services overview | Debian |
| Commafeed | LXC | RSS feed | Debian |
| Windows | VM | Windows Server | Windows |

## 📦 Containerized Services (Docker)

Docker runs inside dedicated VMs/LXCs above (not directly on the Proxmox host, keeping the hypervisor clean).

| Service | Purpose | Runs On |
|---|---|---|
| Joplin server | Note sync | Docker |
| Redlib | Reddit frontend | Docker |
| Immich | Photo backup | Docker |

Compose files are organized as:
```
docker/
├── Joplin server/
│   └── docker-compose.yml
├── Redlib/
│   └── docker-compose.yml
└── Immich/
    └── docker-compose.yml
```


## 🌐 Network

| | |
|---|---|
| **Router/Firewall** | OpenWRT |
| **Switch** | Managed, TLSG105PE |
| **Wi-Fi** | Deco Mesh M4  |
| **VLANs** | Management, Homelab, IoT, Guest |
| **DNS/Ad-blocking** | Pi-hole, running as LXC above |
| **Remote access** | WireGuard |

> 🔒 Internal IP ranges, hostnames, and access credentials are intentionally omitted from this public documentation.

### Reverse Proxy / Access

- **Reverse proxy:** Nginx Proxy Manager
- **TLS:** Let's Encrypt via DNS challenge
- **External exposure:** None — LAN + VPN only

---

## 💾 Backups & Disaster Recovery

Since this is a single point of failure, backups matter more than usual here:

| What | Method | Frequency | Destination |
|---|---|---|---|
| VM/LXC snapshots | vzdump | Daily AND weekly | local disk + cloud |
| Docker volumes/configs | rsync | Daily | My PC + cloud |
| Documentation & IaC | Git | On change | GitHub (this repo) |

**Recovery plan:** Proxmox host rebuild from ISO + restore latest vzdump backups; Docker configs pulled from PC

---

## 🛠️ Monitoring

- Grafana + Prometheus for service and resource monitoring
- Notification method —  ntfy alerts on service downtime

---

## 🗺️ Roadmap

- [ ] Migrate VMs/LXCs from Debian to Rocky Linux
- [ ] Add Proxmox Backup Server
- [ ] Move DNS to VLAN-isolated LXC
- [ ] ...

---

------------------- WIP -------------------
