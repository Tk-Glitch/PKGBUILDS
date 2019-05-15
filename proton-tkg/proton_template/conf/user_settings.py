#to enable these settings, name this file "user_settings.py"

#Settings here will take effect for all games run in this Proton version.

user_settings = {
    #Logs are saved to $HOME/steam-<STEAM_GAME_ID>.log, overwriting any previous log with that name.

    #Wine debug logging - default="+timestamp,+pid,+tid,+seh,+debugstr,+loaddll,+mscoree"
#     "WINEDEBUG": "",

    #DXVK debug logging
#     "DXVK_LOG_LEVEL": "info",

    #wine-mono debug logging (Wine's .NET replacement)
     "WINE_MONO_TRACE": "E:System.NotImplementedException",
#     "MONO_LOG_LEVEL": "info",

    #Set DXVK custom config path
#     "DXVK_CONFIG_FILE": "",

    #Enable DXVK Async pipecompiler
#     "PROTON_DXVK_ASYNC": "1",

    #Enable DXVK's HUD
#     "DXVK_HUD": "devinfo,fps",

    #Write the command proton sends to wine for targeted prefix (/prefix/path/launch_command) - Helpful to track bound executable
     "PROTON_LOG_COMMAND_TO_PREFIX": "1",

    #Disable nvapi and nvapi64
     "PROTON_NVAPI_DISABLE": "1",

    #Disable winedbg
     "PROTON_WINEDBG_DISABLE": "1",

    #Enable IMAGE_FILE_LARGE_ADDRESS_AWARE override - Required by some 32-bit games hitting address space issues
#     "PROTON_FORCE_LARGE_ADDRESS_AWARE": "1",

    #Reduce Pulse Latency
     "PROTON_PULSE_LOWLATENCY": "1",

    #Enable Winetricks prompt on game launch
#     "PROTON_WINETRICKS": "1",

    #Use OpenGL-based wined3d for d3d9/d3d10/d3d11 instead of vulkan-based DXVK & D9VK !!! Won't affect winelib builds !!!
#     "PROTON_USE_WINED3D": "1",

    #Use gl-based wined3d for d3d10/11 only (keeping D9VK enabled). Comment out to use vulkan-based DXVK instead.
    #!!! DXVK winelib replaces wined3d d3d10/d3d11 and needs this option enabled !!!
#     "PROTON_USE_WINED3D11": "1",

    #Use gl-based wined3d for d3d9 only (keeping DXVK enabled). Comment out to use vulkan-based D9VK instead.
    #!!! D9VK winelib replaces wined3d d3d9 and needs this option enabled !!!
     "PROTON_USE_WINED3D9": "1",

    #Disable d3d11 entirely !!!
#     "PROTON_NO_D3D11": "1",

    #Disable d3d10 entirely !!!
#     "PROTON_NO_D3D10": "1",

    #Disable d3d9 entirely !!!
#     "PROTON_NO_D3D9": "1",

    #Disable in-process synchronization primitives
#     "PROTON_NO_ESYNC": "1",
}
