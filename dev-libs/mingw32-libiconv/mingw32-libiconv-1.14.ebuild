# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils flag-o-matic libtool toolchain-funcs mingw32

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="http://www.gnu.org/software/libiconv/"
SRC_URI="mirror://gnu/libiconv/${M32_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND=""


src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-nls \
		--disable-shared \
	|| die "econf failed"

}

src_compile() {
	emake DESTDIR="${D}" install \
	|| die "emake failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	clean_files
}

