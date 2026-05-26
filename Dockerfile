# --- Giai đoạn 1: Dùng SDK để Build code ---
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy các file project (.csproj) và restore các gói nuget
COPY MyApiApp/*.csproj ./MyApiApp/
RUN dotnet restore ./MyApiApp/MyApiApp.csproj

# Copy toàn bộ code còn lại vào và build
COPY . ./
RUN dotnet publish ./MyApiApp/MyApiApp.csproj -c Release -o /app/publish

# --- Giai đoạn 2: Tạo sản phẩm chạy siêu nhẹ ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/publish .

# Lưu ý: Docker mặc định chạy port 8080 hoặc cấu hình qua biến môi trường
ENV ASPNETCORE_URLS=http://+:5000

ENTRYPOINT ["dotnet", "MyApiApp.dll"]