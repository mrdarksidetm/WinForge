# Jekyll Clean Script: Removes _site, .jekyll-cache, .sass-cache safely
Write-Host "Cleaning Jekyll build artifacts..." -ForegroundColor Green

# Jekyll bundle clean first (removes _site, .jekyll-metadata)
bundle exec jekyll clean

# Manual removes if exist (avoids positional param error)
if (Test-Path "_site") {
    Remove-Item -Path "_site" -Recurse -Force
    Write-Host "_site removed." -ForegroundColor Yellow
} else {
    Write-Host "_site already clean." -ForegroundColor Gray
}

if (Test-Path ".jekyll-cache") {
    Remove-Item -Path ".jekyll-cache" -Recurse -Force
    Write-Host ".jekyll-cache removed." -ForegroundColor Yellow
} else {
    Write-Host ".jekyll-cache not found." -ForegroundColor Gray
}

if (Test-Path ".sass-cache") {
    Remove-Item -Path ".sass-cache" -Recurse -Force
    Write-Host ".sass-cache removed." -ForegroundColor Yellow
} else {
    Write-Host ".sass-cache not found." -ForegroundColor Gray
}

Write-Host "Clean complete. Ready for rebuild." -ForegroundColor Green
