# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-tools:${BASE_TAG}

USER ContainerAdministrator

SHELL ["powershell", "-command"]

RUN Invoke-WebRequest "http://www.7-zip.org/a/7z1604-x64.exe" -OutFile "C:\Windows\Temp\7z1604-x64.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\7z1604-x64.exe" -ArgumentList /S -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

ARG MINGW_GET_PACKAGE=mingw-get-0.6.2-mingw32-beta-20131004-1-bin.zip
ADD ${MINGW_GET_PACKAGE} C:\Windows\Temp\${MINGW_GET_PACKAGE}

RUN Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\${MINGW_GET_PACKAGE}", `-oC:\MinGW -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

# We are using forward slashes, because mingw-get is also using them.
RUN C:/MinGW/bin/mingw-get.exe update; `
    C:/MinGW/bin/mingw-get.exe install msys-base gcc g++ mingw32-make libtool mingw32-libz mingw32-zlib;


USER Buildbot
