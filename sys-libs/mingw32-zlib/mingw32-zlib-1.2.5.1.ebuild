# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils mingw32

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="http://www.zlib.net/"

SRC_URI="
	http://www.gzip.org/zlib/${M32_P}.tar.gz
	http://www.zlib.net/current/beta/${M32_P}.tar.gz
"

LICENSE="ZLIB"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
"
DEPEND="
"

src_prepare() {
	# moves
	# patches
	epatch "${FILESDIR}/${M32_PN}-orig-1.2.5.1-version.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-1.2.5.1-symlinks.patch"
	# sedes 
	sed -i 's|\<test "`\([^"]*\) 2>&1`" = ""|\1 2>/dev/null|' configure \
	|| die
	sed \
		-e 's|@prefix@|/usr|g' \
		-e 's|@exec_prefix@|${prefix}|g' \
		-e 's|@libdir@|${exec_prefix}/lib|g' \
		-e 's|@sharedlibdir@|${exec_prefix}/lib|g' \
		-e 's|@includedir@|${exec_prefix}/include|g' \
		-e "s|@VERSION@|${PV}|g" \
		-i \
			zlib.pc.in \
	|| die
}

src_compile() {
	emake -f win32/Makefile.gcc STRIP=true PREFIX=${CHOST}- || die
}

src_configure() {
	: # do nothing here
}

src_install() {
	local shared_mode=0
	if ! use static-libs; then
		shared_mode=1
	fi
	emake -f win32/Makefile.gcc install \
		BINARY_PATH="${D}/usr/$(get_libdir)" \
		LIBRARY_PATH="${D}/usr/$(get_libdir)" \
		INCLUDE_PATH="${D}/usr/include" \
		SHARED_MODE=${shared_mode} \
	|| die
	if ! use static-libs; then 
		rm -f "${D}"/usr/$(get_libdir)/*.a
	fi
	clean_files	
}
