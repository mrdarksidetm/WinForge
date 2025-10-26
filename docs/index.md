---
layout: default
title: WinForge
description: Optimize Windows 11 with ease – debloat, enhance, and customize.
---

# 🌟 WinForge: Forge Your Windows, Effortlessly

**The ultimate Windows 11 optimization toolkit** – integrate WinUtil debloating, WinHance enhancements, custom DNS + DoH, Edge removal with WebView2 safety, and Oh My Posh terminal theming.

---

## 🚀 Quick Install: One Command to Rule Them All

Fire up **PowerShell as Administrator** and paste this gem. It'll fetch the latest from GitHub and guide you through the fun.

If execution policy blocks scripts:

```Set-ExecutionPolicy -Scope CurrentUser RemoteSigned```

### For the Bold (Direct Raw Script)
```powershell
irm https://raw.githubusercontent.com/mrdarksidetm/WinForge/main/src/WinForgeOptionalSetup.ps1 | iex
```

### Method 2: Download Latest Release

```
$repo = "mrdarksidetm/WinForge"
$file = "WinForgeOptionalSetup.ps1"
$api = "https://api.github.com/repos/$repo/releases/latest"
$dl = (Invoke-RestMethod $api).assets | Where-Object name -eq $file | Select-Object -ExpandProperty browser_download_url
Invoke-WebRequest $dl -OutFile "$env:TEMP\WinForge.ps1"
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File "$env:TEMP\WinForge.ps1""
```

---

## ✨ Features

- 🧹 **Windows Debloat** – Launch Chris Titus Tech WinUtil with optional preset import
- 🚫 **Edge Removal** – Remove Microsoft Edge using WinHance tool
- 🌐 **Internet Optimization** – Configure DNS + DoH (AdGuard Adblock or Cloudflare Fastest)
- 🛡️ **WebView2 Safety** – Auto-install WebView2 Runtime if Edge removed to prevent app breakage
- 🎨 **Terminal Theming** – Oh My Posh with hul10 theme for beautiful PowerShell prompts
- 📋 **Complete Logging** – All actions logged to Downloads\WInForge-OptionalSetup.log

---

## 📖 How It Works

The script runs through **5 optional interactive steps**:

1. **Debloat & Optimize** – Launches Chris Titus Tech WinUtil for bloatware removal and system tweaks
2. **Edge Removal** – Downloads and launches WinHance for Edge cleanup and additional customization
3. **Internet Optimization** – Configures DNS servers and DNS-over-HTTPS on active adapters
4. **WebView2 Installation** – Installs Microsoft WebView2 Runtime if Edge was removed
5. **Terminal Customization** – Installs Oh My Posh and applies the hul10 theme

[View detailed workflow →](https://github.com/mrdarksidetm/WinForge/blob/main/docs/working.md)

---

## ⚙️ Requirements

- **OS:** Windows 10 (1809+) or Windows 11
- **PowerShell:** Version 5.1 or higher
- **Privileges:** Administrator (script auto-elevates)
- **Internet:** Active connection required

---

## 💫 Credits

- [Chris Titus Tech](https://github.com/ChrisTitusTech/winutil) – WinUtil
- [memstechtips](https://github.com/memstechtips/Winhance) – WinHance
- [Cloudflare](https://developers.cloudflare.com/1.1.1.1/setup/) – DNS
- [AdGuard](https://adguard-dns.io/en/public-dns.html) – DNS

---

## 💝 Support

If WinForge helps you, consider supporting the project:

<div style="display: flex; gap: 10px; align-items: center; margin-top: 20px;">
  <a href="https://www.buymeacoffee.com/mrdarksidetm" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="50">
  </a>
  <a href="https://ko-fi.com/H2H21N0OAT" target="_blank">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Ko-fi" height="50">
  </a>
</div>

---

## 📄 License

MIT License – See [LICENSE](https://github.com/mrdarksidetm/WinForge/blob/main/LICENSE) for details.

---

**Made by Mrdarksidetm (Abhijeet Yadav)** 🚀
