file(GLOB ICON_NAMES_SVG *.svg)

install(FILES ${ICON_NAMES_SVG}
        DESTINATION ${UBUNTU_MOBILE_THEME_DIR}/status/scalable)
