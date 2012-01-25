# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: eclass wtih mingw32 environment building routines $

M32_PN=${PN#mingw32-}
M32_P=${M32_PN}-${PV}

S="${WORKDIR}/${M32_P}"

mingw32_clean_files() {
	einfo "Performing cleaning procedures..."
	find "${D}" \( -name '*.la' -or -name '*.def' \) -print0 -delete | while IFS= read -rd '' line; do
		einfo "Cleaning .${line##*.} file ${line/${D}/image/}"
	done
	einfo "Cleaning is over"

}

EXPORT_FUNCTIONS clean_files
