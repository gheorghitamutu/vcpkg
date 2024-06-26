set(NCURSES_VERSION_STR 6.2)

vcpkg_download_distfile(
    ARCHIVE_PATH
    URLS
        "https://invisible-mirror.net/archives/ncurses/ncurses-${NCURSES_VERSION_STR}.tar.gz"
        "ftp://ftp.invisible-island.net/ncurses/ncurses-${NCURSES_VERSION_STR}.tar.gz"
        "https://ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION_STR}.tar.gz"
    FILENAME "ncurses-${NCURSES_VERSION_STR}.tgz"
    SHA512 4c1333dcc30e858e8a9525d4b9aefb60000cfc727bc4a1062bace06ffc4639ad9f6e54f6bdda0e3a0e5ea14de995f96b52b3327d9ec633608792c99a1e8d840d
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE "${ARCHIVE_PATH}"
)

set(OPTIONS
    --enable-widec
    # --disable-db-install
    --enable-termcap
    --with-termlib
    --enable-pc-files
    --without-ada
    --without-manpages
   # --without-progs
    --without-tack
    --without-tests
    --with-terminfo-dirs=/usr/share/terminfo:/usr/lib/terminfo:/etc/terminfo
)
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND OPTIONS
        --with-shared
        --with-cxx-shared
        --without-normal
    )
endif()
if(VCPKG_TARGET_IS_MINGW)
    list(APPEND OPTIONS
        --disable-home-terminfo
        --enable-term-driver
        --disable-termcap
    )
endif()

set(OPTIONS_DEBUG
    --with-pkg-config-libdir=${CURRENT_INSTALLED_DIR}/debug/lib/pkgconfig
    --with-debug
    --without-normal
)
set(OPTIONS_RELEASE
    --with-pkg-config-libdir=${CURRENT_INSTALLED_DIR}/lib/pkgconfig
    --without-debug
    --with-normal
)

vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${OPTIONS}
    OPTIONS_DEBUG ${OPTIONS_DEBUG}
    OPTIONS_RELEASE ${OPTIONS_RELEASE}
    NO_ADDITIONAL_PATHS
)
vcpkg_install_make()

vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/bin")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
