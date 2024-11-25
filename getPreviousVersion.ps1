param (
    [string]$version
)

function Pad($value, $length) {
    $value = $value.ToString()
    $valueLength = $value.Length
    for ($i = 0; $i -lt $length - $valueLength; $i++) {
        $value = "$($value)0"
    }
    return $value
}

function PadLeft($value, $length) {
    $value = $value.ToString()
    $valueLength = $value.Length
    for ($i = 0; $i -lt $length - $valueLength; $i++) {
        $value = "0$($value)"
    }
    return $value
}
  
function Get-UniqueIndex($originalTag) {
    $tag = $originalTag -replace '^v'
    $parts = $tag -split '\.'
            
    if ($parts.Count -lt 3) {
        Write-Warning "Tag '$tag' does not conform to expected SemVer format."
        return 0
    }
            
    $major = [int]$parts[0]
    $minor = [int]$parts[1] -as [int]
    $end = $parts[2]
    $suffixParts = $end -split '-'
    $patch = [int]$suffixParts[0] -as [int]
    $suffixString = $suffixParts[1] -as [string]

    $suffix = 0
    if ($suffixString -ne '') {
        $suffix = [int]($suffixString -replace '[^0-9]', '')
    }

    $releaseType = 4
    switch -wildcard ($suffixString) {
        '*alpha*' { $releaseType = 1 }
        '*beta*' { $releaseType = 2 }
        '*rc*' { $releaseType = 3 }
    }
          
    $majorIndex = PadLeft $major.ToString() 3
    $minorIndex = PadLeft $minor.ToString() 3
    $patchIndex = PadLeft $patch.ToString() 3
    $suffixIndex = PadLeft $suffix.ToString() 3

    $index = "$majorIndex$minorIndex$patchIndex$releaseType$suffixIndex"
    Write-Host "Tag '$originalTag'`n$majorIndex, $minorIndex, $patchIndex, $releaseType, $suffixIndex, $index`n`n"
    return $index -as [long]
}

function Get-Tags($startVersion, $endVersion) {
    Write-Host "Start version is $startVersion"
    Write-Host "End version is $endVersion"

    $startIndex = Get-UniqueIndex $startVersion
    $endIndex = Get-UniqueIndex $endVersion

    git fetch --tags --quiet

    $allTags = @() 
    
    git tag | ForEach-Object { 
        $originalTag = $_
        $uniqueIndex = Get-UniqueIndex $originalTag
        $tagObj = New-Object PSObject -Property @{
            Tag         = $originalTag
            UniqueIndex = $uniqueIndex
        }
        if ($uniqueIndex -ge $startIndex -and $uniqueIndex -le $endIndex) {
            $allTags += $tagObj
        }
    } 

    $outputTags = $allTags | Sort-Object -Property UniqueIndex
    return $outputTags
}
  
$tags = Get-Tags "0.0.0" "$version"
Write-Host "Tags to consider: $tags"
  
$includePrerelease = $version -match "alpha|beta|rc"
$previousVersion = $null
$currentVersionIndex = Get-UniqueIndex "$version"
for ($i = $tags.Count - 1; $i -ge 0; $i--) {
    $tag = $tags[$i]

    if ($tag.UniqueIndex -ge $currentVersionIndex) {
        Write-Host "Skipping as $tag.Tag is greater than $version"
        continue
    }

    $isPreRelease = $tag.Tag -match "alpha|beta|rc"
    if ($isPreRelease) {
        if (!$includePrerelease) {
            Write-Host "Skipping as $tag.Tag is prerelease"
            continue
        }
    }

    Write-Host "Found $tag.Tag"
    $previousVersion = $tag.Tag
    break
}

if ($null -eq $previousVersion) {
    throw "No previous tag found before $version"
} 

Write-Host "The nearest previous tag to $version is $previousVersion"
return $previousVersion