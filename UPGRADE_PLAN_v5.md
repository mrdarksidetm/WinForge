# WinForge v5.0 Upgrade Plan (2026 Edition) 🚀

## 1. PowerShell Script Modernization (`WinForge.ps1`)
- [ ] **Version Bump:** Update to v5.0 (2026 "Next-Gen" Edition).
- [ ] **AI & Bloatware Cleanup:**
    - [ ] Add explicit removal for Windows Recall (if present).
    - [ ] Add explicit removal for Copilot and AI integration.
    - [ ] Disable Windows "Suggestions" and "Ads" more aggressively.
- [ ] **Winget App Updater:**
    - [ ] Add a section to update all installed apps via `winget upgrade --all`.
- [ ] **Game Mode Optimizer:**
    - [ ] Add a high-performance power plan toggle.
    - [ ] Disable unnecessary background services for gaming.
- [ ] **Modern MAS Integration:** Ensure the latest `get.activated.win` logic is used.

## 2. Documentation & UI Upgrade
- [ ] **README.md Refresh:** Update banners, version badges, and feature lists.
- [ ] **Jekyll Docs Modernization:**
    - [ ] Update `_config.yml` and dependencies in `Gemfile`.
    - [ ] Improve dark mode styling in Sass files.
- [ ] **Node.js Cleanup:** 
    - [ ] Investigate why `node_modules` is present without a root `package.json`.
    - [ ] Either add a proper `package.json` for Tailwind/PostCSS or remove the clutter.

## 3. Maintenance & CI/CD
- [ ] **GitHub Actions:** Add a linting action for PowerShell.
- [ ] **Release Automation:** Script to automatically update version strings in `README` and `WinForge.ps1`.

---
*Engineering Excellence for Windows Power Users.*
