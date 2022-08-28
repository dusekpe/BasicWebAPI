FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY ["BasicWebAPI.csproj", "./"]
RUN dotnet restore "BasicWebAPI.csproj"
COPY . .
RUN dotnet build "BasicWebAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BasicWebAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BasicWebAPI.dll"]
