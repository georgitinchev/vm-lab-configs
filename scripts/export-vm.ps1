param(
    [string]$VmType = "ubuntu"
)

$ExportDir = Join-Path $HOME "VMware-Labs"
$ProviderDir = ".vagrant/machines/default/vmware_workstation"

if (-not (Test-Path $ProviderDir)) {
    Write-Error "VM not found. Run: `$env:VM_TYPE = '$VmType'; vagrant up"
    exit 1
}

New-Item -ItemType Directory -Force -Path $ExportDir | Out-Null
$ExportPath = Join-Path $ExportDir "$VmType-vm"

Write-Host "Halting $VmType VM..."
try { vagrant halt } catch {}

Write-Host "Exporting to $ExportPath..."
if (Test-Path $ExportPath) { Remove-Item -Recurse -Force $ExportPath }
New-Item -ItemType Directory -Force -Path $ExportPath | Out-Null

$UuidDir = Get-ChildItem -Path $ProviderDir -Directory | Select-Object -First 1
if ($UuidDir) {
    Copy-Item -Path (Join-Path $UuidDir.FullName '*') -Destination $ExportPath -Recurse -Force
}

$Vmx = Get-ChildItem -Path $ExportPath -Filter *.vmx -Recurse | Select-Object -First 1
if (-not $Vmx) {
    Write-Error "VMX file not found"
    exit 1
}

Write-Host "Exported: $($Vmx.FullName)"
Write-Host ""
Write-Host "Open in VMware: File > Open > $($Vmx.FullName)"
Write-Host ""

$Reply = Read-Host "Clean up Vagrant files? (y/n)"
if ($Reply -match '^[Yy]') {
    Write-Host "Destroying Vagrant VM and cleaning up..."
    vagrant destroy -f
    Remove-Item -Recurse -Force .vagrant
    Write-Host "Vagrant files cleaned up"
} else {
    Write-Host "Vagrant files kept. To clean manually: vagrant destroy; Remove-Item -Recurse -Force .vagrant"
}