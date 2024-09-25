# Changelog

All notable changes to this project will be documented in this file.


## [Unreleased]
### Details
#### Changed
- Feat(git): create template and update tooling
- Merge pull request #62 from peario/dev

A lot of minor changes and additions
- Refactor: incorrectly named attrs list, invalid images and module import, etc
- Merge pull request #61 from peario/dev

feat: update commit hooks and github workflow
- Feat: update commit hooks and github workflow

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge pull request #60 from peario/update_flake_lock_action

feat: update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'aquamarine':
    'github:hyprwm/aquamarine/dc399a37d339e958494da270473cbc1d829f7307?narHash=sha256-d8QAY0aQlwnJE2OCTjcX6xx3KSgv0HFEs3CaLE18RnU%3D' (2024-09-17)
  → 'github:hyprwm/aquamarine/752d0fbd141fabb5a1e7f865199b80e6e76f8d8e?narHash=sha256-rEzEZtd3iyVo5RJ1OGujOlnywNf3gsrOnjAn1NLciD4%3D' (2024-09-18)
• Updated input 'hyprland':
    'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=3c9716acfd00c6ea1b7bcd1dc63f97b51cc09998&submodules=1' (2024-09-17)
  → 'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=e6cf643f5ab1c1545fb858ab1fd9d7538ef9e0f3&submodules=1' (2024-09-18)
• Updated input 'neovim-nightly-overlay':
    'github:nix-community/neovim-nightly-overlay/90aaa1e9e6ff67b29840d357413f822056212c08?narHash=sha256-3iDVHqGq8mhP46XqIpepiURz4RJXwGUO0cHtplHhbX0%3D' (2024-09-17)
  → 'github:nix-community/neovim-nightly-overlay/5bb5cd97afc4ddb1e34e104d74fb8bdcde3d336e?narHash=sha256-4fFieOqvMA9RESdcaf1yOpx0zovRhR3MxsIOju6toJw%3D' (2024-09-18)
• Updated input 'neovim-nightly-overlay/neovim-src':
    'github:neovim/neovim/a0d8c2b86e788ce4273f0b8df258cd9e8e432d38?narHash=sha256-M2syKjdJH3uBCOAm9PZndNI46m6xGLXsOadUSen8wpY%3D' (2024-09-16)
  → 'github:neovim/neovim/0ade8fed143dd8cf3ca0571eb4ed66ff27bc0325?narHash=sha256-CQqPd12RyETe43M5zhyd5cLHs1oXhuOVMogL2VnCSgs%3D' (2024-09-17)
• Updated input 'neovim-nightly-overlay/nixpkgs':
    'github:NixOS/nixpkgs/20f9370d5f588fb8c72e844c54511cab054b5f40?narHash=sha256-MWTBH4dd5zIz2iatDb8IkqSjIeFum9jAqkFxgHLdzO4%3D' (2024-09-16)
  → 'github:NixOS/nixpkgs/658e7223191d2598641d50ee4e898126768fe847?narHash=sha256-zACxiQx8knB3F8%2BZe%2B1BpiYrI%2BCbhxyWpcSID9kVhkQ%3D' (2024-09-17)
• Updated input 'nur':
    'github:nix-community/NUR/e1a885ad1f06ff3a62e792bbfdd9115e0ad4c356?narHash=sha256-5vCKUVb1ma4aPNaS5RJebZsRUCpAozmI8cIKEkClqYI%3D' (2024-09-17)
  → 'github:nix-community/NUR/33e23c8a9d2f256b7408d565e37a8e5f66073591?narHash=sha256-XZyekNbJWg7rdPYxrBL87j42JKS0l3NWVurGBVSrzIo%3D' (2024-09-18)
• Updated input 'spicetify-nix':
    'github:Gerg-L/spicetify-nix/65e118fae842aa8d7c0d3c11e3b484effc0dde16?narHash=sha256-cgfOnRrsSgxXOUNqTyiLFlnFSC7ukveTEqAzsanCHdk%3D' (2024-09-17)
  → 'github:Gerg-L/spicetify-nix/9f373314f087e11183afe6928d48a816d44929d4?narHash=sha256-Ef/kTMoV3aPfecL2X27sxYshsLJJDIBFKYjPsqaTUBw%3D' (2024-09-18)
• Updated input 'wezterm':
    'github:wez/wezterm/2d0c5cddc91a9c59aef9a7667d90924e7cedd0ac?dir=nix&narHash=sha256-6aDv7s8cUL/PG/RRIkDlydMFL8xii9Xhw1JXI9G96xs%3D' (2024-09-15)
  → 'github:wez/wezterm/832c533c5f9e8d1c3315f2fbf96c125927a232f7?dir=nix&narHash=sha256-ezIgDZP0Oq3tx0quGvTdpNJipmg1Yo95etnDPGTqTqg%3D' (2024-09-18)
- Merge pull request #59 from peario/dependabot/npm_and_yarn/packages/lite-server/npm_and_yarn-8a50bcc0c8

build(deps): Bump the npm_and_yarn group across 1 directory with 4 updates
- Build(deps): Bump the npm_and_yarn group across 1 directory with 4 updates

Bumps the npm_and_yarn group with 4 updates in the /packages/lite-server directory: [ansi-regex](https://github.com/chalk/ansi-regex), [axios](https://github.com/axios/axios), [browser-sync](https://github.com/BrowserSync/browser-sync) and [braces](https://github.com/micromatch/braces).


Updates `ansi-regex` from 5.0.0 to 5.0.1
- [Release notes](https://github.com/chalk/ansi-regex/releases)
- [Commits](https://github.com/chalk/ansi-regex/compare/v5.0.0...v5.0.1)

Updates `ansi-regex` from 4.1.0 to 5.0.1
- [Release notes](https://github.com/chalk/ansi-regex/releases)
- [Commits](https://github.com/chalk/ansi-regex/compare/v5.0.0...v5.0.1)

Removes `axios`

Updates `browser-sync` from 2.29.3 to 3.0.2
- [Release notes](https://github.com/BrowserSync/browser-sync/releases)
- [Changelog](https://github.com/BrowserSync/browser-sync/blob/master/CHANGELOG.md)
- [Commits](https://github.com/BrowserSync/browser-sync/compare/v2.29.3...v3.0.2)

Updates `braces` from 3.0.2 to 3.0.3
- [Changelog](https://github.com/micromatch/braces/blob/master/CHANGELOG.md)
- [Commits](https://github.com/micromatch/braces/compare/3.0.2...3.0.3)

---
updated-dependencies:
- dependency-name: ansi-regex
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: ansi-regex
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: axios
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: browser-sync
  dependency-type: direct:production
  dependency-group: npm_and_yarn
- dependency-name: braces
  dependency-type: indirect
  dependency-group: npm_and_yarn
...

Signed-off-by: dependabot[bot] <support@github.com>
- Merge pull request #58 from peario/dependabot/npm_and_yarn/packages/lite-server/npm_and_yarn-aa46109cfd

build(deps): Bump the npm_and_yarn group across 1 directory with 26 updates
- Build(deps): Bump the npm_and_yarn group across 1 directory with 26 updates

Bumps the npm_and_yarn group with 9 updates in the /packages/lite-server directory:

| Package | From | To |
| --- | --- | --- |
| [lodash](https://github.com/lodash/lodash) | `4.17.20` | `4.17.21` |
| [minimist](https://github.com/minimistjs/minimist) | `1.2.5` | `1.2.8` |
| [handlebars](https://github.com/handlebars-lang/handlebars.js) | `4.1.2` | `4.7.8` |
| [engine.io](https://github.com/socketio/engine.io) | `3.2.1` | `6.5.5` |
| [browser-sync](https://github.com/BrowserSync/browser-sync) | `2.26.13` | `2.29.3` |
| [minimatch](https://github.com/isaacs/minimatch) | `3.0.4` | `3.1.2` |
| [mocha](https://github.com/mochajs/mocha) | `8.2.1` | `10.7.3` |
| [moment](https://github.com/moment/moment) | `2.24.0` | `2.30.1` |
| [path-to-regexp](https://github.com/pillarjs/path-to-regexp) | `1.7.0` | `1.9.0` |



Updates `lodash` from 4.17.20 to 4.17.21
- [Release notes](https://github.com/lodash/lodash/releases)
- [Commits](https://github.com/lodash/lodash/compare/4.17.20...4.17.21)

Updates `minimist` from 1.2.5 to 1.2.8
- [Changelog](https://github.com/minimistjs/minimist/blob/main/CHANGELOG.md)
- [Commits](https://github.com/minimistjs/minimist/compare/v1.2.5...v1.2.8)

Updates `handlebars` from 4.1.2 to 4.7.8
- [Release notes](https://github.com/handlebars-lang/handlebars.js/releases)
- [Changelog](https://github.com/handlebars-lang/handlebars.js/blob/v4.7.8/release-notes.md)
- [Commits](https://github.com/handlebars-lang/handlebars.js/compare/v4.1.2...v4.7.8)

Updates `braces` from 2.3.2 to 3.0.2
- [Changelog](https://github.com/micromatch/braces/blob/master/CHANGELOG.md)
- [Commits](https://github.com/micromatch/braces/commits/3.0.2)

Updates `engine.io` from 3.2.1 to 6.5.5
- [Release notes](https://github.com/socketio/engine.io/releases)
- [Changelog](https://github.com/socketio/engine.io/blob/6.5.5/CHANGELOG.md)
- [Commits](https://github.com/socketio/engine.io/compare/3.2.1...6.5.5)

Updates `browser-sync` from 2.26.13 to 2.29.3
- [Release notes](https://github.com/BrowserSync/browser-sync/releases)
- [Changelog](https://github.com/BrowserSync/browser-sync/blob/master/CHANGELOG.md)
- [Commits](https://github.com/BrowserSync/browser-sync/compare/v2.26.13...v2.29.3)

Updates `eslint-utils` from 1.4.0 to 2.1.0
- [Release notes](https://github.com/mysticatea/eslint-utils/releases)
- [Commits](https://github.com/mysticatea/eslint-utils/compare/v1.4.0...v2.1.0)

Updates `flat` from 4.1.0 to 5.0.2
- [Release notes](https://github.com/hughsk/flat/releases)
- [Commits](https://github.com/hughsk/flat/compare/4.1.0...5.0.2)

Updates `follow-redirects` from 1.5.10 to 1.15.9
- [Release notes](https://github.com/follow-redirects/follow-redirects/releases)
- [Commits](https://github.com/follow-redirects/follow-redirects/compare/v1.5.10...v1.15.9)

Updates `fsevents` from 1.2.9 to 2.1.3
- [Release notes](https://github.com/fsevents/fsevents/releases)
- [Commits](https://github.com/fsevents/fsevents/compare/v1.2.9...2.1.3)

Updates `glob-parent` from 3.1.0 to 5.1.1
- [Release notes](https://github.com/gulpjs/glob-parent/releases)
- [Changelog](https://github.com/gulpjs/glob-parent/blob/main/CHANGELOG.md)
- [Commits](https://github.com/gulpjs/glob-parent/compare/v3.1.0...v5.1.1)

Updates `http-proxy` from 1.15.2 to 1.18.1
- [Release notes](https://github.com/http-party/node-http-proxy/releases)
- [Changelog](https://github.com/http-party/node-http-proxy/blob/master/CHANGELOG.md)
- [Commits](https://github.com/http-party/node-http-proxy/compare/1.15.2...1.18.1)

Updates `micromatch` from 3.1.10 to 4.0.8
- [Release notes](https://github.com/micromatch/micromatch/releases)
- [Changelog](https://github.com/micromatch/micromatch/blob/master/CHANGELOG.md)
- [Commits](https://github.com/micromatch/micromatch/compare/3.1.10...4.0.8)

Updates `minimatch` from 3.0.4 to 3.1.2
- [Changelog](https://github.com/isaacs/minimatch/blob/main/changelog.md)
- [Commits](https://github.com/isaacs/minimatch/compare/v3.0.4...v3.1.2)

Updates `mocha` from 8.2.1 to 10.7.3
- [Release notes](https://github.com/mochajs/mocha/releases)
- [Changelog](https://github.com/mochajs/mocha/blob/main/CHANGELOG.md)
- [Commits](https://github.com/mochajs/mocha/compare/v8.2.1...v10.7.3)

Updates `moment` from 2.24.0 to 2.30.1
- [Changelog](https://github.com/moment/moment/blob/develop/CHANGELOG.md)
- [Commits](https://github.com/moment/moment/compare/2.24.0...2.30.1)

Updates `ms` from 0.7.1 to 2.0.0
- [Release notes](https://github.com/vercel/ms/releases)
- [Commits](https://github.com/vercel/ms/compare/0.7.1...2.0.0)

Updates `path-to-regexp` from 1.7.0 to 1.9.0
- [Release notes](https://github.com/pillarjs/path-to-regexp/releases)
- [Changelog](https://github.com/pillarjs/path-to-regexp/blob/master/History.md)
- [Commits](https://github.com/pillarjs/path-to-regexp/compare/v1.7.0...v1.9.0)

Updates `semver` from 5.3.0 to 7.3.2
- [Release notes](https://github.com/npm/node-semver/releases)
- [Changelog](https://github.com/npm/node-semver/blob/main/CHANGELOG.md)
- [Commits](https://github.com/npm/node-semver/compare/v5.3.0...v7.3.2)

Updates `socket.io-parser` from 3.2.0 to 4.2.4
- [Release notes](https://github.com/Automattic/socket.io-parser/releases)
- [Changelog](https://github.com/socketio/socket.io-parser/blob/4.2.4/CHANGELOG.md)
- [Commits](https://github.com/Automattic/socket.io-parser/compare/3.2.0...4.2.4)

Updates `socket.io` from 2.1.1 to 4.7.5
- [Release notes](https://github.com/socketio/socket.io/releases)
- [Changelog](https://github.com/socketio/socket.io/blob/socket.io@4.7.5/CHANGELOG.md)
- [Commits](https://github.com/socketio/socket.io/compare/2.1.1...socket.io@4.7.5)

Updates `ua-parser-js` from 0.7.17 to 1.0.39
- [Release notes](https://github.com/faisalman/ua-parser-js/releases)
- [Changelog](https://github.com/faisalman/ua-parser-js/blob/1.0.39/changelog.md)
- [Commits](https://github.com/faisalman/ua-parser-js/compare/0.7.17...1.0.39)

Updates `ws` from 3.3.3 to 8.17.1
- [Release notes](https://github.com/websockets/ws/releases)
- [Commits](https://github.com/websockets/ws/compare/3.3.3...8.17.1)

Updates `xmlhttprequest-ssl` from 1.5.5 to 2.0.0
- [Commits](https://github.com/mjwwit/node-XMLHttpRequest/compare/1.5.5...2.0.0)

Updates `y18n` from 3.2.1 to 5.0.8
- [Release notes](https://github.com/yargs/y18n/releases)
- [Changelog](https://github.com/yargs/y18n/blob/master/CHANGELOG.md)
- [Commits](https://github.com/yargs/y18n/compare/v3.2.1...v5.0.8)

Updates `yargs-parser` from 4.2.0 to 20.2.9
- [Release notes](https://github.com/yargs/yargs-parser/releases)
- [Changelog](https://github.com/yargs/yargs-parser/blob/main/CHANGELOG.md)
- [Commits](https://github.com/yargs/yargs-parser/compare/v4.2.0...yargs-parser-v20.2.9)

---
updated-dependencies:
- dependency-name: lodash
  dependency-type: direct:production
  dependency-group: npm_and_yarn
- dependency-name: minimist
  dependency-type: direct:production
  dependency-group: npm_and_yarn
- dependency-name: handlebars
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: braces
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: engine.io
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: browser-sync
  dependency-type: direct:production
  dependency-group: npm_and_yarn
- dependency-name: eslint-utils
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: flat
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: follow-redirects
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: fsevents
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: glob-parent
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: http-proxy
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: micromatch
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: minimatch
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: mocha
  dependency-type: direct:development
  dependency-group: npm_and_yarn
- dependency-name: moment
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: ms
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: path-to-regexp
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: semver
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: socket.io-parser
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: socket.io
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: ua-parser-js
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: ws
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: xmlhttprequest-ssl
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: y18n
  dependency-type: indirect
  dependency-group: npm_and_yarn
- dependency-name: yargs-parser
  dependency-type: indirect
  dependency-group: npm_and_yarn
...

Signed-off-by: dependabot[bot] <support@github.com>
- Merge pull request #57 from peario/update_flake_lock_action

feat: update flake.lock
- Merge branch 'master' into update_flake_lock_action
- Merge pull request #56 from peario/dev

feat: general update
- Merge branch 'master' into dev
- Feat: General update

This is a general update which covers a wider range of modifications.
Listed here are the most noticeable changes.

Added:
- ability to install npm packages via `modules/home/programs/development/nodejs`
- store npm packages in `~/.npm-packages`
- installed npm package: `lite-server`, `nodemon` and `rimraf`
- config file for `cbfmt`, `statix`, `stylua` and `treefmt` (formatters)
- more tooling to default dev shell

Fixed/changed:
- some attrs lists were incorrectly named
- update `flake.lock`
- (attempted to) disable some formatters/linters in `./checks/pre-commit-hooks/default.nix`
- homebrew now has addons installed, like: `whalebrew`, `mas-cli`, `homebrew-bundle`, etc.
- resolved curl (and openssl) issue with homebrew
- disabled `deadnix.yml` workflow due to `lite-server` package

Probably more changes have been done but forgotten.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Flake.lock: Update

Flake lock file updates:

• Updated input 'aquamarine':
    'github:hyprwm/aquamarine/e4a13203112a036fc7f437d391c7810f3dd5ab52?narHash=sha256-/NO/h/qD/eJXAQr/fHA4mdDgYsNT9thHQ%2BoT6KPi2ac%3D' (2024-09-07)
  → 'github:hyprwm/aquamarine/dc399a37d339e958494da270473cbc1d829f7307?narHash=sha256-d8QAY0aQlwnJE2OCTjcX6xx3KSgv0HFEs3CaLE18RnU%3D' (2024-09-17)
• Updated input 'darwin':
    'github:LnL7/nix-darwin/21fe31f26473c180390cfa81e3ea81aca0204c80?narHash=sha256-Vop/VRi6uCiScg/Ic%2BYlwsdIrLabWUJc57dNczp0eBc%3D' (2024-09-13)
  → 'github:LnL7/nix-darwin/6374cd7e50aa057a688142eed2345083047ad884?narHash=sha256-i0h300W3t7Q7PltJPmucj%2Bub45SE/bNQ%2Bpf83tasYAQ%3D' (2024-09-17)
• Updated input 'disko':
    'github:nix-community/disko/22ee467a54a3ab7fa9d637ccad5330c6c087e9dc?narHash=sha256-xkPPPvfHhHK7BNX5ZrQ9N6AIEixCmFzRZHduDf0zv30%3D' (2024-09-16)
  → 'github:nix-community/disko/d32d1504c77d7f6ba7e033357dcf638baceab9b7?narHash=sha256-5bxY85siOIqOcQ8TOMAWLkMUZvLUADS2i5TsZhzUIZY%3D' (2024-09-17)
• Updated input 'home-manager':
    'github:nix-community/home-manager/a9c9cc6e50f7cbd2d58ccb1cd46a1e06e9e445ff?narHash=sha256-ChhIrjtdu5d83W%2BYDRH%2BEc5g1MmM0xk6hJnkz15Ot7M%3D' (2024-09-15)
  → 'github:nix-community/home-manager/d2493de5cd1da06b6a4c3e97f4e7d5dd791df457?narHash=sha256-/bxaYvIK6/d3zqpW26QFS0rqfd0cO4qreSNWvYLTl/w%3D' (2024-09-17)
• Updated input 'hyprland':
    'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=9e356562446f44c471ae38a80506a9df039305d6&submodules=1' (2024-09-15)
  → 'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=3c9716acfd00c6ea1b7bcd1dc63f97b51cc09998&submodules=1' (2024-09-17)
• Updated input 'neovim-nightly-overlay':
    'github:nix-community/neovim-nightly-overlay/7d1c6f5314633cb52330dbfe26cb352ff14c295c?narHash=sha256-Y4L6/wzlhaTarOX15eVfIxzOG4EaebWHwjNW2EEBcGI%3D' (2024-09-16)
  → 'github:nix-community/neovim-nightly-overlay/90aaa1e9e6ff67b29840d357413f822056212c08?narHash=sha256-3iDVHqGq8mhP46XqIpepiURz4RJXwGUO0cHtplHhbX0%3D' (2024-09-17)
• Updated input 'neovim-nightly-overlay/neovim-src':
    'github:neovim/neovim/78b85109338592c2bc89154278f2e961a14eee96?narHash=sha256-5UytTFcPk%2Bf1mCqSUV4kiYnu3ZopPs7aWiOBMvYtFW8%3D' (2024-09-15)
  → 'github:neovim/neovim/a0d8c2b86e788ce4273f0b8df258cd9e8e432d38?narHash=sha256-M2syKjdJH3uBCOAm9PZndNI46m6xGLXsOadUSen8wpY%3D' (2024-09-16)
• Updated input 'neovim-nightly-overlay/nixpkgs':
    'github:NixOS/nixpkgs/76d7694a3f681b0b750c01783df5d2177ef39fe7?narHash=sha256-EpiSl9nSINTmIW6MG6CulGwNAa6sHrBt8gQdyHUXzR4%3D' (2024-09-15)
  → 'github:NixOS/nixpkgs/20f9370d5f588fb8c72e844c54511cab054b5f40?narHash=sha256-MWTBH4dd5zIz2iatDb8IkqSjIeFum9jAqkFxgHLdzO4%3D' (2024-09-16)
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/345c263f2f53a3710abe117f28a5cb86d0ba4059?narHash=sha256-sjiGsMh%2B1cWXb53Tecsm4skyFNag33GPbVgCdfj3n9I%3D' (2024-09-13)
  → 'github:nixos/nixpkgs/99dc8785f6a0adac95f5e2ab05cc2e1bf666d172?narHash=sha256-gI9kkaH0ZjakJOKrdjaI/VbaMEo9qBbSUl93DnU7f4c%3D' (2024-09-16)
• Updated input 'nixpkgs-unstable':
    'github:nixos/nixpkgs/20f9370d5f588fb8c72e844c54511cab054b5f40?narHash=sha256-MWTBH4dd5zIz2iatDb8IkqSjIeFum9jAqkFxgHLdzO4%3D' (2024-09-16)
  → 'github:nixos/nixpkgs/658e7223191d2598641d50ee4e898126768fe847?narHash=sha256-zACxiQx8knB3F8%2BZe%2B1BpiYrI%2BCbhxyWpcSID9kVhkQ%3D' (2024-09-17)
• Updated input 'nur':
    'github:nix-community/NUR/023b6b20cf5250d9ee0fd4713775dac9f696e407?narHash=sha256-dQ4uRthSynzI8nNYISYmoKMH2cKW/RgiePykb87jBXU%3D' (2024-09-16)
  → 'github:nix-community/NUR/e1a885ad1f06ff3a62e792bbfdd9115e0ad4c356?narHash=sha256-5vCKUVb1ma4aPNaS5RJebZsRUCpAozmI8cIKEkClqYI%3D' (2024-09-17)
• Updated input 'spicetify-nix':
    'github:Gerg-L/spicetify-nix/fe1722602352cba0448f3961df90b5d1f55d5675?narHash=sha256-wslbKgh6ZEqHzZJj1eHGRENZQ4r1C4LmAvaBKvbiGzg%3D' (2024-09-16)
  → 'github:Gerg-L/spicetify-nix/65e118fae842aa8d7c0d3c11e3b484effc0dde16?narHash=sha256-cgfOnRrsSgxXOUNqTyiLFlnFSC7ukveTEqAzsanCHdk%3D' (2024-09-17)
- Merge pull request #54 from peario/update_flake_lock_action

Update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'disko':
    'github:nix-community/disko/51e3a7e51279fedfb6669a00d21dc5936c78a6ce?narHash=sha256-KRGuT5nGRAOT3heigRWg41tbYpTpapGhsWc%2BXjnIx0w%3D' (2024-09-15)
  → 'github:nix-community/disko/22ee467a54a3ab7fa9d637ccad5330c6c087e9dc?narHash=sha256-xkPPPvfHhHK7BNX5ZrQ9N6AIEixCmFzRZHduDf0zv30%3D' (2024-09-16)
• Updated input 'hyprwayland-scanner':
    'github:hyprwm/hyprwayland-scanner/a048a6cb015340bd82f97c1f40a4b595ca85cc30?narHash=sha256-SOOqIT27/X792%2BvsLSeFdrNTF%2BOSRp5qXv6Te%2Bfb2Qg%3D' (2024-07-18)
  → 'github:hyprwm/hyprwayland-scanner/f68f1592552d6ab0a3ebead45a5aaf0ae6ef7ea4?narHash=sha256-WezCRoSGoK2/dH%2BtptC85vV8MM1/eXUGiKwAYKNwTzE%3D' (2024-09-16)
• Updated input 'neovim-nightly-overlay':
    'github:nix-community/neovim-nightly-overlay/a97833a4f127d2723032afa6661adb15a020bbe1?narHash=sha256-%2B5XiPehXPmVym1LGgd8bK3VRSX5TRdku639TNA/H3VY%3D' (2024-09-15)
  → 'github:nix-community/neovim-nightly-overlay/7d1c6f5314633cb52330dbfe26cb352ff14c295c?narHash=sha256-Y4L6/wzlhaTarOX15eVfIxzOG4EaebWHwjNW2EEBcGI%3D' (2024-09-16)
• Updated input 'neovim-nightly-overlay/neovim-src':
    'github:neovim/neovim/3b54adc6c6d25dd146fa1eac21321f6bd612f50a?narHash=sha256-KwsP2EVfcKexBaqrt3QGUX7GRFieDKEP/bx521dUOso%3D' (2024-09-14)
  → 'github:neovim/neovim/78b85109338592c2bc89154278f2e961a14eee96?narHash=sha256-5UytTFcPk%2Bf1mCqSUV4kiYnu3ZopPs7aWiOBMvYtFW8%3D' (2024-09-15)
• Updated input 'neovim-nightly-overlay/nixpkgs':
    'github:NixOS/nixpkgs/673d99f1406cb09b8eb6feab4743ebdf70046557?narHash=sha256-tI7141IHDABMNgz4iXDo8agCp0SeTLbaIZ2DRndwcmk%3D' (2024-09-13)
  → 'github:NixOS/nixpkgs/76d7694a3f681b0b750c01783df5d2177ef39fe7?narHash=sha256-EpiSl9nSINTmIW6MG6CulGwNAa6sHrBt8gQdyHUXzR4%3D' (2024-09-15)
• Updated input 'nix-index-database':
    'github:nix-community/nix-index-database/0a2fba621b6bbf06be0b4edd974236e3d2fcc1a9?narHash=sha256-CJOV4JiLhd%2B%2Bw9K%2Bh2z00DiB4R1CCuElWzhldrXSq5w%3D' (2024-09-15)
  → 'github:nix-community/nix-index-database/c1b0fa0bec5478185eae2fd3f39b9e906fc83995?narHash=sha256-1AX7MyYzP7sNgZiGF8jwehCCI75y2kBGwACeryJs%2ByE%3D' (2024-09-16)
• Updated input 'nixos-wsl':
    'github:nix-community/nixos-wsl/34b95b3962f5b3436d4bae5091d1b2ff7c1eb180?narHash=sha256-v5L%2BDh6KdyycIgcdIc6SQ1fRNNvFJmYz02%2BfyeptA2o%3D' (2024-09-09)
  → 'github:nix-community/nixos-wsl/20630a560fa658b1f4fc16e6ef2b6b3d6f8539f5?narHash=sha256-nE34QJfnkLZyZIVOXd73iICyvYROVSOo4h7pVRs0mqg%3D' (2024-09-16)
• Updated input 'nixpkgs-unstable':
    'github:nixos/nixpkgs/76d7694a3f681b0b750c01783df5d2177ef39fe7?narHash=sha256-EpiSl9nSINTmIW6MG6CulGwNAa6sHrBt8gQdyHUXzR4%3D' (2024-09-15)
  → 'github:nixos/nixpkgs/20f9370d5f588fb8c72e844c54511cab054b5f40?narHash=sha256-MWTBH4dd5zIz2iatDb8IkqSjIeFum9jAqkFxgHLdzO4%3D' (2024-09-16)
• Updated input 'nur':
    'github:nix-community/NUR/78cd13993888ce8ea4675580148be3dc3c8fe143?narHash=sha256-xz0t0FBzA%2BZFqK8MUEQdx8HxH3Kh3uye8Uzgp1GMCE4%3D' (2024-09-15)
  → 'github:nix-community/NUR/023b6b20cf5250d9ee0fd4713775dac9f696e407?narHash=sha256-dQ4uRthSynzI8nNYISYmoKMH2cKW/RgiePykb87jBXU%3D' (2024-09-16)
• Updated input 'sops-nix':
    'github:Mic92/sops-nix/f30b1bac192e2dc252107ac8a59a03ad25e1b96e?narHash=sha256-z7CoWbSOtsOz8TmRKDnobURkKfv6nPZCo3ayolNuQGc%3D' (2024-09-13)
  → 'github:Mic92/sops-nix/e2d404a7ea599a013189aa42947f66cede0645c8?narHash=sha256-qis6BtOOBBEAfUl7FMHqqTwRLB61OL5OFzIsOmRz2J4%3D' (2024-09-16)
• Updated input 'spicetify-nix':
    'github:Gerg-L/spicetify-nix/1c0fda45c222294971b5c3efdfa2aa29f0a7d2f6?narHash=sha256-CmOPn3mknUR6y6CpBopZT2Y4dz10BPw0Y7Gfgm4EerI%3D' (2024-09-15)
  → 'github:Gerg-L/spicetify-nix/fe1722602352cba0448f3961df90b5d1f55d5675?narHash=sha256-wslbKgh6ZEqHzZJj1eHGRENZQ4r1C4LmAvaBKvbiGzg%3D' (2024-09-16)
• Updated input 'waybar':
    'github:Alexays/Waybar/0d02f6877d88551ea2be0cd151c1e6354e208b1c?narHash=sha256-Z2ZS4rD3FjNIblPlXpx9XhkvepZWhO4xnJNk7o5ebe0%3D' (2024-09-15)
  → 'github:Alexays/Waybar/9cfb1e38fa26b5c4639fe510c06af0916a078d93?narHash=sha256-7gMxY5vgFOkezgQ/3deq0O85oqGlN4uEuwGPkVPC2do%3D' (2024-09-16)
- Merge pull request #55 from peario/dev

feat(wsl): update host name
- Feat(wsl): update host name

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge pull request #53 from peario/dev

feat: add templates
- Merge pull request #52 from peario/master

Bring dev up to date
- Merge pull request #51 from peario/update_flake_lock_action

Update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'home-manager':
    'github:nix-community/home-manager/e524c57b1fa55d6ca9d8354c6ce1e538d2a1f47f?narHash=sha256-p4OrJL2weh0TRtaeu1fmNYP6%2BTOp/W2qdaIJxxQay4c%3D' (2024-09-14)
  → 'github:nix-community/home-manager/a9c9cc6e50f7cbd2d58ccb1cd46a1e06e9e445ff?narHash=sha256-ChhIrjtdu5d83W%2BYDRH%2BEc5g1MmM0xk6hJnkz15Ot7M%3D' (2024-09-15)
• Updated input 'hyprland':
    'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=e74efd87e5aa38f9cf84cb3848ee1ab26e5e4bcb&submodules=1' (2024-09-14)
  → 'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=9e356562446f44c471ae38a80506a9df039305d6&submodules=1' (2024-09-15)
• Updated input 'nixpkgs-unstable':
    'github:nixos/nixpkgs/9299cdf978e15f448cf82667b0ffdd480b44ee48?narHash=sha256-luAKNxWZ%2BZN0kaHchx1OdLQ71n81Y31ryNPWP1YRDZc%3D' (2024-09-15)
  → 'github:nixos/nixpkgs/76d7694a3f681b0b750c01783df5d2177ef39fe7?narHash=sha256-EpiSl9nSINTmIW6MG6CulGwNAa6sHrBt8gQdyHUXzR4%3D' (2024-09-15)
• Updated input 'nur':
    'github:nix-community/NUR/c427237ac81b66f02f796727b876d2b707ca77ad?narHash=sha256-7Gg/4kFg7wYNIR89k1nNMIA%2B5O9832lze%2Bx6sJ87qw4%3D' (2024-09-15)
  → 'github:nix-community/NUR/78cd13993888ce8ea4675580148be3dc3c8fe143?narHash=sha256-xz0t0FBzA%2BZFqK8MUEQdx8HxH3Kh3uye8Uzgp1GMCE4%3D' (2024-09-15)
• Updated input 'wezterm':
    'github:wez/wezterm/9bf30b8dd68efb5c8a409dbdcfca0e2151012e1e?dir=nix&narHash=sha256-CDurVvIRQzV9nOW/WI%2BGkDggjHVWeFq1l0Pxx1opyko%3D' (2024-09-15)
  → 'github:wez/wezterm/2d0c5cddc91a9c59aef9a7667d90924e7cedd0ac?dir=nix&narHash=sha256-6aDv7s8cUL/PG/RRIkDlydMFL8xii9Xhw1JXI9G96xs%3D' (2024-09-15)
- Merge pull request #50 from peario/dev

feat(nixos): Add NixOS support
- Feat(nixos): Add NixOS support

Not yet pushed to `cachix`.

Not yet tested on a NixOS, linux-based or WSL system.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: update deps and opts

Commented out 2 dependencies, OpenSSL-related.

As for opts, forgot to enable `eza` aliases from fc98cee.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge pull request #49 from peario/dev

refactor(home): make options more uniform
- Refactor(home): make options more uniform

Just like 8c7552e, it has been verified that these changes does not cause any issues.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge pull request #48 from peario/update_flake_lock_action

Update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'nixpkgs-unstable':
    'github:nixos/nixpkgs/d9d07251f12399413e6d33d5875a6f1994ef75a7?narHash=sha256-SxGeAYrGoCnaGkQHNzGvExpgJv1pfS5J2pMX7zlwWxE%3D' (2024-09-14)
  → 'github:nixos/nixpkgs/9299cdf978e15f448cf82667b0ffdd480b44ee48?narHash=sha256-luAKNxWZ%2BZN0kaHchx1OdLQ71n81Y31ryNPWP1YRDZc%3D' (2024-09-15)
• Updated input 'nur':
    'github:nix-community/NUR/87e71e19db7075e0ce696387d85d73000e6a6f2e?narHash=sha256-5nC1vhaMB0avDLa38UEUNgvl189xQ4tI3olDoGb//XY%3D' (2024-09-15)
  → 'github:nix-community/NUR/1a4d47c6fc08986702c185ef0409d59dd42269a1?narHash=sha256-LVGtTtPzF0rxy3nKzegvaLVsTKSM0IMLjfbxnh7FKP0%3D' (2024-09-15)
- Merge pull request #47 from peario/dev

Merge flake.lock and cachix update into master
- Merge branch 'master' into dev
- Merge pull request #45 from peario/update_flake_lock_action

Update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'disko':
    'github:nix-community/disko/4ef99d8ec41369b6fbe83479b5566c2b8856972c?narHash=sha256-u/2xSCp/7sE7XViv6QR2jMw7Rrx/PXJtmeVLYv%2BQbpo%3D' (2024-09-13)
  → 'github:nix-community/disko/3632080c41d7a657995807689a08ef6c4bcb2c72?narHash=sha256-Mlw7009cdFry9OHpS6jy294lXhb%2BgcRa0iS2hYhkC6s%3D' (2024-09-14)
• Updated input 'home-manager':
    'github:nix-community/home-manager/6c1a461a444e6ccb3f3e42bb627b510c3a722a57?narHash=sha256-d4vwO5N4RsLnCY7k5tY9xbdYDWQsY3RDMeUoIa4ms2A%3D' (2024-09-14)
  → 'github:nix-community/home-manager/e524c57b1fa55d6ca9d8354c6ce1e538d2a1f47f?narHash=sha256-p4OrJL2weh0TRtaeu1fmNYP6%2BTOp/W2qdaIJxxQay4c%3D' (2024-09-14)
• Updated input 'hyprland':
    'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=d35e70a8c6599bb058cf86eb87c783ce1cf72471&submodules=1' (2024-09-13)
  → 'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=e74efd87e5aa38f9cf84cb3848ee1ab26e5e4bcb&submodules=1' (2024-09-14)
• Updated input 'nixpkgs-unstable':
    'github:nixos/nixpkgs/673d99f1406cb09b8eb6feab4743ebdf70046557?narHash=sha256-tI7141IHDABMNgz4iXDo8agCp0SeTLbaIZ2DRndwcmk%3D' (2024-09-13)
  → 'github:nixos/nixpkgs/01f064c99c792715054dc7a70e4c1626dbbec0c3?narHash=sha256-3//V84fYaGVncFImitM6lSAliRdrGayZLdxWlpcuGk0%3D' (2024-09-13)
• Updated input 'nur':
    'github:nix-community/NUR/5f16717be1be9c0970cfeee53b0fe190fa128c43?narHash=sha256-Fi/OD8Iz0ijaKV8YuaKhiUrA1ZZPf6XZF4Qa5eRCeOQ%3D' (2024-09-14)
  → 'github:nix-community/NUR/8ea436a1f584f237c53b4dc4c5de958bb9141c4a?narHash=sha256-EFAeTwFR1FpTXKUDajJGPYOGofIA0f9cRo9Oi8bmRUc%3D' (2024-09-15)
• Updated input 'wezterm':
    'github:wez/wezterm/30345b36d8a00fed347e4df5dadd83915a7693fb?dir=nix&narHash=sha256-ZsDJQSUokodwFMP4FIZm2dYojf5iC4F/EeKC5VuQlqY%3D' (2024-08-13)
  → 'github:wez/wezterm/1eddc9157f51577d7984dd6aec3b780ecec1d4a0?dir=nix&narHash=sha256-yGcSRN6T7YgRI2k0LpcKwuJQ%2BQO/YvzBVeUaWtlMN3U%3D' (2024-09-15)
• Updated input 'wezterm/nixpkgs':
    'github:NixOS/nixpkgs/6e14bbce7bea6c4efd7adfa88a40dac750d80100?narHash=sha256-pFSxgSZqZ3h%2B5Du0KvEL1ccDZBwu4zvOil1zzrPNb3c%3D' (2024-07-20)
  → 'github:NixOS/nixpkgs/01f064c99c792715054dc7a70e4c1626dbbec0c3?narHash=sha256-3//V84fYaGVncFImitM6lSAliRdrGayZLdxWlpcuGk0%3D' (2024-09-13)
• Updated input 'wezterm/rust-overlay':
    'github:oxalica/rust-overlay/b7996075da11a2d441cfbf4e77c2939ce51506fd?narHash=sha256-gYGX9/22tPNeF7dR6bWN5rsrpU4d06GnQNNgZ6ZiXz0%3D' (2024-07-20)
  → 'github:oxalica/rust-overlay/e9f8641c92f26fd1e076e705edb12147c384171d?narHash=sha256-YfLRPlFZWrT2oRLNAoqf7G3%2BNnUTDdlIJk6tmBU7kXM%3D' (2024-09-14)
- Merge pull request #46 from peario/dev

refactor(darwin): make options more uniform
- Feat: update flake.lock

Indirectly committed as a base for merging `dev` with `master` and to get GitHub Workflows to use
the new binaries pushed to `Cachix` via:
1. `nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | cachix push space`
2. `nix path-info --all | cachix push space`

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: update github workflows

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(nix): update nix inputs

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Refactor(darwin): make options more uniform

This time the options have been verified to not cause issues.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge(#44): from flake.lock update

Update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'home-manager':
    'github:nix-community/home-manager/503af483e1b328691ea3a434d331995595fb2e3d?narHash=sha256-KuA8ciNR8qCF3dQaCaeh0JWyQUgEwkwDHr/f49Q5/e8%3D' (2024-09-13)
  → 'github:nix-community/home-manager/6c1a461a444e6ccb3f3e42bb627b510c3a722a57?narHash=sha256-d4vwO5N4RsLnCY7k5tY9xbdYDWQsY3RDMeUoIa4ms2A%3D' (2024-09-14)
• Updated input 'neovim-nightly-overlay':
    'github:nix-community/neovim-nightly-overlay/3b426df85fb2edc0da26673c464709e9c8b0c654?narHash=sha256-A6rw8kgxTDmuGD6D8kooF9V%2B%2BiAeXXgqay0vKG/zi/M%3D' (2024-09-13)
  → 'github:nix-community/neovim-nightly-overlay/2da0565b4fa221f7a62e9cafa019cd00b99fdb9e?narHash=sha256-v4DneIggoLBdypeghj4rMzYngKZ1FgDtYKaYDBkfShk%3D' (2024-09-14)
• Updated input 'neovim-nightly-overlay/neovim-src':
    'github:neovim/neovim/deac7df80a1491ae65b68a1a1047902bcd775adc?narHash=sha256-Vu2rOpAKlEFu%2BdGewEBsnAuHHxj8XbGqF52WGmu1NNY%3D' (2024-09-12)
  → 'github:neovim/neovim/67d6b6f27ed3016a2daf6037879d77becc2cfa8f?narHash=sha256-n2kXazdrh5%2BIvCZFrUq4z27n%2BOX70S6UPHxAI0pBg0w%3D' (2024-09-13)
• Updated input 'neovim-nightly-overlay/nixpkgs':
    'github:NixOS/nixpkgs/111ed8812c10d7dc3017de46cbf509600c93f551?narHash=sha256-Ji5wO1lLG99grI0qCRb6FyRPpH9tfdfD1QP/r7IlgfM%3D' (2024-09-12)
  → 'github:NixOS/nixpkgs/673d99f1406cb09b8eb6feab4743ebdf70046557?narHash=sha256-tI7141IHDABMNgz4iXDo8agCp0SeTLbaIZ2DRndwcmk%3D' (2024-09-13)
• Updated input 'nur':
    'github:nix-community/NUR/c562f0c8401ece326f572b81b7188b05acfc65e7?narHash=sha256-8sFBoKCytkGCTBmZdxk16SbUiE4g4jLurBuDKFvxe1s%3D' (2024-09-14)
  → 'github:nix-community/NUR/5f16717be1be9c0970cfeee53b0fe190fa128c43?narHash=sha256-Fi/OD8Iz0ijaKV8YuaKhiUrA1ZZPf6XZF4Qa5eRCeOQ%3D' (2024-09-14)
- Merge(#43): from dev branch

fix: Dependency issue
- Merge pull request #41 from peario/update_flake_lock_action

Update flake.lock
- Flake.lock: Update

Flake lock file updates:

• Updated input 'darwin':
    'github:LnL7/nix-darwin/f4f18f3d7229845e1c9d517457b7a0b90a38b728?narHash=sha256-3VvRGPkpBJobQrFD3slQzMAwZlo4/UwxT8933U5tRVM%3D' (2024-09-11)
  → 'github:LnL7/nix-darwin/21fe31f26473c180390cfa81e3ea81aca0204c80?narHash=sha256-Vop/VRi6uCiScg/Ic%2BYlwsdIrLabWUJc57dNczp0eBc%3D' (2024-09-13)
• Updated input 'disko':
    'github:nix-community/disko/e55f9a8678adc02024a4877c2a403e3f6daf24fe?narHash=sha256-tqoAO8oT6zEUDXte98cvA1saU9%2B1dLJQe3pMKLXv8ps%3D' (2024-09-03)
  → 'github:nix-community/disko/4ef99d8ec41369b6fbe83479b5566c2b8856972c?narHash=sha256-u/2xSCp/7sE7XViv6QR2jMw7Rrx/PXJtmeVLYv%2BQbpo%3D' (2024-09-13)
• Updated input 'home-manager':
    'github:nix-community/home-manager/e5fa72bad0c6f533e8d558182529ee2acc9454fe?narHash=sha256-4QOPemDQ9VRLQaAdWuvdDBhh%2BlEUOAnSMHhdr4nS1mk%3D' (2024-09-10)
  → 'github:nix-community/home-manager/7923c691527d2ee85fe028c6e780ac3bf8606f06?narHash=sha256-E0JYRNOcPNNVpgg/xrCyqH/Go2laDs6EOqxSieam9hI%3D' (2024-09-13)
• Updated input 'hyprland':
    'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=155d44016d0cb11332c454db73d59030cdbd7b13&submodules=1' (2024-09-10)
  → 'git+https://github.com/hyprwm/Hyprland?ref=refs/heads/main&rev=118be4dea048df88fd21b84580fe62950c868c8f&submodules=1' (2024-09-12)
• Updated input 'neovim-nightly-overlay':
    'github:nix-community/neovim-nightly-overlay/336d665707f30a42bd9b99f472d91a6aa286aca6?narHash=sha256-4sDJ53nfQzA425K/iBZIBwoIBJYqIWmIMV3rT6Mpzak%3D' (2024-09-11)
  → 'github:nix-community/neovim-nightly-overlay/3b426df85fb2edc0da26673c464709e9c8b0c654?narHash=sha256-A6rw8kgxTDmuGD6D8kooF9V%2B%2BiAeXXgqay0vKG/zi/M%3D' (2024-09-13)
• Updated input 'neovim-nightly-overlay/flake-parts':
    'github:hercules-ci/flake-parts/567b938d64d4b4112ee253b9274472dc3a346eb6?narHash=sha256-%2Bebgonl3NbiKD2UD0x4BszCZQ6sTfL4xioaM49o5B3Y%3D' (2024-09-01)
  → 'github:hercules-ci/flake-parts/bcef6817a8b2aa20a5a6dbb19b43e63c5bf8619a?narHash=sha256-HO4zgY0ekfwO5bX0QH/3kJ/h4KvUDFZg8YpkNwIbg1U%3D' (2024-09-12)
• Updated input 'neovim-nightly-overlay/neovim-src':
    'github:neovim/neovim/15bfdf73ea17e513edcec63be9ba27a5f4f12c7a?narHash=sha256-naWfBYC6bMs3fKvYQXQiBmk13NsPZDf3ZHLHmZjWn/g%3D' (2024-09-10)
  → 'github:neovim/neovim/deac7df80a1491ae65b68a1a1047902bcd775adc?narHash=sha256-Vu2rOpAKlEFu%2BdGewEBsnAuHHxj8XbGqF52WGmu1NNY%3D' (2024-09-12)
• Updated input 'neovim-nightly-overlay/nixpkgs':
    'github:NixOS/nixpkgs/5775c2583f1801df7b790bf7f7d710a19bac66f4?narHash=sha256-n9pCtzGZ0httmTwMuEbi5E78UQ4ZbQMr1pzi5N0LAG8%3D' (2024-09-09)
  → 'github:NixOS/nixpkgs/111ed8812c10d7dc3017de46cbf509600c93f551?narHash=sha256-Ji5wO1lLG99grI0qCRb6FyRPpH9tfdfD1QP/r7IlgfM%3D' (2024-09-12)
• Updated input 'nixos-generators':
    'github:nix-community/nixos-generators/214efbd73241d72a8f48b8b9a73bb54895cd51a7?narHash=sha256-Z6DglUwgFDz6fIvQ89wx/uBVWrGvEGECq0Ypyk/eigE%3D' (2024-09-09)
  → 'github:nix-community/nixos-generators/5ae384b83b91080f0fead6bc1add1cff8277cb3f?narHash=sha256-u89QyfjtXryLHrO3Wre4kuWK5KDKiXe8lgRi6%2BcUOEw%3D' (2024-09-12)
• Updated input 'nixpkgs':
    'github:nixos/nixpkgs/574d1eac1c200690e27b8eb4e24887f8df7ac27c?narHash=sha256-v3rIhsJBOMLR8e/RNWxr828tB%2BWywYIoajrZKFM%2B0Gg%3D' (2024-09-06)
  → 'github:nixos/nixpkgs/1355a0cbfeac61d785b7183c0caaec1f97361b43?narHash=sha256-4b3A9zPpxAxLnkF9MawJNHDtOOl6ruL0r6Og1TEDGCE%3D' (2024-09-10)
• Updated input 'nixpkgs-small':
    'github:nixos/nixpkgs/aa2c4fc81bf56b380c21c502487bdf75ed51abe9?narHash=sha256-zjSZ0gH4d2EKfsAswZXtpNiTx4K47tFCyGFKspfv1tY%3D' (2024-09-10)
  → 'github:nixos/nixpkgs/c7b929cfd422f37173be14f0787decb6b06aa34c?narHash=sha256-HESGBMdDP5NweNsfCmifXsmYg66EPRseEriIU9vbkog%3D' (2024-09-12)
• Updated input 'nur':
    'github:nix-community/NUR/99437a8b011c4ef8b74dcd755dc5575bc07da554?narHash=sha256-7/GvYvXfl4OMfjMqmndH/RnF7pRgCei9znWLAu8A6gY%3D' (2024-09-11)
  → 'github:nix-community/NUR/7a5f7863d2f2587993c87a5a575cfc2c802defac?narHash=sha256-zi%2Biz7bOmvbNnQphqVUjmJdNdWJAu5g17pPjGFYyu9g%3D' (2024-09-13)
• Updated input 'sops-nix':
    'github:Mic92/sops-nix/cede1a08039178ac12957733e97ab1006c6b6892?narHash=sha256-ruvh8tlEflRPifs5tlpa0gkttzq4UtgXkJQS7FusgFE%3D' (2024-09-09)
  → 'github:Mic92/sops-nix/f30b1bac192e2dc252107ac8a59a03ad25e1b96e?narHash=sha256-z7CoWbSOtsOz8TmRKDnobURkKfv6nPZCo3ayolNuQGc%3D' (2024-09-13)
• Updated input 'spicetify-nix':
    'github:Gerg-L/spicetify-nix/28d73b741367fc51ea1b1a5a2252c8364d4134da?narHash=sha256-pKiu7tnsanAj7U6dRWzgRTfonsb3Ty3DHIR3K8tfXLQ%3D' (2024-09-11)
  → 'github:Gerg-L/spicetify-nix/856a4212b354cfa1f1c747691e1ddf37ff9b1984?narHash=sha256-qiW2nZ6yo2NdkoH0%2BK2/p4eUElEtWIOo711dOB4rJhg%3D' (2024-09-13)
• Updated input 'waybar':
    'github:Alexays/Waybar/6560e32bc1fd3c777d7094b2033a4358a98ca0ee?narHash=sha256-UbVApb%2BB5QyOl%2Bzrc2oKQ6%2BM5aKRiw3EotrjxzUfp9A%3D' (2024-09-10)
  → 'github:Alexays/Waybar/d177969f51b3435308a520c9c0385ae80579b255?narHash=sha256-JlN9FLUuxwXlIACBW%2BNO4OiqVQ1pUNOxzksl2azoWi4%3D' (2024-09-13)
• Updated input 'xdg-desktop-portal-hyprland':
    'github:hyprwm/xdg-desktop-portal-hyprland/11e15b437e7efc39e452f36e15a183225d6bfa39?narHash=sha256-kbSiPA5oXiz1%2B1eVoRslMi5wylHD6SDT8dS9eZAxXAM%3D' (2024-09-01)
  → 'github:hyprwm/xdg-desktop-portal-hyprland/e695669fd8e1d1be9eaae40f35e00f8bd8b64c18?narHash=sha256-6SEsjurq9cdTkITA6d49ncAJe4O/8CgRG5/F//s6Xh8%3D' (2024-09-11)
- Feat: Update GitHub Workflows

Includes changes to labeling, formatting, linting, updates and more.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: Update workflow for automatic updates

More specifically, the Github Action which performs automatic updates of `flake.lock`.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge pull request #40 from peario/dev

Fix after attempt of making options more uniform
- Feat(programs): Update and filter suites & programs

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Revert: Make options more uniform

This reverts commit ac2c288004f0b32d05ec2f63ea424452a1663378.
- Merge pull request #39 from peario/dependabot/github_actions/cachix/install-nix-action-V28

deps: Bump cachix/install-nix-action from V27 to 28
- Deps: Bump cachix/install-nix-action from V27 to 28

Bumps [cachix/install-nix-action](https://github.com/cachix/install-nix-action) from V27 to 28. This release includes the previously tagged commit.
- [Release notes](https://github.com/cachix/install-nix-action/releases)
- [Commits](https://github.com/cachix/install-nix-action/compare/V27...V28)

---
updated-dependencies:
- dependency-name: cachix/install-nix-action
  dependency-type: direct:production
...

Signed-off-by: dependabot[bot] <support@github.com>
- Refactor(software): Make options more uniform

By uniform I mean use `mkEnableOption` and `mkPackageOption` more appropriately as toggle and
package assignment instead of for example `mkOpt types.bool ...`.

Additionally, updated descriptions to fit option type and assignment better.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(templates): Add rust template

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Merge pull request #38 from peario/update_flake_lock_action

fix: workflow formatter
- Feat: Update workflow formatter

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: Update workflow formatter

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: Add codeowners

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: Add dependabot

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(shells): Add devshells

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(apps): Update suites of apps

Basically, update which apps to be managed by homebrew (casks) and home-manager.
Additionally, make sure the same apps are not defined and managed by both (like Discord was).

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(cachix): Add further cachix config

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(dev): Added programming language related tooling

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat!: Major upgrade and restructuring

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>

#### Fixes
- Fix(git): remove part of template
- Fix: automatic npm package install, commitizen cli, remove configs, update pre-commit hook
- Fix: automatic npm package install, commitizen cli, remove configs, update pre-commit hook
- Fix(lite-server): update

`deadnix` messed up `./packages/lite-server/node-packages.nix`.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Fix: github workflows

Corrected the name of cache for all workflows which uses cachix cache.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Fix: Dependency issue

Issue appeared after running `flake update`.

`nix config check` displayed a minor issues with 2 `nix` binary installs with same version.
After resolving that, issue still persisted.

Deleting and re-creating the `flake.lock` file via many of the nix flake commands didn't help.
Additionally, restarting the shell, terminal or computer did not help either.

I think one of the issues were the one or multiple flakes in the registry (assigned within
`<root>/modules/shared/nix/default.nix`).

While it didn't clearly help, running the three commands which is used within my `reload`-script
(`<root>/modules/home/user/default.nix`) seems to have resolved the issue.
The script runs the following commands:
  1. 'nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d'
  2. 'nix-store --verify --check-contents --repair'
  3. 'nix-store --optimise -vv'

These three commands can be summed up to be: cleaning, repairing and optimising the nix-store.

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>

#### New
- Feat(dev): add font, fix dev environment and update direnv

A smaller development update.

Added:
- "JetBrains Mono" to fonts
- Added JetBrains IDE's to the dev module (when platform is Linux)
  - Might set IDE's as a "mkEnableOption" in each dev module
  - For macOS; no JetBrains IDE but instead JetBrains Toolbox via Homebrew to manage them
- Since ./packages might use direnv, added "**/.direnv/*" to .gitignore

Fixed/changed:
- ".envrc" used direnv v2.3.0, now updated to v3.0.6
- Rust and C/C++ is now correctly setup for working bindgen support
  - Might need some polishing
- Typo of "editorconfig-checker" corrected

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat: add a SECURITY.md
- Feat: add templates

Added templates for:
- Bug report
- Feature request
- Pull request

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>
- Feat(wsl): add support for WSL

Might change host name, `blitzar`, to something else.

Since the theme of my config is `Space` (originally thought about `Workspace`), the host names are
based on this list of `Cosmic objects` or `Space objects`,
https://www.popularmechanics.com/space/deep-space/g22130573/space-objects-ranked-by-how-cool-they-sound/.

The benefit of the `Space` theme is that the wallpapers can easily be adjusted to be more oriented
towards a certain color.

However the theme and host names may be changed in the future if I find a more fitting concept.
Like from this list of `Mythological places`: https://en.wikipedia.org/wiki/List_of_mythological_places

Signed-off-by: Fredrik Dahlström <fredahl71@gmail.com>


