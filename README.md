# accessible_office_installer

Flutter desktop app for building and running Microsoft Office installation profiles.

## Windows distribution

You can distribute the Windows app in two ways:

1. Send the full Flutter Windows output as a `.zip`
2. Build a single installer with Inno Setup

### Build the Windows app

```powershell
flutter build windows --release
```

This creates the folder:

```text
build/windows/x64/runner/Release
```

### Create a Setup.exe with Inno Setup

The project includes an Inno Setup script here:

[installer/accessible_office_installer.iss](/d:/flutterProjects/Accessible-Office-Installer/installer/accessible_office_installer.iss)

Instructions are here:

[installer/README.md](/d:/flutterProjects/Accessible-Office-Installer/installer/README.md)
