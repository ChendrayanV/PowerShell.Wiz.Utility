$src = @(Get-ChildItem -Path $PSScriptRoot\src\*.ps1 -ErrorAction SilentlyContinue)
Foreach($import in $src) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $src.Basename -Alias *