# 🏠 Homelab

A single-node home lab built on a repurposed PC, running Proxmox as the hypervisor with a mix of VMs, LXC containers, and Docker workloads.

![Status](https://img.shields.io/badge/status-active-brightgreen) ![Proxmox](https://img.shields.io/badge/hypervisor-Proxmox%20VE-orange) ![Docker](https://img.shields.io/badge/containers-Docker-blue)

---

## 📋 Overview

| | |
|---|---|
| **Hardware** | 1x repurposed PC |
| **Hypervisor** | Proxmox VE 9 |
| **Workloads** | 30+ VMs / LXC containers, Docker inside several |
| **Network** | TP-Link Archer C7/OpenWrt, TP-Link TLSG105PE  |
| **Uptime target** | 24x7 |

This lab started as a way to self-host services, and has grown into a small self-hosted platform for media, home automation, dev/test, backups, etc..

---

## 🖥️ Hardware

Repurposed PC:
| Component | Spec |
|---|---|
| CPU | i5-6400 |
| RAM | 32GB DDR4 |
| Storage | 1TB NVMe boot + 1+2TB backup/media storage |
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
| Wireguard | LXC | VPN | Debian |
| Mediaserver | LXC | Media server / file storage | Debian |
| Pi-hole | LXC | DNS filtering | Debian |
| Docker | LXC | Docker containers | Debian |
| changedetection | LXC | Monitors websites for changes | Debian |
| Nginx proxy manager | LXC | reverse proxy | Debian |
| Frigate | LXC | CCTV monitoring | Debian |
| mqtt | LXC | Home automation protocol | Debian |
| Caliweb | LXC | Calibre Web | Debian |
| Home Assistant | VM | Home automation platform | HAOS |
| Grafana | LXC | Data visualization | Debian |
| Prometheus | LXC | Event monitoring | Debian |
| Kali | LXC | Pen testing | Kali Linux |
| Homepage | LXC | Services overview | Debian |
| Commafeed | LXC | RSS feed | Debian |
| Windows | VM | Windows Server 2022 | Windows |

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
| **Router/Firewall** | OpenWrt |
| **Switch** | Managed, TLSG105PE |
| **Wi-Fi** | Archer C7 Router, Deco Mesh M4 AP  |
| **VLANs** | Management, Homelab, IoT, Guest |
| **DNS/Ad-blocking** | Pi-hole, running as LXC above |
| **Remote access** | WireGuard |

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

**Recovery plan:** Proxmox host rebuild from ISO + restore latest vzdump backups; Docker configs pulled from PC. Restore can take more than a day from cloud, around 2 hours onsite.

---

## 🛠️ Monitoring

- Grafana + Prometheus for service and resource monitoring
- Notification method —  Ntfy alerts on service downtime

---

## 🎯 Skills Demonstrated

| Skill | Evidence in This Lab |
|:---|:---|
| **Virtualization** | Proxmox VE bare-metal hypervisor, VM/LXC provisioning, GPU passthrough (GTX 1060), resource allocation |
| **Linux Administration** | Debian-based LXC containers, package management, shell scripting, systemd services, log troubleshooting |
| **Networking** | VLAN segmentation (IoT), OpenWrt router/firewall config, WireGuard VPN, DNS (Pi-hole + Unbound), TCP/IP troubleshooting |
| **Containerization** | Docker Compose workloads, container networking, volume management, image updates |
| **Reverse Proxy & Web Services** | Nginx Proxy Manager, TLS termination, Let's Encrypt DNS challenges, internal service exposure |
| **Monitoring & Observability** | Prometheus metrics collection, Grafana dashboards, Ntfy alerting on service downtime |
| **Backup & Disaster Recovery** | vzdump scheduling, rsync automation, offsite/cloud replication, documented RTO/RPO, recovery runbooks |
| **Security & Hardening** | Network segmentation, zero external exposure policy, DNS-based ad/malware filtering, VPN-only remote access |
| **Infrastructure as Code** | Git-tracked configs, Docker Compose files, version-controlled documentation |
| **Hardware & Systems** | Repurposed PC build, storage planning (NVMe + HDD tiering), GPU passthrough configuration |

## 🗺️ Roadmap

- [ ] Add Proxmox Backup Server
- [ ] Move DNS to VLAN-isolated LXC
- [ ] Automate backup testing
- [ ] Separate VLAN for server
- [ ] ...

---

## 📸 Screenshots / Diagram

![Network Diagram](network-diagram.svg)
<img width="1920" height="963" alt="prox_dash" src="https://github.com/user-attachments/assets/1207113c-eec1-4304-acb8-5229a0ba4626" />
<img width="1920" height="964" alt="homepage" src="https://github.com/user-attachments/assets/b3470baf-151b-4b60-b03f-4aaa0ada8b65" />
<img width="1920" height="968" alt="grafana" src="https://github.com/user-attachments/assets/7d44e1c9-005b-4808-9088-94202115c88a" />
<img width="1920" height="959" alt="grafana_2" src="https://github.com/user-attachments/assets/d2df7b17-b993-4a47-86e4-389ae78a7116" />
