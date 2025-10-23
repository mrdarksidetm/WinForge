---
title: WinForge
description: Optimize Windows 11 with ease – debloat, enhance, and customize.
theme: minima
plugins:
  - jekyll-feed
---

# WinForge

Automate Windows optimization and customization with an interactive PowerShell script that handles debloating (WinUtil), Edge cleanup (WinHance), DNS + DoH profiles, WebView2 safety, and an Oh My Posh terminal theme.

## Quick install

Run in PowerShell as Administrator:
```
irm https://raw.githubusercontent.com/mrdarksidetm/WinForge/main/src/WinForgeOptionalSetup.ps1 | iex
```

If execution policy blocks scripts:
```
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```


Or resolve the latest Release asset at runtime: (Download from the latest release)

> Just copy and paste these commands

```
$repo = "mrdarksidetm/WinForge"
$file = "WinForgeOptionalSetup.ps1"
$api  = "https://api.github.com/repos/$repo/releases/latest"
$dl   = (Invoke-RestMethod $api).assets | Where-Object name -eq $file | Select-Object -ExpandProperty browser_download_url
Invoke-WebRequest $dl -OutFile "$env:TEMP\WinForge.ps1"
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File "$env:TEMP\WinForge.ps1""
```

## What it does

- Debloat and optimize Windows by launching Chris Titus Tech WinUtil with optional preset import when the JSON is beside the script.  
- Remove Microsoft Edge and apply extra Windows tweaks using WinHance.  
- Offer Internet profiles: Adblock (AdGuard) or Fastest (Cloudflare) and configure DNS plus DNS-over-HTTPS on active adapters.  
- If Edge was removed, install Microsoft WebView2 Runtime silently (fallback to interactive) so dependent apps continue to work.  
- Install Oh My Posh via winget and apply the “hul10” theme by updating the PowerShell profile.  
- Log all actions to %USERPROFILE%DownloadsWInForge-OptionalSetup.log and display a final success/error summary.  

## How to use

- Open Windows Terminal as Administrator, run the one‑liner above, and answer Y/N prompts for each optional step.  
- For WinUtil presets, place Winforge-ChristitusConfigs.json next to the script and use “Import” in WinUtil when prompted.  
- Choose Adblock (AdGuard) or Fastest (Cloudflare) when asked; the script configures DNS + DoH on active Wi‑Fi/Ethernet adapters.  
- If you removed Edge, allow WebView2 to install to avoid breaking apps that rely on the Edge runtime.  
- For the terminal theme, restart PowerShell or run `. $PROFILE` when the script finishes.  

## Requirements

- Windows 10/11, PowerShell 5.1+, Administrator privileges, and an active Internet connection.  

## Credits

- Chris Titus Tech – WinUtil  
- memstechtips – WinHance  
- Cloudflare DNS and AdGuard DNS  

## Sponsor

If this toolkit helps, consider supporting Mrdarksidetm (Abhijeet Yadav).
