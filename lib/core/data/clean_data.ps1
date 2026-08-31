$path = 'lib/core/data/ielts_data.dart'
$rawBytes = [System.IO.File]::ReadAllBytes($path)
$content = [System.Text.Encoding]::UTF8.GetString($rawBytes)

# Replace all corrupted character sequences
$content = $content.Replace('â€”', '-')
$content = $content.Replace('â Œ', '❌')
$content = $content.Replace('âœ…', '✅')
$content = $content.Replace('âž”', '➔')

# Fix icons to clean simple strings or remove emojis
$content = [System.Text.RegularExpressions.Regex]::Replace($content, 'icon:\s*"[^"]*"', 'icon: ""')

[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
Write-Host "Successfully cleaned up ielts_data.dart!"
