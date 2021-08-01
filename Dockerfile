#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app
ENV TZ=Asia/Shanghai

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["Cloud189Checkin/Cloud189Checkin.csproj", "Cloud189Checkin/"]
RUN dotnet restore "Cloud189Checkin/Cloud189Checkin.csproj"
COPY . .
WORKDIR "/src/Cloud189Checkin"
RUN dotnet build "Cloud189Checkin.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Cloud189Checkin.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Cloud189Checkin.dll"]