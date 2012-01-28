# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils libtool mingw32


DESCRIPTION="A high-quality and portable font engine"
HOMEPAGE="http://www.freetype.org/"

SRC_URI="
	mirror://sourceforge/freetype/${M32_P/_/}.tar.bz2
"

LICENSE="FTL GPL-2"

SLOT="2"

KEYWORDS="x86 amd64"

IUSE="+static-libs +auto-hinter +bindist"

RDEPEND="
	sys-libs/mingw32-zlib
"
DEPEND="
"

src_prepare() {
	enable_option() {
		sed -i -e "/#define $1/a #define $1" \
			include/freetype/config/ftoption.h \
		|| die "unable to enable option $1"
	}

	disable_option() {
		sed -i -e "/#define $1/ { s:^:/*:; s:$:*/: }" \
			include/freetype/config/ftoption.h \
		|| die "unable to disable option $1"
	}

	sed -e '/^Libs:/s/$/ -lz/' -i builds/unix/freetype2.in

	if ! use bindist; then
		enable_option FT_CONFIG_OPTION_SUBPIXEL_RENDERING
	fi

	if use auto-hinter; then
		disable_option TT_CONFIG_OPTION_BYTECODE_INTERPRETER
		enable_option TT_CONFIG_OPTION_UNPATENTED_HINTING
	fi
	
	disable_option FT_CONFIG_OPTION_OLD_INTERNALS

	epatch "${FILESDIR}/${M32_PN}-orig-2.4.8-enable-valid.patch"
	elibtoolize
}

src_configure() {
	append-flags -fno-strict-aliasing
	econf \
		$(use_static) \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	
	clean_files
}
