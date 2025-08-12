FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["Iacs.Api/Iacs.Api.csproj", "Iacs.Api/"]

RUN dotnet restore "Iacs.Api/Iacs.Api.csproj"

COPY . .

RUN dotnet build "Iacs.Api/Iacs.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "Iacs.Api/Iacs.Api.csproj" -c Release -o /app/publish --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://0.0.0.0:8080

ENTRYPOINT ["dotnet", "Iacs.Api.dll"]
