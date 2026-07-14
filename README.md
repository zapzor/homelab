# 🏠 Homelab

A single-node home lab built on a repurposed PC, running Proxmox as the hypervisor with a mix of VMs, LXC containers, and Docker workloads.

![Status](https://img.shields.io/badge/status-active-brightgreen) ![Proxmox](https://img.shields.io/badge/hypervisor-Proxmox%20VE-orange) ![Docker](https://img.shields.io/badge/containers-Docker-blue)

---

## 📋 Overview

| | |
|---|---|
| **Hardware** | 1x repurposed PC |
| **Hypervisor** | Proxmox VE 9 |
| **Workloads** | 15+ VMs / LXC containers, Docker inside several |
| **Network** | TP-Link Archer C7/OpenWRT + TL-SG105PE, VLAN-segmented |
| **Uptime target** | 24x7 |

This lab started as a way to self-host services , and has grown into a small self-hosted platform for media, home automation, dev/test, backups, etc..

---

## 🖥️ Hardware

Repurposed PC:

| Component | Spec |
|---|---|
| CPU | i5-6400 |
| RAM | 64GB DDR4 |
| Storage | 1TB NVMe boot + 2x2TB backup/media storage |
| GPU | GTX 1060 — passed through for transcoding |
| Network | onboard 1GbE |

> 💡 *Note: single-node setups mean no hardware redundancy — see [Backups](#-backups--disaster-recovery) for how failure is handled.*

---



*Last updated: `<14/07/26>`*
