FROM mcr.microsoft.com/windows/servercore:latest as core
FROM mcr.microsoft.com/powershell:latest
COPY --from=core /windows/system32/netapi32.dll /windows/system32/netapi32.dll

ARG BEAT_VERSION=8.5.3
ARG ARCH=x86_64

RUN pwsh.exe -Command \
    $ErrorActionPreference = 'Stop' ; \
    Invoke-WebRequest -Method Get -Uri https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-$env:BEAT_VERSION-windows-$env:ARCH.zip -OutFile "C:\Program` Files\winlogbeat-$env:BEAT_VERSION-windows-$env:ARCH.zip" ; \
    Expand-Archive -Path "C:\Program` Files\winlogbeat-$env:BEAT_VERSION-windows-$env:ARCH.zip" -DestinationPath 'C:\Program Files' ; \
    Remove-Item "C:\Program` Files\winlogbeat-$env:BEAT_VERSION-windows-$env:ARCH.zip" -Force

COPY ["entrypoint.ps1", "C:/Program Files/winlogbeat-${BEAT_VERSION}-windows-${ARCH}"]

WORKDIR "C:\Program Files\winlogbeat-${BEAT_VERSION}-windows-${ARCH}"

CMD ["pwsh.exe", "entrypoint.ps1"]
