FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["IACS.Api.csproj", "IACS.Api.csproj"]

RUN dotnet restore "IACS.Api.csproj"

COPY . .

RUN dotnet build "IACS.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "IACS.Api.csproj" -c Release -o /app/publish --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://0.0.0.0:8080

ENTRYPOINT ["dotnet", "IACS.Api.dll"]
