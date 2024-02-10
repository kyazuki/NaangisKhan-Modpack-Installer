# servers.datをバイナリ出力するスクリプト
Param([parameter(mandatory = $true)][String]$ServersDatPath)
Write-Output Windows:
(Format-Hex $ServersDatPath).HexBytes | Join-String -Separator ' '
Write-Output Mac:
(Format-Hex $ServersDatPath).HexBytes | ForEach-Object { $_ -replace "^| ", "\x" } | Join-String