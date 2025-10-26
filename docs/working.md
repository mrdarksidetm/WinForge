---
layout: default
title: How WinForge Works
description: Detailed step-by-step explanation of what the WinForge script does
---

# ⚙️ How WinForge Works

The script is designed to minimize user interaction while maximizing customization. It provides interactive prompts for each optional step and includes custom import files for GUI programs to streamline setup.

> **⚠️ Warning:** This script offers to uninstall Microsoft Edge via the Winhance Tool. If you don't want Edge removed, deselect the option in the Winhance screen.

---

## 📋 Steps Performed (In Order)

### 1. Administrator Elevation & Logging Setup
- Checks if running as Administrator
- Auto-elevates if needed
- Creates a log file at `%USERPROFILE%\Downloads\WInForge-OptionalSetup.log`
- All actions are logged with timestamps

### 2. Chris Titus Tech WinUtil (Optional)
- **Prompt:** "Do you wanna debloat and Optimize your Windows?"
- Downloads and launches the Chris Titus Tech Windows Utility
- If `Winforge-ChristitusConfigs.json` exists, opens its location for easy import
- Allows custom debloat presets and system optimizations

### 3. WinHance Edge Removal (Optional)
- **Prompt:** "Do you wanna remove Edge and customize more?"
- Downloads the latest Winhance installer from GitHub releases
- Launches the installer for Edge removal and additional tweaks
- Creates scheduled tasks to prevent Edge reinstallation via Windows Update

### 4. Internet Optimization (Optional)
- **Prompt:** "Do you wanna optimise Internet?"
- Offers two DNS profiles:
  - **Adblock (AdGuard):** Blocks ads, trackers, and malware
    - IPv4: `94.140.14.14`, `94.140.15.15`
    - IPv6: `2a10:50c0::ad1:ff`, `2a10:50c0::ad2:ff`
  - **Fastest (Cloudflare):** Maximum speed and low latency
    - IPv4: `1.1.1.1`, `1.0.0.1`
    - IPv6: `2606:4700:4700::1111`, `2606:4700:4700::1001`
- Configures DNS-over-HTTPS (DoH) automatically
- Applies settings to all active Wi-Fi and Ethernet adapters

### 5. WebView2 Runtime Installation (Conditional)
- **Only runs if Edge was removed in Step 3**
- Downloads Microsoft Edge WebView2 Runtime (Bootstrap version)[^1]
- Attempts silent installation first
- Falls back to interactive installation if silent fails
- Prevents application breakage after Edge removal

### 6. Oh My Posh Terminal Customization (Optional)
- **Prompt:** "Do you wanna customize your Terminal?"
- Installs Oh My Posh via winget
- Downloads the `hul10` theme to `~/posh-themes/`
- Automatically updates PowerShell profile (`$PROFILE`)
- Adds initialization line: `oh-my-posh init pwsh --config "theme-path" | Invoke-Expression`
- Reloads profile to apply changes immediately

### 7. Final Status Report
- Displays success message if all steps completed without errors
- Shows detailed error report if any issues occurred
- Stops transcript logging
- Provides both GUI popup and console output

---

## 🔧 Technical Details

### Error Handling
- All steps wrapped in try-catch blocks
- Errors collected in ArrayList for final report
- Non-fatal errors don't stop execution
- Full error messages logged to file

### Network Adapter Detection
- Targets adapters with status "Up"
- Filters for Wi-Fi, WLAN, Wireless, or Ethernet in adapter name
- Applies DNS settings to all matching adapters
- Skips disconnected or disabled adapters

### Execution Policy Handling
- Script auto-elevates without permanently changing execution policy
- Uses `-ExecutionPolicy Bypass` only for this session
- No system-wide security changes

---

## 📝 Footnotes

[^1]: WebView2 Runtime automatically checks and downloads the latest correct version

---

**[← Back to Home]({{github.com/mrdarksidetm/winforge}}/)**
