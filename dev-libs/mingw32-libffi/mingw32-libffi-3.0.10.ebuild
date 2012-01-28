# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils libtool mingw32

DESCRIPTION="a portable, high level programming interface to various calling conventions."
HOMEPAGE="http://sourceware.org/libffi/"

SRC_URI="
	ftp://sourceware.org/pub/${M32_PN}/${M32_P/_}.tar.gz
"

LICENSE="MIT"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
"
DEPEND="
"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		$(use_static) \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files	
}
