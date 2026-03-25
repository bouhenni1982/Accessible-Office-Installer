#ifndef MyAppName
  #define MyAppName "Accessible Office Installer"
#endif
#ifndef MyAppPublisher
  #define MyAppPublisher "Accessible Office Installer"
#endif
#ifndef MyAppURL
  #define MyAppURL "https://github.com/bouhenni1982/Accessible-Office-Installer"
#endif
#ifndef MyAppExeName
  #define MyAppExeName "accessible_office_installer.exe"
#endif
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#ifndef MyBuildDir
  #define MyBuildDir "..\build\windows\x64\runner\Release"
#endif
#ifndef MyOutputBaseFilename
  #define MyOutputBaseFilename "AccessibleOfficeInstallerSetup-" + MyAppVersion
#endif

[Setup]
AppId={{D5DBF3F8-6F1B-4A33-9C87-43D2B7A8C6BF}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=
PrivilegesRequired=admin
OutputDir=..\dist
OutputBaseFilename={#MyOutputBaseFilename}
SetupIconFile=
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#MyBuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
