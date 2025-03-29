param(
    [string]$Name,
    [string]$Dir,
    [string]$Reflex
)

# Remove the outfile file if it exists
Remove-Item -Path $Name -Force -ErrorAction Ignore

pushd $Dir

# Get all .dfa files in the simple directory
$files = Get-ChildItem -Path "./simple" -Filter "*.dfa" | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) }

popd

$tmp = New-TemporaryFile

# Loop through each .dfa file
foreach ($file in $files) {

    # Append the file name to output file
    Add-Content -Path $Name -Value "== $file =="

    # Execute the Java command and redirect output to temp file
    java -jar $Reflex/scala/jreflex.jar print $tmp "$Dir/simple/$file"

    # Append the contents of temp file to output file
    Get-Content -Path $tmp | Add-Content -Path $Name

    # Append a new line to output file
    Add-Content -Path $Name -Value ""
}

Remove-Item -Path $tmp -Force -ErrorAction Ignore
