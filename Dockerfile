# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-tools:${BASE_TAG}

SHELL ["powershell", "-command"]

ARG MINGW_GET_PACKAGE=mingw-get-0.6.2-mingw32-beta-20131004-1-bin.zip
ADD ${MINGW_GET_PACKAGE} C:\Windows\Temp\${MINGW_GET_PACKAGE}

RUN Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\${MINGW_GET_PACKAGE}", `-oC:\MinGW -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

# We are using forward slashes, because mingw-get is also using them.
RUN C:/MinGW/bin/mingw-get.exe update; `
    C:/MinGW/bin/mingw-get.exe install msys-base msys-zip gcc g++ libtool; `
    C:/MinGW/bin/mingw-get.exe install mingw32-make mingw32-libz mingw32-zlib;

ADD bcrypt/ C:/MinGW/
