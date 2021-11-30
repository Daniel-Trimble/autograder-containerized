Autograder-Containerized requires VcXsrv Windows X Server to correctly spawn sections of the gui.

The easiest way to do so is to use Chocolatey
    Powershell:
        choco install vcxsrv

Otherwise download from SourceForge:
    https://sourceforge.net/projects/vcxsrv/

After installation run Xlaunch from the start menu

In the "Display settings" screen:
    Select the radial button for "Multiple Windows".
    Specify "-1" for "Display number" to allow VcXsrv to automatically determine.
    Click next.

In the "Client startup" screen:
    Select the radial button for "Start no client".
    Click next.

In the "Extra settings" screen:
    Select the checkboxes for the following options:
        "Clipboard"
            "Primary Selection"
        "Native opengl"
        "Disable access control"
    Click next.

In the "Finish configuration" scree:
    Make sure to save the configuration file to one of the following locations:
        "%userprofile%\Desktop"
        "%userprofile%"

Locate your configuration file and execute it.

You will need to run the following command in Powershell:
    set-variable -name DISPLAY -value <Your-IP>:0.0
        Replace <Your-IP> with the results of the previous command or the IP address for your 
        machine. If you aren't certain what your IP address is then run the following command in Powershell:
            (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet).IPAddress

In Powershell navigate to the location of the Dockerfile and run the following command:
    docker run -ti --rm -e DISPLAY=host.docker.internal:0.0 <Name-Of-Docker-Image>
        Replace <Name-Of-Docker-Image> with the docker image name, which should be "autograder".

The docker image should immediately dump you into a root shell.

To validate that everything is working run the following command:
    google-chrome --no-sandbox

This should spawn a window in the host OS welcoming you to Google Chrome you are given a few
options to select, they are not required.
Press the "OK" button to continue.
This should spawn a full Google Chrome browser window and directly connect you to the internet
from inside the container. This can be validated by the window title which should read similar to:
    "Welcome to Chrome - Google Chrome@<Container-ID>"
        Where <Container-ID> is matched to the id present in the bash prompt inside the window the
        container was launched from.
After Google Chrome is closed by way of the red X in the corner, it should be noted that the bash
prompt does not immediately exit the instance of Google Chrome. You may need to input "ctrl+c" to
force close the program.

To ensure validation that everything is working correctly run the following commands as well:
    apt-get update
    apt-get install -y firefox-esr
    firefox
This should spawn a full Mozilla Firefox browser window and directly connect you to the internet
from inside the container. This can be validated by the window title which should read similar to:
    "Welcome to Firefox - Mozilla Firefox@<Container-ID>"
        Where <Container-ID> is matched to the id present in the bash prompt inside the window the
        container was launched from, as well as the previous window for Google Chrome.
It should also be noted that attempting to close multiple tabs results in a warning, additionally
the window on close will automatically close the instance running in the bash prompt without need
to force close.

You may type the following command to close the container:
    exit