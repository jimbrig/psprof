# Changelog

> All notable changes to this project will be documented in this file. The format is based on
[Keep a Changelog](http://keepachangelog.com/) and this project adheres to
[Semantic Versioning](http://semver.org/).

## [Unreleased]

## Configuration

- Update .gitattributes for PowerShell file handling ([8a08d9f](https://github.com/jimbrig/psprof/commit/8a08d9f7283ed804ccff7c4cb1e2d5866fa98c36))  - (Jimmy Briggs)
- **vscode:** Update settings to exclude Modules directory from search and file operations ([80d056e](https://github.com/jimbrig/psprof/commit/80d056e0a5227829ec7cdbd32b640cc8b5daf68e))  - (Jimmy Briggs)
- Alternative profiles ([24c9bb2](https://github.com/jimbrig/psprof/commit/24c9bb27c861c877caa904242081680c37d23e18))  - (Jimmy Briggs)
- Do not ignore desktop.ini ([87aee1c](https://github.com/jimbrig/psprof/commit/87aee1c809348707c4fe426f2fbad0a7099ead0f))  - (Jimmy Briggs)

## DevOps

- Add workflow to automate changelog generation ([d87f1f6](https://github.com/jimbrig/psprof/commit/d87f1f6eb00a57dd2e79425beddbc0439f25857f))  - (Jimmy Briggs)

## Documentation

- Update README.md to include badges and license information ([2ad3ab0](https://github.com/jimbrig/psprof/commit/2ad3ab0253e5ea56e24a69289acdf3736c958a8c))  - (Jimmy Briggs)
- Add GitHub Copilot instructions for PowerShell profile repository ([13f5ae6](https://github.com/jimbrig/psprof/commit/13f5ae6e43daab475040888294e624aa1e469a01))  - (Jimmy Briggs)
- **ai:** Add PowerShell profile debugging documentation ([e835c63](https://github.com/jimbrig/psprof/commit/e835c63c858548890012cd147917679055b8e7b7))  - (Jimmy Briggs)
- Update README to include profile optimization details ([94e982b](https://github.com/jimbrig/psprof/commit/94e982b43de2fcbd12b24010b99b167502fddfba))  - (Jimmy Briggs)
- Readme ([2c82b1e](https://github.com/jimbrig/psprof/commit/2c82b1e6fb434774769504cae0cb09a2a21ae37e))  - (Jimmy Briggs)
- Readme ([b3e2e4f](https://github.com/jimbrig/psprof/commit/b3e2e4f746418e0d5527fc43def8acbb45735bb8))  - (Jimmy Briggs)

## Features

- **logging:** Enhance logging functionality and measurement in profile scripts ([209b409](https://github.com/jimbrig/psprof/commit/209b4094c7320b2026dc388ba48ce94330f9c105))  - (Jimmy Briggs)
- **module:** Add PSModuleMgmt for PowerShell module management ([48347ac](https://github.com/jimbrig/psprof/commit/48347ac9360188a63ce1f1e2ae430204b6da6eb6))  - (Jimmy Briggs)
  - **BREAKING CHANGE:** This is the initial release of the module; users should be aware that it is still in development and may not cover all use cases.
- **module:** Add module for managing Windows Defender exclusions ([918bbb4](https://github.com/jimbrig/psprof/commit/918bbb4852264974959da3acac9b7aba01c70b92))  - (Jimmy Briggs)
- **tests:** Add performance measurement scripts for PowerShell profile optimization ([2c87d43](https://github.com/jimbrig/psprof/commit/2c87d4385a90f92c0a102813111bfe23f8a6df26))  - (Jimmy Briggs)
- **functions:** Add comprehensive system administration tools ([f49df2c](https://github.com/jimbrig/psprof/commit/f49df2c8f5a7513d7bce8fdb8232305f7453e447))  - (Jimmy Briggs)
  - **BREAKING CHANGE:** The structure of the Profile functions has been reorganized; existing scripts may require updates to accommodate new function paths.
- **docs:** Add documentation for PowerShell profile optimization project ([dc7a471](https://github.com/jimbrig/psprof/commit/dc7a471977bd8e8b467b9acce7a97ace87b289e5))  - (Jimmy Briggs)
- **completions:** Add lazy loading for command completions ([67d2b26](https://github.com/jimbrig/psprof/commit/67d2b26b87484b8ecc9547d9cd0fdc7cc1bcbc61))  - (Jimmy Briggs)
- **profile:** Enhance PowerShell profile with performance measurement and environment detection ([e94f720](https://github.com/jimbrig/psprof/commit/e94f720896cb4c431dee22e61ec9d8458cb37461))  - (Jimmy Briggs)
- Prompt ([8a533ee](https://github.com/jimbrig/psprof/commit/8a533eea43b502a8e459f05e3e6dfe1bc2c65960))  - (Jimmy Briggs)
- Style ([9fb208e](https://github.com/jimbrig/psprof/commit/9fb208ec1c5de054c5a80e96eb834411f0bc9205))  - (Jimmy Briggs)
- Add zoxide ([852d09f](https://github.com/jimbrig/psprof/commit/852d09f7e7140e1c184eed11fa8eda7cf487101d))  - (Jimmy Briggs)

## Refactoring

- **completions:** Remove lazy loading mechanism and integrate completions directly ([bc8f98a](https://github.com/jimbrig/psprof/commit/bc8f98a542333cccd64180557771da2ce7422720))  - (Jimmy Briggs)
  - **BREAKING CHANGE:** The previous method of registering lazy-loaded completions is no longer supported; users must update their scripts to use the new completion loading approach.
- **scripts:** Remove Get-PSFunctions.ps1 script ([9188958](https://github.com/jimbrig/psprof/commit/9188958db2d88161d8015a2c9a407d8d50948b92))  - (Jimmy Briggs)
- **profile:** Streamline function loading in PowerShell profile ([0b0d446](https://github.com/jimbrig/psprof/commit/0b0d4464ca88c4fcdf14dd4e1c6cf3ae7f70ff68))  - (Jimmy Briggs)
- Remove ZLocation ([a856776](https://github.com/jimbrig/psprof/commit/a856776873330164f1b339274cc118f5fa39420f))  - (Jimmy Briggs)

***
*Changelog generated by [git-cliff](https://github.com/orhun/git-cliff).*
***
