set(THEME_FILE index.theme)
install(FILES ${THEME_FILE}
        DESTINATION ${UBUNTU_MOBILE_THEME_DIR}
        PERMISSIONS OWNER_READ OWNER_WRITE
                    GROUP_READ
                    WORLD_READ
)

add_subdirectory(status)
add_subdirectory(app)
