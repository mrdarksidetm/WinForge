---
title: WinForge
description: Optimize Windows 11 with ease – debloat, enhance, and customize.
theme: minima
plugins:
  - jekyll-feed
---

# 🌟 WinForge: Forge Your Windows, Effortlessly

![WinForge Banner](https://via.placeholder.com/1200x400/667eea/ffffff?text=WinForge+%E2%80%93+Optimize+Like+a+Pro)  
*Your all-in-one PowerShell wizard for a lean, lightning-fast, and *yours* Windows 11. Say goodbye to bloat—hello to bliss. No dev skills required; just pure customization joy.*

> 💡 **Pro Tip**: We're not just tweaking—we're *crafting*. Inspired by tinkerers like you, built with love by Mrdarksidetm.

## 🚀 Quick Install: One Command to Rule Them All

Fire up **PowerShell as Administrator** and paste this gem. It'll fetch the latest from GitHub and guide you through the fun.

### For the Bold (Direct Raw Script)
```powershell
irm https://raw.githubusercontent.com/mrdarksidetm/WinForge/main/src/WinForgeOptionalSetup.ps1 | iex
```

### Policy Hurdle? No Sweat
If scripts are blocked:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```
Then rerun the one-liner above. *Poof*—you're in business!

### Or, Auto-Fetch Latest Release (Fancy Edition)
Copy-paste this powerhouse—it grabs the freshest version dynamically:
```
$repo = "mrdarksidetm/WinForge"
$file = "WinForgeOptionalSetup.ps1"
$api  = "https://api.github.com/repos/$repo/releases/latest"
$dl   = (Invoke-RestMethod $api).assets | Where-Object name -eq $file | Select-Object -ExpandProperty browser_download_url
Invoke-WebRequest $dl -OutFile "$env:TEMP\WinForge.ps1"
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$env:TEMP\WinForge.ps1`""
```

> 🎉 **Done?** Answer Y/N prompts like a choose-your-own-adventure. Defaults to "safe mode" (N) so you stay in control.

## 🔮 What Does This Wizard Do?

WinForge isn't a script—it's your digital blacksmith. Here's the sparkle:

- **🗑️ Debloat & Optimize**: Launches [Chris Titus Tech's WinUtil](https://github.com/ChrisTitusTech/winutil) with a pre-baked preset (drop `Winforge-ChristitusConfigs.json` beside the script for auto-magic). Strip telemetry, apps, and cruft.
  
- **🛡️ Edge Exile + Tweaks**: Wields [WinHance](https://github.com/memstechtips/Winhance) to banish Microsoft Edge (gently) and polish your OS. Think: cleaner UI, smarter defaults.

- **🌐 Internet Glow-Up**: Pick your vibe—**Adblock 🚫** (AdGuard DNS for ad-free bliss) or **Fastest ⏩** (Cloudflare for warp-speed). Auto-configures DNS + DNS-over-HTTPS on Wi-Fi/Ethernet. *Privacy? Encrypted. Speed? Unmatched.*

- **🔄 Safety Net**: Removed Edge? No sweat—silently installs [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/) so your apps don't throw a tantrum.

- **🎨 Terminal Swagger**: Winget-installs Oh My Posh and slaps on the sleek "hul10" theme. Restart your shell—watch it glow. *Because who doesn't love a pretty prompt?*

All actions log to `~/Downloads/WinForge-OptionalSetup.log` for your peace of mind. Errors? We capture 'em structured (JSON/TXT exports) so debugging's a breeze.

## 📖 How to Wield the Forge

1. **Launch as Admin**: Right-click PowerShell > "Run as Administrator." Paste the one-liner.
2. **Choose Your Path**: Y/N for each step—debloat? Edge zap? DNS dance? Your call.
3. **WinUtil Preset Magic**: If you snagged the JSON config, hit "Import" in WinUtil when prompted. Folder opens for easy access.
4. **DNS Delight**: Adblock for zen, Fastest for zoom. Applies to active adapters; flushes cache for instant wins.
5. **WebView2 Whisper**: Post-Edge, it installs quietly (or interactively if needed).
6. **Theme It Up**: Oh My Posh awaits—reload your profile (`. $PROFILE`) for the reveal.
7. **Relaunch & Revel**: Close/reopen Terminal. *Voila—your Windows, reimagined.*

> ⚠️ **Heads Up**: Internet required. Windows 10/11 + PS 5.1+. Group Policy DNS? We'll warn ya.

## 🛠️ Requirements & Gotchas
- **OS**: Windows 10/11 (tested on 11 23H2+).
- **Privs**: Admin (duh—system tweaks!).
- **Net**: Active connection for downloads.
- **Trouble?** Check the log or ping me on GitHub Issues. We're in this together.

## 🙌 Credits: Standing on Giant Shoulders
- [Chris Titus Tech](https://github.com/ChrisTitusTech/winutil) – The debloat deity.
- [memstechtips](https://github.com/memstechtips/Winhance) – Edge-slaying sorcery.
- [Cloudflare DNS](https://developers.cloudflare.com/1.1.1.1/) & [AdGuard DNS](https://adguard-dns.io/en/public-dns.html) – Speed & shield masters.
- Oh My Posh by [JanDeDobbeleer](https://github.com/JanDeDobbeleer/oh-my-posh) – Theme wizardry.

*WinForge: Compiled with ❤️ for the customization crew. Not a dev? Neither am I—just a passionate pixel-pusher.*

## ☕ Sponsor the Forge
If this sparked joy (or saved your sanity), fuel the fire!  
<a href="https://www.buymeacoffee.com/mrdarksidetm"><img src="https://img.buymeacoffee.com/1ffc02d2-6b5a-4a1e-8c2f-2e7f8b8b8b8b.png" alt="Buy Me a Coffee" height="50"></a>  
[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/H2H21N0OAT)  
UPI: [abhisidetm@ptyes](https://www.upi.me/pay?pa=abhisidetm@ptyes&am=150)

> 🌟 **Future Tease**: Signed EXE wrapper incoming—stay tuned via [Releases](https://github.com/mrdarksidetm/WinForge/releases). Questions? [Open an Issue](https://github.com/mrdarksidetm/WinForge/issues). Let's build better Windows, one forge at a time.

---
*Last Forged: {{ site.time | date: '%B %Y' }} | [View on GitHub](https://github.com/mrdarksidetm/WinForge) | License: MIT*
