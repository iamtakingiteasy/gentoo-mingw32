# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils mingw32

DESCRIPTION="C++ bindings for the Cairo vector graphics library"
HOMEPAGE="http://cairographics.org/cairomm"

SRC_URI="
	http://cairographics.org/releases/${M32_P}.tar.gz
"

LICENSE="LGPL-2.1"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs +svg"

RDEPEND="
	x11-libs/mingw32-cairo[svg?]
	dev-libs/mingw32-libsigc++:2
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' Makefile.in || die "sed failed"
	sed -i 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' Makefile.in || die "sed failed"
}

src_configure() {
	econf \
		$(use_static) \
		--disable-tests \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files	
}
