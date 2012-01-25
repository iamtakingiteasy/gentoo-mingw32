# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools eutils toolchain-funcs mingw32

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="http://www.zlib.net/"
SRC_URI="
	http://www.gzip.org/zlib/${M32_P}.tar.gz
	http://www.zlib.net/current/beta/${M32_P}.tar.gz
"

LICENSE="ZLIB"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND=""


src_prepare() {
	epatch "${FILESDIR}/${M32_P}-version.patch"
	epatch "${FILESDIR}/${M32_P}-symlinks.patch"


	sed -i 's|\<test "`\([^"]*\) 2>&1`" = ""|\1 2>/dev/null|' configure \
	|| die "sed block failed"


	sed \
		 -e 's|@prefix@|/usr|g' \
		 -e 's|@exec_prefix@|${prefix}|g' \
		 -e 's|@libdir@|${exec_prefix}/lib|g' \
		 -e 's|@sharedlibdir@|${exec_prefix}/lib|g' \
		 -e 's|@includedir@|${exec_prefix}/include|g' \
		 -e "s|@VERSION@|${PV}|g" \
		 -i zlib.pc.in \
	|| die "sed block failed"
}

src_configure() {
	: # do nothing here
}

src_compile() {
	emake -f win32/Makefile.gcc STRIP=true PREFIX=${CHOST}-
}


src_install() {
	emake -f win32/Makefile.gcc install \
		BINARY_PATH="${D}/usr/bin" \
		LIBRARY_PATH="${D}/usr/$(get_libdir)" \
		INCLUDE_PATH="${D}/usr/include" \
		SHARED_MODE=0 \
	|| die
	clean_files
}

