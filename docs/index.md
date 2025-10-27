---
layout: default
title: WinForge – Windows Optimization Toolkit
description: 🚀 Streamline Windows 11: Debloat with WinUtil, enhance via WinHance, tune DNS, remove Edge safely, and theme your terminal. Privacy-first, one-click magic.
---

# 🌟 WinForge: Forge Your Windows, Effortlessly

![WinForge Banner](assets\images\icons\android-chrome-192x192.png)  
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
```
powershellSet-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Then rerun the one-liner above. _Poof_—you're in business!

## Or, Auto-Fetch Latest Release (Fancy Edition)
Copy-paste this powerhouse—it grabs the freshest version dynamically:

```
powershell$repo = "mrdarksidetm/WinForge"
$file = "WinForgeOptionalSetup.ps1"
$api  = "https://api.github.com/repos/$repo/releases/latest"
$dl   = (Invoke-RestMethod $api).assets | Where-Object name -eq $file | Select-Object -ExpandProperty browser_download_url
Invoke-WebRequest $dl -OutFile "$env:TEMP\WinForge.ps1"
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$env:TEMP\WinForge.ps1`""
```

🎉 **Done?** Answer Y/N prompts like a choose-your-own-adventure. Defaults to **"safe mode" (N)** so you stay in control.

## 🔮 What Does This Wizard Do?
WinForge isn't a script—it's your digital blacksmith. Here's the sparkle:

* **🗑️ Debloat & Optimize:** Launches [Chris Titus Tech's WinUtil](https://github.com/ChrisTitusTech/winutil) with a pre-baked preset (drop Winforge-ChristitusConfigs.json beside the script for auto-magic). Strip telemetry, apps, and cruft.
* **🛡️ Edge Exile + Tweaks:** Wields [WinHance](https://github.com/memstechtips/Winhance) to banish Microsoft Edge (gently) and polish your OS. Think: cleaner UI, smarter defaults.
* **🌐 Internet Glow-Up:** Pick your vibe—Adblock 🚫 (AdGuard DNS for ad-free bliss) or Fastest ⏩ (Cloudflare for warp-speed). Auto-configures DNS + DNS-over-HTTPS on Wi-Fi/Ethernet. Privacy? Encrypted. Speed? Unmatched.
* **🔄 Safety Net:** Removed Edge? No sweat—silently installs WebView2 Runtime so your apps don't throw a tantrum.
* **🎨 Terminal Swagger:** Winget-installs Oh My Posh and slaps on the sleek "hul10" theme. Restart your shell—watch it glow. Because who doesn't love a pretty prompt?

All actions log to ```~/Downloads/WinForge-OptionalSetup.log``` for your peace of mind. **Errors?** We capture 'em structured (JSON/TXT exports) so debugging's a breeze.

## 📖 How to Wield the Forge

1. **Launch as Admin:** Right-click PowerShell > "Run as Administrator." Paste the one-liner.
2. **Choose Your Path:** Y/N for each step—debloat? Edge zap? DNS dance? Your call.
3. **WinUtil Preset Magic:** If you snagged the JSON config, hit "Import" in WinUtil when prompted. Folder opens for easy access.
4. **DNS Delight:** Adblock for zen, Fastest for zoom. Applies to active adapters; flushes cache for instant wins.
5. **WebView2 Whisper:** Post-Edge, it installs quietly (or interactively if needed).
6. **Theme It Up:** Oh My Posh awaits—reload your profile (```. $PROFILE```) for the reveal.
7. **Relaunch & Revel:** Close/reopen Terminal. Voila—your Windows, reimagined.


_⚠️ Heads Up: Internet required. Windows 10/11 + PS 5.1+. Group Policy DNS? We'll warn ya._
[View detailed workflow →](https://github.com/mrdarksidetm/WinForge/blob/main/docs/working.md)


## 🛠️ Requirements & Gotchas

* **OS:** Windows 10/11 (tested on 11 23H2+).
* **Privledges:** Admin (duh—system tweaks!).
* **Net:** Active connection for downloads.

_Trouble? Check the log or ping me on GitHub Issues. We're in this together._

## 🙌 Credits: Standing on Giant Shoulders

* **Chris Titus Tech** – The debloat deity.
* **memstechtips** – Edge-slaying sorcery.
* **Cloudflare DNS** & **AdGuard DNS** – Speed & shield masters.
* **Oh My Posh by JanDeDobbeleer** – Theme wizardry.

WinForge: Compiled with ❤️ for the customization crew. Not a dev? Neither am I—just a passionate pixel-pusher.

## ☕ Sponsor the Forge
If this sparked joy (or saved your sanity), fuel the fire!

<div align="center">

<table>
  <tr>
    <td>
      <a href="https://www.buymeacoffee.com/mrdarksidetm" target="_blank"><img src="assets\images\support\Buymecoffe-Square.png" alt="Buy Me a Coffee" height="50"></a>
    </td>
    <td>
      <a href="https://ko-fi.com/H2H21N0OAT" target="_blank"><img src="assets\images\support\Kofi-Square.png" alt="Ko-fi" height="50">
</a>
    </td>
    <td>
      <a href="https://www.upi.me/pay?pa=abhisidetm@ptyes&am=150" target="_blank"><img src="assets\images\support\gpay.png" alt="Ko-fi" height="50"></a>
    </td>
  </tr>
</table>
</div>

**🌟 Future Tease:** Signed EXE wrapper incoming—stay tuned via Releases. Questions? Open an Issue. Let's build better Windows, one forge at a time.


Last Forged: {{ site.time | date: '%B %Y' }} | [View on GitHub](https://github.com/mrdarksidetm/WinForge) | License: [MIT](https://github.com/mrdarksidetm/WinForge/blob/main/LICENSE)
