# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C Library in Rust for Redox and Linux"
HOMEPAGE="https://www.redox-os.org/ https://github.com/redox-os/relibc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""
inherit git-r3 multilib usr-ldscript #cargo

DEPEND="dev-lang/rust[nightly]"
RDEPEND="${DEPEND}"
BDEPEND=""
EGIT_REPO_URI="https://gitlab.redox-os.org/redox-os/relibc.git"
PATCHES=(
	"${FILESDIR}/0001-Add-install-target-for-gentoo.patch"
	"${FILESDIR}/0002-Add-SONAME-for-libc.so.patch"
)
#dependencies
# cbindgen
# openlibm
# the remaining may be downloaded

src_unpack() {
	git-r3_src_unpack || die
	cd "${S}"
	cargo check --all || die
	cd cbindgen
	cargo check
}

src_compile() {
	emake libs VERBOSE=1 || die
}

src_install() {
	emake gentoo-install LIB=$(get_libdir) TMP=${D}
	gen_usr_ldscript -a c
}
