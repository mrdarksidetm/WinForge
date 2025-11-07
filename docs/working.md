---
layout: default
title: How WinForge Works
description: Detailed step-by-step explanation of what the WinForge script does
---

# ⚙️ WinForge Detailed Features

The script is designed to respect user interaction while maximizing customization. It provides interactive prompts for each optional step and includes custom import files for GUI programs to streamline setup.

> [!WARNING]
> This script offers to uninstall Microsoft Edge via the Winhance Tool. If you don't want Edge removed, deselect the option in the Winhance screen.

---

# 📋 Steps Performed (In Order)

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


# 🔥Forge Handler
A very detailed to display everything the script requires and how its performs on your system. This is for nerds who wanna know every feature of that simple script.
### Installation & Compatibility
* **💻 Windows 11 Optimized:** Specifically designed and tested for Windows 11 (22H2+) with full native API support and latest feature compatibility​

* **🏗️ Universal Architecture:** Compatible with both x64 (recommended) and x86 Windows 11 installations without code modifications​

* **🔵 PowerShell 7+ Required:** Latest PowerShell 7.x (Core) with enhanced security features, better performance, and cross-platform capabilities​

* **👨‍💼 Administrator Required:** Automatic elevation to Administrator privileges with UAC prompts for system modifications (transparent, non-blocking)​

* **🎯 Interactive CLI Interface:** User-friendly prompts (Yes/No questions) with default options for hands-off automation or manual control​

* **🖱️ GUI Dialog Boxes:** Information boxes for important notifications and configuration steps (uses Windows Forms for accessibility)​

### Security Features
* **🔒 TLS 1.2+ Enforcement:** All downloads use encrypted HTTPS connections with certificate validation to prevent man-in-the-middle attacks​

* **🚨 Error Handling & Recovery:** Comprehensive try-catch error handling for every critical operation with graceful failure modes and detailed error reporting​

* **📋 Structured Error Objects:** Detailed error logs with exception type, HResult code, stack traces, and inner exception messages for diagnostics​

* **✅ Success Tracking:** Detailed logging of all successful operations for compliance auditing and troubleshooting verification​

* **🔄 Atomic Transactions:** DNS and network operations are applied per-adapter with individual error handling to prevent partial failures​

* **🛡️ Execution Policy Respect:** Script respects Windows Execution Policies and recommends RemoteSigned policy for safe execution​

### Advanced Features
* **🎯 Selective Module Installation:** Choose which components to install (debloat, Edge removal, DNS, terminal) - not all-or-nothing approach​

* **⏱️ Timeout Support:** Read-YesNo function supports optional timeouts for automated/headless deployments with configurable defaults​

* **🔍 Multi-Choice Selection:** Read-Choice function for selecting between profiles (AdGuard vs Cloudflare) with fuzzy matching (accepts 'A' for Adblock)​

* **🌐 Network Adapter Detection:** Automatic detection and enumeration of active physical network adapters (Ethernet, Wi-Fi, WLAN) with exclusion of virtual adapters​

* **📡 DNS Cache Flushing:** Automatic DNS cache clear after configuration changes for immediate effect on name resolution​

* **🔗 IPv6 Compatibility:** Full IPv6 address support (dual IPv4/IPv6 DNS) for modern networks with fallback to IPv4-only if needed​

* **📝 Configuration Import:** Chris Titus WinUtil configuration file (JSON) auto-import with folder navigation for easy preset loading​

* **🔗 GitHub Release Integration:** Automatic download of latest releases from GitHub repositories (ChrisTitusTech, Winhance, Microsoft) ensuring up-to-date tools​

### Code Quality & Standards
* **✨ PSScriptAnalyzer Compliant:** Enterprise-grade code meeting all Microsoft PowerShell best practices and security standards (0 errors)​

* **📦 Modular Functions:** Each feature (DNS, WebView2, terminal, logging) is a separate function for maintainability, testing, and reusability​

* **🎓 Documentation:** Inline comments and function help for easy understanding and modification by other developers​

* **🔄 SemVer Versioning:** Semantic versioning (2.1.4) for tracking fixes, features, and breaking changes​

* **🛠️ PS2EXE Compatible:** Can be compiled to standalone .EXE with PS2EXE-GUI for distribution without PowerShell runtime dependency​

* **⚙️ CmdletBinding Support:** Uses PowerShell's [CmdletBinding()] for consistent behavior with built-in cmdlets and pipeline compatibility​

### Deployment & Support
* **📦 Single File Deployment:** Entire setup as one .ps1 file - easy to copy, share, and version control (no dependencies)​

* **🌐 GitHub Repository:** Open-source on GitHub (mrdarksidetm/WinForge) with issue tracking, releases, and community contributions​

* **📊 GitHub Pages Documentation:** Live site at https://mrdarksidetm.github.io/WinForge/ with guides, FAQs, and update notes​

* **💬 Community Support:** Open issues for bug reports and feature requests with responsive maintenance and updates​

* **🚀 Continuous Deployment:** GitHub Actions auto-deploys documentation and releases with zero-downtime updates​



## 📝 Footnotes

WebView2 Runtime automatically checks and downloads the latest correct version

---

**[← Back to Home](github.com/mrdarksidetm/WinForge)**