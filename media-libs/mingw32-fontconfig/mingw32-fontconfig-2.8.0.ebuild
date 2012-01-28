# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool toolchain-funcs mingw32


DESCRIPTION="A library for configuring and customizing font access"
HOMEPAGE="http://fontconfig.org/"

SRC_URI="
	http://fontconfig.org/release/${M32_P}.tar.gz
"

LICENSE="MIT"

SLOT="1.0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
	media-libs/mingw32-freetype
	dev-libs/mingw32-expat
	app-arch/mingw32-bzip2
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-orig-2.8.0-latin-reorder.patch"	# 130466
	epatch "${FILESDIR}/${M32_PN}-orig-2.8.0-docbook.patch"		# 310157
	epatch "${FILESDIR}/${M32_PN}-orig-2.8.0-urw-aliases.patch"	# 303591
	sed -e 's/dll.a/a/' -i src/Makefile.am || die
	sed \
		-e '/^Version:/aRequires: freetype2' \
		-e '/^Libs:/{s/$/ -lexpat/}' \
		-i \
			fontconfig.pc.in \
	|| die
	eautoreconf
	elibtoolize
}

src_configure() {
	replace-flags -mtune=* -DMTUNE_CENSORED
	replace-flags -march=* -DMARCH_CENSORED

	econf \
		$(use_static) \
		--with-arch=${ARCH} \
	|| die
}

src_compile() {
	emake \
		CFLAGS= \
	|| die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	
	clean_files
}
