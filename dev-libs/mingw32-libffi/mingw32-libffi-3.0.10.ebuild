# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit libtool toolchain-funcs mingw32

DESCRIPTION="a portable, high level programming interface to various calling conventions"
HOMEPAGE="http://sourceware.org/libffi/"
SRC_URI="ftp://sourceware.org/pub/${M32_PN}/${M32_P}.tar.gz"

LICENSE="MIT"
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

