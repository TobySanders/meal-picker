FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5194

ENV ASPNETCORE_URLS=http://+:5194

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Server/MealPicker/MealPicker.csproj", "Server/MealPicker/"]
RUN dotnet restore "Server/MealPicker/MealPicker.csproj"
COPY . .
WORKDIR "/src/Server/MealPicker"
RUN dotnet build "MealPicker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MealPicker.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MealPicker.dll"]
