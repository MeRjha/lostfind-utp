$ErrorActionPreference = 'Stop'

$mysqlBin = 'C:\Program Files\MySQL\MySQL Server 9.3\bin'
$fotos = Join-Path $env:USERPROFILE 'LostFind_uploads'
$respaldos = Join-Path $PSScriptRoot 'Respaldos'
$log = Join-Path $PSScriptRoot 'respaldo.log'
$fecha = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$temporal = Join-Path $respaldos "$fecha.incompleto"
$destino = Join-Path $respaldos $fecha

try {
    New-Item -ItemType Directory -Path $temporal -Force | Out-Null
    $sql = Join-Path $temporal 'bd_lostfind.sql'

    & (Join-Path $mysqlBin 'mysqldump.exe') --login-path=lostfind_backup `
        --single-transaction --no-tablespaces --set-gtid-purged=OFF `
        "--result-file=$sql" bd_lostfind

    if ($LASTEXITCODE -ne 0 -or (Get-Item -LiteralPath $sql).Length -eq 0) {
        throw 'No se pudo respaldar la base de datos.'
    }

    Copy-Item -LiteralPath $fotos -Destination (Join-Path $temporal 'uploads') -Recurse
    Move-Item -LiteralPath $temporal -Destination $destino
    Add-Content -Path $log -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') OK $destino"
    Write-Host "Respaldo completado: $destino"
    exit 0
}
catch {
    Add-Content -Path $log -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ERROR $($_.Exception.Message)"
    Write-Error -Message $_.Exception.Message -ErrorAction Continue
    exit 1
}