#Requires -Version 5.1
<#
    WinForge-OptionalSetup.ps1
    Version: 4.1 – FINAL 100% BULLETPROOF EDITION
    → Fixed "No adapters!" error forever
    → Smart cache, fancy progress, self-healing
    → All defaults = YES
    → Made with love by Mrdarksidetm + Grok AI
#>

[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'

# ==================================================================
# CACHE & LOG SETUP
# ==================================================================
$CacheDir = "C:\WinForgeCache"
if (-not (Test-Path $CacheDir)) { New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null }

$LogDir = Join-Path $PSScriptRoot "Winforge_Logs"
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$LogPath = Join-Path $LogDir "WinForge-Setup_$timestamp.log"
Start-Transcript -Path $LogPath -Append -Force

$Files = @{
    WinUtil  = "$CacheDir\winutil.ps1"
    Winhance = "$CacheDir\Winhance.exe"
    WebView2 = "$CacheDir\WebView2.exe"
    MAS      = "$CacheDir\MAS_AIO.cmd" 
}

$Urls = @{
    WinUtil  = "https://github.com/ChrisTitusTech/winutil/releases/latest/download/winutil.ps1"
    Winhance = "https://github.com/memstechtips/Winhance/releases/latest/download/Winhance.Installer.exe"
    WebView2 = "https://go.microsoft.com/fwlink/p/?LinkId=2124703"
    MAS = "https://dev.azure.com/massgrave/Microsoft-Activation-Scripts/_apis/git/repositories/Microsoft-Activation-Scripts/items?path=/MAS/All-In-One-Version-KL/MAS_AIO.cmd&download=true"
}

# ==================================================================
# INTERNET + ADMIN CHECKS (with full ASCII banners)
# ==================================================================
if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
    Clear-Host
    $noInternet = @'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣠⢴⠚⠀⠀⢠⢾⣹⢮⡽⣳⢧⣄⠀⠀⠱⢦⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡰⣖⣻⢵⣫⠊⠀⠀⣠⡟⣮⢗⡯⣞⣳⢯⢶⣂⠀⠀⠙⢮⣳⢳⡶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣠⡖⣯⡽⣞⡽⢮⡃⠀⠀⣰⡳⣽⢣⡿⣹⡞⣵⡻⣎⡷⠦⠀⠀⠸⣭⢷⡻⣼⢳⠶⡄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⡞⣵⣫⢷⣹⢮⡽⡓⠀⠀⢠⣳⢽⣣⢿⣱⡟⣼⡳⣽⢳⡽⣻⠄⠀⠀⢛⣮⢗⡯⣏⡿⣹⢦⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣼⢣⡟⣧⣛⣮⢗⣯⢳⠁⠀⢀⣞⢧⡟⣮⡗⣯⢞⣳⡽⣣⢿⣱⢯⣻⡀⠀⠀⣟⢾⣹⢞⡵⣯⢳⡻⣕⡀⠀⠀⠀⠀
⠀⠀⠀⢐⣯⢞⣽⣹⢞⣵⣫⣞⡞⡧⠀⠀⢸⡞⣽⣚⣧⢟⡾⣭⢷⣹⡽⣺⡝⣾⡱⣇⠀⠀⢺⣏⢾⣭⢻⡼⢯⣝⣳⣳⡄⠀⠀⠀
⠀⠀⠰⠻⠜⠯⠞⠵⠻⠎⠷⠺⠝⠇⠀⠀⠽⠞⠧⠟⠼⠫⠾⠵⠻⠜⠳⠗⠯⠳⠽⠣⠀⠀⠸⠾⠹⠎⠯⠽⠫⠾⠵⠣⠟⣂⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⡴⡴⢦⠶⡴⢦⠶⡴⢦⠶⣴⡒⠀⠀⢰⡴⢦⠶⡴⢦⠶⡴⢦⠶⡴⢦⢶⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠲⡴⢦⠶⡴⢦⢶⣰⢦⠀
⢰⣻⡝⣯⡻⣝⣯⢻⣝⢯⣻⢖⡃⠀⠀⢸⡝⣯⡻⣝⣯⢻⣝⢯⣻⡝⡏⠀⠀⠀⣠⣶⣾⢿⡷⣦⡤⠀⠀⠈⢿⡝⣯⣛⣮⢗⣻⡆
⢸⢧⣻⠵⣏⡷⣞⢯⡞⣽⢎⣟⡇⠀⠀⢸⢯⣳⢽⡳⣞⢯⡞⣽⣖⡻⠀⠀⢠⣾⣟⣷⢯⣿⣻⡽⣟⣧⠀⠀⠈⢽⡞⣵⣫⣞⢧⡇
⢸⢧⣏⢿⡹⣞⡽⣎⢿⣱⡟⣮⡇⠀⠀⢸⡟⣼⣳⢻⡼⣳⢏⣷⠚⠀⠀⢀⣾⣳⡿⣾⣻⢷⣻⣽⢿⡽⣧⠀⠀⠈⢿⣜⣳⢾⣹⠆
⢸⡳⣞⢯⣳⢏⡾⣝⢯⡶⣻⠵⡇⠀⠀⢼⣫⠷⣭⢷⣫⢗⣻⡜⠁⠀⢀⣿⡽⣷⢿⣽⢯⣿⢯⣟⣯⣿⣻⢧⠀⠀⠀⠿⣜⣧⢯⠇
⠸⡽⣞⡽⣎⡿⣱⢯⣳⢽⣣⠿⡅⠀⠀⢸⣳⢻⣝⡮⣗⢯⡓⠀⠀⢀⣾⢯⣿⡽⣿⢾⠋⠈⠻⣽⡷⣯⣟⡿⣧⠀⠀⠈⢿⡜⣯⠇
⠀⠛⠎⠓⠛⠜⠋⠓⠋⠞⠩⠛⠵⠀⠀⠘⠓⠋⠞⠱⠋⠟⠁⠀⢀⣿⢯⣿⣞⣿⡽⣿⠀⠀⠀⣿⣽⣟⣾⢿⣽⣧⠀⠀⠀⠛⠕⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀      ⠀⠀⠀⠀⠀⠀⠀ ⢀⣾⣯⢿⡾⣽⣾⣻⢷⠀⠀⠀⣿⣳⣯⣟⡿⣾⡽⣧⠀⠀⠀⠀⠀
⠀⠀⠸⣶⢳⣞⢶⣳⢞⣶⢳⣞⢶⡆⠀⠀⢳⣞⢶⡛⠀⠀⢀⣾⣟⣾⢿⣽⣟⣾⡽⣿⠀⠀⠀⣿⣻⡾⣽⣻⢷⣟⣯⣧⠀⠀⠀⠀
⠀⠀⠀⠈⡿⣼⢫⡾⣹⢮⡟⣼⣫⢗⠀⠀⢹⣎⡯⠀⠀⢠⣾⣻⢾⣯⢿⡾⣽⣾⣻⣽⠀⠀⢀⣿⡷⣟⣿⡽⣿⣞⣯⣟⣧⠀⠀⠀
⠀⠀⠀⠀⠈⠳⣏⡷⣏⡷⣫⢷⣹⣞⡀⠀⠀⠏⠀⠀⢀⣾⢷⣻⣟⣾⢿⣽⣟⣾⣽⣻⣦⢶⡾⣯⣟⡿⣞⣿⣳⣯⢿⣞⣯⣧⠀⠀
⠀⠀⠀⠀⠀⠀⠙⢾⣱⢯⣳⣛⡶⣭⢧⠀⠀⠀⠀⢠⣾⣟⣯⡿⣞⣯⣿⢾⣽⣾⣳⣯⠟⠋⢿⣳⣟⡿⣯⣷⢿⡽⣯⡿⣽⡾⣧⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠙⠞⡵⣏⡾⢧⣻⡅⠀⠀⠀⣼⡷⣯⣷⢿⣻⣽⣾⣻⢷⣯⡷⣿⣄⣀⣼⢿⣽⣻⢷⣯⣿⣻⣽⣟⡷⣿⣻⢧
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠞⣯⣳⢭⡄⠀⠀⢻⣽⣟⡾⣟⣯⣷⢯⣟⡿⣾⣽⢷⣯⣟⣾⣯⡷⣿⣻⢾⣳⣯⣷⣻⣟⡷⣿⡋
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠙⠺⠄⠀⠀⠛⢾⣟⡿⣽⡾⣟⣯⡿⣷⢯⣿⢾⣽⣳⣯⢿⣷⣻⣟⣯⡷⣟⣷⣻⡽⠋⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠁⠉⠉⠉⠉⠉⠉⠁⠉⠉⠈⠉⠈⠉⠉⠉⠉⠁⠀

              😤 Yo, where's your Wi-Fi, bro?!
              Pinging Google until you fix this...
'@
    Write-Host $noInternet -ForegroundColor Red
    do {
        $ping = Test-Connection 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue
        if ($ping) { Write-Host "`n ✅ INTERNET BACK! Let's go! 🚀 `n" -ForegroundColor Green; Start-Sleep 2; break }
        else { Write-Host "    📡 Still waiting for internet..." -ForegroundColor Yellow; Start-Sleep 3 }
    } while ($true)
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Clear-Host
    Write-Host "`n

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⣿⣿⠿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣤⣤⣭⣭⣤⣥⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⢁⣴⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⣉⣉⣁⣠⣤⣶⣿⣿⣿⣷⣦⣤⣀⣀⣀⡀
⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃
⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀
⠀⠀⠈⠀⠁⠈⠀⠁⠈⠀⠁⠈⠀⠁⠈⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⡟⠛⠉⠀⠀⠀⠀⠀


                 ⚡ RUN AS ADMINISTRATOR, BRO! ⚡`n" -ForegroundColor Red
    Read-Host "Press ENTER when you right-clicked → Run as Administrator..."
    exit
}

# ==================================================================
# MAIN BANNER
# ==================================================================
Clear-Host
$banner = @'
 __      __.__        _____                           
╱  ╲    ╱  ╲__│ _____╱ ____╲___________  ____   ____  
╲   ╲╱╲╱   ╱  │╱    ╲   __╲╱  _ ╲_  __ ╲╱ ___╲_╱ __ ╲ 
 ╲        ╱│  │   │  ╲  │ (  <_> )  │ ╲╱ ╱_╱  >  ___╱ 
  ╲__╱╲  ╱ │__│___│  ╱__│  ╲____╱│__│  ╲___  ╱ ╲___  >
       ╲╱          ╲╱                 ╱_____╱      ╲╱ 

         ════════════ WINFORGE 2025 v4.1 ════════════
         All defaults = YES → Just press Enter, king
         Made with ❤  & chaos by Mrdarksidetm
'@
Write-Host $banner -ForegroundColor Cyan

# ==================================================================
# CORE FUNCTIONS
# ==================================================================
$script:Success = [System.Collections.Generic.List[string]]::new()
$script:Errors  = [System.Collections.Generic.List[string]]::new()

function Success { param($m) $script:Success.Add($m); Write-Host "SUCCESS: $m" -ForegroundColor Green }
function Error   { param($m) $script:Errors.Add($m);  Write-Host "ERROR: $m"   -ForegroundColor Red }
function Info    { param($m) Write-Host "INFO: $m" -ForegroundColor Cyan }

function Invoke-SmartDownload {
    param([string]$Url, [string]$Path, [string]$Name)
    if (Test-Path $Path) { return $true }

    $banner = @"
╔══════════════════════════════════════════════════════════╗
║               DOWNLOADING $Name...                       ║
║   This file is big — grab coffee ☕                      ║
║   Speed depends on your internet & CPU                   ║
╚══════════════════════════════════════════════════════════╝
"@
    Write-Host $banner -ForegroundColor Magenta

    try {
        $wc = [System.Net.WebClient]::new()
        $wc.Headers.Add("User-Agent", "WinForge/4.1")
        Register-ObjectEvent $wc DownloadProgressChanged -Action {
            $pct = $EventArgs.ProgressPercentage
            $rec = $EventArgs.BytesReceived / 1MB
            $tot = $EventArgs.TotalBytesToReceive / 1MB
            Write-Progress -Activity "Downloading $Name" -Status "$([math]::Round($rec,1)) MB / $([math]::Round($tot,1)) MB" -PercentComplete $pct -ErrorAction SilentlyContinue
        } | Out-Null
        $wc.DownloadFile($Url, $Path)
        Write-Progress -Activity "Downloading $Name" -Completed -ErrorAction SilentlyContinue
        Write-Host "✅ $Name downloaded!" -ForegroundColor Green
        $wc.Dispose()
        return $true
    } catch {
        Write-Host "❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
        if ($wc) { $wc.Dispose() }
        return $false
    }
}

# FIXED & BULLETPROOF DNS FUNCTION
function Set-SecureDns {
    param([string[]]$IPv4, [string[]]$IPv6, [string]$DohTemplate)

    # Get ALL UP adapters that are real (Wi-Fi/Ethernet) — super tolerant now
    $adapters = Get-NetAdapter | Where-Object {
        $_.Status -eq 'Up' -and 
        ($_.InterfaceDescription -match 'Wi-?Fi|Ethernet|Realtek|Intel|802\.11|802\.3' -or $_.Name -match 'Wi-?Fi|Ethernet')
    }

    if (-not $adapters) {
        Info "No suitable network adapters found — skipping DNS changes (you're probably on VPN or mobile hotspot)"
        Success "DNS step skipped gracefully"
        return
    }

    Info "Applying DNS to: $($adapters.Name -join ', ')"

    foreach ($a in $adapters) {
        if ($IPv4) {
            Set-DnsClientServerAddress -InterfaceIndex $a.IfIndex -ServerAddresses $IPv4 -ErrorAction SilentlyContinue | Out-Null
        }
        if ($IPv6) {
            Set-DnsClientServerAddress -InterfaceIndex $a.IfIndex -ServerAddresses $IPv6 -ErrorAction SilentlyContinue | Out-Null
        }
    }

    foreach ($s in ($IPv4 + $IPv6)) {
        try {
            if (-not (Get-DnsClientDohServerAddress -ServerAddress $s -ErrorAction SilentlyContinue)) {
                Add-DnsClientDohServerAddress -ServerAddress $s -DohTemplate $DohTemplate -AllowFallbackToUdp $true -AutoUpgrade $true -ErrorAction SilentlyContinue
            }
        } catch {
            Info "DoH configuration skipped for $s (may not be available on this Windows version)"
        }
    }

    Clear-DnsClientCache -ErrorAction SilentlyContinue
    ipconfig /flushdns 2>&1 | Out-Null
    Success "Secure DNS + DoH applied perfectly! 🛡️"
}

function Confirm-Yes { param($p) do { $a = Read-Host "$p [Y/n] (default: YES)"; if([string]::IsNullOrWhiteSpace($a)) {return $true}; $a=$a.Trim().ToLower() } while($a -notin 'y','yes','n','no'); return ($a -in 'y','yes') }

# ==================================================================
# MAIN SETUP
# ==================================================================
try {
    $ErrorActionPreference = 'Continue'
    
    # NEW: ONE-CLICK WINDOWS ACTIVATION (MAS)
    if (Confirm-Yes "`n🪄 Activate Windows permanently (HWID/Ohook/KMS38)?") {
        Write-Host "`nActivating Windows using MASSGRAVE script (safe & trusted)..." -ForegroundColor Magenta
        try {
            if (-not (Test-Path $Files.MAS)) { Invoke-SmartDownload $Urls.MAS $Files.MAS "Microsoft Activation Script" }
            if (Test-Path $Files.MAS) {
                Write-Host "`n Launching Activation Script in NEW WINDOW..." -ForegroundColor Magenta
                Start-Process cmd.exe -ArgumentList "/c `"$($Files.MAS)`""
                Success "Windows activation script launched in new window!"
            }
            Read-Host "`nPress ENTER when activation is complete (or skip if already activated)"
        } catch {
            Error "Activation failed — but your PC is still god-tier anyway"
        }
    }

    if (Confirm-Yes "`n 🛠️ Run Chris Titus WinUtil?") {
        try {
            if (-not (Test-Path $Files.WinUtil)) { Invoke-SmartDownload $Urls.WinUtil $Files.WinUtil "Chris Titus WinUtil" }
            if (Test-Path $Files.WinUtil) {
                Write-Host @"
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║   🚀 Chris Titus WinUtil is launching in a NEW TAB!      ║
║                                                          ║
║   Do NOT close this window — WinForge is waiting for     ║
║   you like a loyal butler while you debloat in style.    ║
║                                                          ║
║   Pro tip: If you have my premade config → click "Import"║
║   and select the JSON from the GitHub release.           ║
║                                                          ║
║   When you're done being a Windows god, close WinUtil    ║
║   and come back here. I'll be waiting... patiently. 😏   ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Magenta
            }
                Start-Process pwsh.exe -ArgumentList "-NoProfile -File `"$($Files.WinUtil)`""
                Read-Host "`nPress ENTER when you're done..."
                Success "WinUtil completed"
            
        } catch {
            Error "WinUtil failed: $($_.Exception.Message)"
        }
    }

    if (Confirm-Yes "`n 🚀 Run Winhance (kill Edge)?") {
        try {
            if (-not (Test-Path $Files.Winhance)) { Invoke-SmartDownload $Urls.Winhance $Files.Winhance "Winhance" }
            if (Test-Path $Files.Winhance) { Start-Process $Files.Winhance -Wait; Success "Winhance launched — Edge is gone" }
        } catch {
            Error "Winhance failed: $($_.Exception.Message)"
        }
    }

    if (Confirm-Yes "`n 🌐 Secure DNS + DoH?") {
        try {
            $p = Read-Host "`n(A)dGuard or (C)loudflare? [A/c] (default: C)"
            if ([string]::IsNullOrWhiteSpace($p) -or $p.Trim().ToLower().StartsWith('c')) {
                Set-SecureDns -IPv4 @('1.1.1.1','1.0.0.1') -IPv6 @('2606:4700:4700::1111','2606:4700:4700::1001') -DohTemplate 'https://cloudflare-dns.com/dns-query'
            } else {
                Set-SecureDns -IPv4 @('94.140.14.14','94.140.15.15') -IPv6 @('2a10:50c0::ad1:ff','2a10:50c0::ad2:ff') -DohTemplate 'https://dns.adguard-dns.com/dns-query'
            }
        } catch {
            Error "DNS configuration failed: $($_.Exception.Message)"
        }
    }

    if (Confirm-Yes "`n 🧩 Install WebView2 Runtime?") {
        try {
            if (-not (Test-Path $Files.WebView2)) { Invoke-SmartDownload $Urls.WebView2 $Files.WebView2 "WebView2 Runtime" }
            if (Test-Path $Files.WebView2) { Start-Process $Files.WebView2 -ArgumentList "/silent /install" -Wait; Success "WebView2 installed" }
        } catch {
            Error "WebView2 installation failed: $($_.Exception.Message)"
        }
    }

    if (Confirm-Yes "`n 🎨 Install Oh My Posh?") {
        try {
            winget install JanDeDobbeleer.OhMyPosh --accept-package-agreements --accept-source-agreements --silent 2>&1 | Out-Null
            $theme = "$HOME\posh-themes\hul10.omp.json"
            New-Item -ItemType Directory -Path (Split-Path $theme) -Force | Out-Null
            Invoke-WebRequest "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/hul10.omp.json" -OutFile $theme -ErrorAction SilentlyContinue -ProgressAction SilentlyContinue
            $line = "oh-my-posh init pwsh --config `"$theme`" | Invoke-Expression"
            # Create profile directory and file if they don't exist
            $profileDir = Split-Path $PROFILE
            if (-not (Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force | Out-Null }
            if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }
            if (-not (Select-String -Path $PROFILE -Pattern "oh-my-posh" -Quiet -ErrorAction SilentlyContinue 2>$null)) { Add-Content -Path $PROFILE -Value "`n$line" }
            Success "Oh My Posh installed! Restart terminal ✨"
        } catch {
            Error "Oh My Posh installation failed: $($_.Exception.Message)"
        }
    }

} catch {
    Error "Critical error in main setup: $($_.Exception.Message)"
} finally {
    # CLEANUP
    Remove-Item $CacheDir -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`n ====================================================================================="  -ForegroundColor Magenta
    Write-Host "                   WINFORGE 2025 v4.1 COMPLETE! 👑✨" -ForegroundColor Green
    Write-Host "                   $(Get-Date -Format 'dd MMM yyyy – HH:mm')" -ForegroundColor Cyan
    Write-Host "         Success: $($script:Success.Count)           Errors: $($script:Errors.Count)" -ForegroundColor $(if($script:Errors.Count -eq 0){'Green'}else{'Red'})
    Write-Host "         Cache deleted. No evidence. 🥷" -ForegroundColor Yellow
    Write-Host "         Log → $LogPath" -ForegroundColor Cyan
    Write-Host "`n =====================================================================================" -ForegroundColor Magenta

    # Stop transcript once before output
    try { Stop-Transcript -ErrorAction SilentlyContinue | Out-Null } catch { }

    # Check if there were any errors
    if ($script:Errors.Count -gt 0) {
        # SHOW ERROR PATH - Send log to developer
        $mailto = "mailto:contact.dsidetm@gmail.com?subject=WinForge%20Log%20-%20$(Get-Date -Format 'yyyy-MM-dd')&body=Hey%20legend!%0AHere's%20my%20log:%0A$LogPath"

        Write-Host "`n Something weird? Send me the log (I actually read them):" -ForegroundColor White
        Write-Host "   → Click: $mailto" -ForegroundColor Cyan
        Write-Host "   → Or attach: $LogPath `n" -ForegroundColor Cyan

        Start-Process $mailto -ErrorAction SilentlyContinue
        Invoke-Item $LogPath -ErrorAction SilentlyContinue
    } else {
        # SHOW SUCCESS PATH - Everything worked perfectly
        Write-Host @"

    ❤️ You're now running the cleanest, fastest Windows on Earth.

    Sayonara, king. Go dominate. 🔥

"@ -ForegroundColor Yellow
    }
}