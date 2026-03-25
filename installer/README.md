# Inno Setup

This folder contains an Inno Setup script that packages the Flutter Windows build into a single `Setup.exe`.

## Prerequisites

1. Build the Windows release output:

```powershell
flutter build windows --release
```

2. Install Inno Setup 6 on Windows.

## Compile the installer

Open `installer/accessible_office_installer.iss` in Inno Setup Compiler and build it.

The generated installer will be written to:

```text
dist/AccessibleOfficeInstallerSetup.exe
```

## Expected input folder

The installer script packages everything from:

```text
build/windows/x64/runner/Release
```

Do not copy only the `.exe`; the whole Flutter Windows output folder is required.
