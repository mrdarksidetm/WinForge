---
layout: default
title: How WinForge Works
description: Detailed step-by-step explanation of what the WinForge v5.0 script does
---

# ⚙️ WinForge v5.0: Detailed Features

WinForge v5.0 is the "Next-Gen" 2026 edition, designed for Windows 11 power users who demand privacy, performance, and automation.

> [!IMPORTANT]
> WinForge v5.0 now includes explicit removal of **Windows Recall** and **Copilot** to ensure maximum privacy.

---

# 📋 Steps Performed (In Order)

### 1. Windows Activation (MAS)
- **Prompt:** "Activate Windows permanently (MAS)?"
- Uses the trusted [Microsoft Activation Script (MAS)](https://get.activated.win) to activate Windows securely.
- Supports HWID, Ohook, and KMS38 methods.

### 2. AI & Recall Purge (NEW)
- **Prompt:** "Purge AI & Recall (Copilot/Suggestions)?"
- **Recall Removal:** Disables Windows Recall (AI snapshots) via Group Policy/Registry.
- **Copilot Removal:** Completely disables the Copilot integration.
- **Ads & Suggestions:** Nukes "Suggestions", "Tips", and "Ads" from the Start Menu and Settings.

### 3. Game Mode / Performance Engine (NEW)
- **Prompt:** "Enable Ultimate Performance Mode?"
- **Ultimate Performance Plan:** Unlocks the hidden Windows 11 high-performance power scheme.
- **Game Mode:** Ensures Windows Game Mode is active for priority CPU/GPU scheduling.
- **Background Optimization:** Reduces background noise for maximum FPS and low latency.

### 4. Chris Titus Tech WinUtil
- **Prompt:** "Run Chris Titus WinUtil?"
- Downloads and launches the industry-standard [WinUtil](https://github.com/ChrisTitusTech/winutil).
- Allows for deep debloating, custom app installs, and advanced system tweaks.

### 5. Winget App Updater (NEW)
- **Prompt:** "Update all apps to latest versions (Winget)?"
- Runs `winget upgrade --all` to ensure all your installed software is up-to-date and secure.
- Accepts all source and package agreements automatically.

### 6. Secure DNS + DoH
- **Prompt:** "Secure DNS + DoH (Cloudflare/AdGuard)?"
- Configures **DNS-over-HTTPS (DoH)** for military-grade query encryption.
- Choice of **Cloudflare** (Speed) or **AdGuard** (Ad-blocking).
- Applies to all active physical network adapters (Ethernet/Wi-Fi).

### 7. Final Status & Self-Healing
- Displays a summary of successes and any errors encountered.
- **Cleanup:** Automatically deletes the temporary download cache (`C:\WinForgeCache`).
- **Logs:** Generates a detailed audit log in `Winforge_Logs/`.

---

# 🔥 Forge Handler: Technical Specs

### Privacy & Security
* **🔒 AI Removal:** Explicitly targets Windows Recall and Copilot to prevent unwanted data analysis.
* **🛡️ Encrypted DNS:** Forces DoH to prevent ISP monitoring and DNS hijacking.
* **⚡ Admin Safety:** Requires Administrator privileges to ensure system-level modifications are successful.

### Performance
* **🎮 Gaming Focus:** Prioritizes system resources for active applications (Game Mode).
* **🏎️ Power Scaling:** Enables the "Ultimate Performance" plan for desktop users.
* **📦 Winget Integration:** Leverages the native Windows Package Manager for safe, fast updates.

### Deployment
* **📦 Bulletproof Execution:** Comprehensive error handling prevents the script from crashing on non-standard Windows builds.
* **🌐 Global Compatibility:** Supports both IPv4 and IPv6 dual-stack environments.
* **📝 Detailed Auditing:** Every action is logged for transparency and troubleshooting.

---

**[← Back to Home](https://github.com/mrdarksidetm/WinForge)**