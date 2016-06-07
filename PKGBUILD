# Maintainer: Nicola Squartini <tensor5@gmail.com>
# Module Versions
_about_arch_url="https://github.com/fusion809/about"
_about_arch_ver=1.5.17
_dark_bint_syntax_ver=0.8.6
_fusion_ui_ver=0.10.5
_language_archlinux_ver=0.2.1
_language_gfm2_ver=0.90.3
_language_ini_desktop_ver=1.18.0
_language_liquid_ver=0.5.1
_language_patch2_url="fusion809/language-patch2"
_language_patch2_ver=0.1.3
_language_unix_shell_ver=0.28.1

pkgname=atom
pkgver=1.8.0
pkgrel=1
pkgdesc='A hackable text editor for the 21st Century'
arch=('i686' 'x86_64')
url='https://github.com/atom/atom'
license=('MIT' 'custom')
depends=('electron'
         'nodejs-atom-package-manager')
makedepends=('git' 'npm')
conflicts=('atom-editor' 'atom-editor-bin')
source=("https://github.com/atom/atom/archive/v${pkgver}.tar.gz"
        'beforeunload.patch'
        'deprecated-api.patch'
        'fix-atom-sh.patch'
        'fix-license-path.patch'
        'run-as-node.patch'
        'use-system-apm.patch'
        'use-system-electron.patch')
sha256sums=('2950820b2c7ab658135e9cb7c003ff2074ec0a38ac3b324d85cc20bcb237e61f'
            'e92e23bbf839bec6611b2ac76c1f5bba35b476983b0faa9b310288e2956247a2'
            '6fca91b3e80248a96fc4b6b0228602d4dd68ef851cb059a97a7379e72e53b432'
            'ac409d709fd1090fda93b6e575cf46f866d1f9f914a48ea94eb01af3d5c02b9e'
            '061493b9e53722e194d688a7db9e26d7fbb9a1e2cb86284aae4d7dc61e425400'
            'e0872fab5f7b6b108dfef3e8879c08be417955082571a10152d03ccce296d2f7'
            '19ba93a502ff0c9db6e197f09eda9881999e4d80c264bc40d60f96e9423dd1a9'
            '064c7b70db071cd639355677fe1132875c8f82b32439c2a369159376bf98dbaf')

prepare() {
  cd "${srcdir}/${pkgname}-${pkgver}"

  patch -Np1 -i "${srcdir}"/fix-atom-sh.patch
  patch -Np1 -i "${srcdir}"/use-system-electron.patch
  patch -Np1 -i "${srcdir}"/use-system-apm.patch
  patch -Np1 -i "${srcdir}"/fix-license-path.patch

  # apm with system (updated) nodejs cannot 'require' modules inside asar
  sed -e "s/, 'generate-asar'//" -i build/Gruntfile.coffee

  # Fix for Electron 1.0.0
  patch -Np1 -i "${srcdir}"/deprecated-api.patch
  sed -e 's/"settings-view": "0.235.1"/"settings-view": "0.236.0"/' \
      -i package.json

  # Fix for Electron 1.2.0
  patch -Np1 -i "${srcdir}"/beforeunload.patch
  patch -Np1 -i "${srcdir}"/run-as-node.patch

  sed -i -e "/exception-reporting/d" \
       -e "/metrics/d" \
       -e "s/\"tree-view\": \"0.205.0\",/\"tree-view\": \"0.208.0\",/g" \
       -e "s/\"language-gfm\": \".*\",/\"language-gfm2\": \"${_language_gfm2_ver}\",\n    \"language-ini-desktop\": \"${_language_ini_desktop_ver}\",\n    \"language-liquid\": \"${_language_liquid_ver}\",\n    \"language-patch2\": \"${_language_patch2_ver}\",/g" \
       -e "/\"dependencies\": {/a \
                   \"language-patch2\": \"${_language_patch2_url}\"," \
       -e "s/\"language-shellscript\": \".*\",/\"language-unix-shell\": \"${_language_unix_shell_ver}\",\n    \"language-archlinux\": \"${_language_archlinux_ver}\",/g" \
       -e "s/\"about\": \".*\"/\"about-arch\": \"${_about_arch_ver}\"/g" \
       -e "/\"packageDependencies\": {/a \
            \"dark-bint-syntax\": \"${_dark_bint_syntax_ver}\",\n    \"fusion-ui\": \"${_fusion_ui_ver}\"," package.json
}

build() {
  cd "${srcdir}/${pkgname}-${pkgver}"

  export ATOM_RESOURCE_PATH="$srcdir/atom-$pkgver"
  # If unset, ~/.atom/.node-gyp/.atom/.npm is used
  export NPM_CONFIG_CACHE="${HOME}/.atom/.npm"

  # Make sure NodeGit builds from source and with the correct runtime
  export BUILD_ONLY=1
  ELECTRON_VERSION=$(</usr/lib/electron/version)
  export ELECTRON_VERSION=${ELECTRON_VERSION#v}

  apm clean
  apm install

  echo 'Removing NodeGit devDependencies...'
  cd node_modules/nodegit
  npm prune --production
  cd ../..

  _packagesToDedupe=('abbrev'
                     'amdefine'
                     'atom-space-pen-views'
                     'cheerio'
                     'domelementtype'
                     'fs-plus'
                     'grim'
                     'highlights'
                     'humanize-plus'
                     'iconv-lite'
                     'inherits'
                     'loophole'
                     'oniguruma'
                     'q'
                     'request'
                     'rimraf'
                     'roaster'
                     'season'
                     'sigmund'
                     'semver'
                     'through'
                     'temp')
  apm dedupe ${_packagesToDedupe[@]}
  cd build
  npm install
  cd ..
  script/grunt --channel=stable
}

package() {
  cd "${srcdir}/${pkgname}-${pkgver}"

  install -d -m 755 "${pkgdir}"/usr/lib
  cp -r out/Atom/resources/app "${pkgdir}"/usr/lib
  mv "${pkgdir}"/usr/lib/app "${pkgdir}"/usr/lib/atom

  install -d -m 755 "${pkgdir}/usr/share/applications"
  sed -e "s|<%= appName %>|Atom|" \
      -e "s/<%= description %>/${pkgdesc}/" \
      -e "s|<%= installDir %>/share/<%= appFileName %>/atom|/usr/lib/electron/electron --app=/usr/lib/atom|" \
      -e "s|<%= iconPath %>|/usr/lib/atom/resources/atom.png|" \
      resources/linux/atom.desktop.in > "${pkgdir}/usr/share/applications/atom.desktop"

  install -D -m 755 out/Atom/resources/new-app/atom.sh "${pkgdir}/usr/bin/atom"

  install -D -m 755 out/Atom/resources/LICENSE.md \
          "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE.md"

  # Remove useless stuff
  find "${pkgdir}"/usr/lib/atom/node_modules \
      -name "*.a" -exec rm '{}' \; \
      -or -name "*.bat" -exec rm '{}' \; \
      -or -name "benchmark" -prune -exec rm -r '{}' \; \
      -or -name "doc" -prune -exec rm -r '{}' \; \
      -or -name "html" -prune -exec rm -r '{}' \; \
      -or -name "man" -prune -exec rm -r '{}' \; \
      -or -path "*/less/gradle" -prune -exec rm -r '{}' \; \
      -or -path "*/task-lists/src" -prune -exec rm -r '{}' \;
}
