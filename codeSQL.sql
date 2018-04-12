CREATE DATABASE QuanLyWebsiteDatKhachSan
USE QuanLyWebsiteDatKhachSan

CREATE TABLE KhachHang
(
	maKH nchar(10),
	hoTen nchar(50),
	tenDangNhap nchar(50),
	matKhau nchar(50),
	soCMND int,
	diaChi nchar(100),
	soDienThoai int,
	moTa nchar(200),
	email char(60),
	PRIMARY KEY (maKH)
)

CREATE TABLE KhachSan
(
	maKS nchar(10),
	tenKS nchar(50),
	soSao int,
	soNha int,
	duong nchar(50),
	quan nchar(20),
	thanhPho nchar(20),
	giaTB float,
	moTa nchar(200),
	primary key (maKS)
)

CREATE TABLE LoaiPhong
(
	maLoaiPhong nchar(10),
	tenloaiPhong nchar(15),
	maKS nchar(10),
	donGia float,
	moTa nchar(200),
	slTrong int,
	primary key (maLoaiPhong)
)

CREATE TABLE Phong
(
	maPhong nchar(10),
	loaiPhong nchar(10),
	soPhong int,
	primary key (maPhong)
)

CREATE TABLE TrangThaiPhong
(
	maPhong nchar(10),
	ngay datetime,
	tinhTrang nchar(20),
	primary key (maPhong, ngay)
)

ALTER TABLE TrangThaiPhong
ADD CONSTRAINT C_tinhTrang
CHECK (tinhTrang IN ('Using','Maintenance','Available'))

CREATE TABLE DatPhong
(
	maDP nchar(10),
	maLoaiPhong nchar(10),
	maKH nchar(10),
	ngayBatDau datetime,
	ngayTraPhong datetime,
	ngayDat datetime,
	donGia float,
	moTa nchar(200),
	tinhTrang nchar(20),
	primary key (maDP)
)

ALTER TABLE DatPhong
ADD CONSTRAINT C_tinhTrangDP
CHECK (tinhTrang IN ('Confirmed','Unknown'))

CREATE TABLE HoaDon
(
	maHD nchar(10),
	ngayThanhToan datetime,
	tongTien float,
	maDP nchar(10),
	primary key (maHD)
)

ALTER TABLE LoaiPhong
ADD CONSTRAINT FK_LoaiPhong_KhachSan
FOREIGN KEY (maKS)
REFERENCES KhachSan(maKS)

ALTER TABLE Phong
ADD CONSTRAINT FK_Phong_LoaiPhong
FOREIGN KEY (loaiPhong)
REFERENCES LoaiPhong(maLoaiPhong)

ALTER TABLE TrangThaiPhong
ADD CONSTRAINT FK_TrangThaiPhong_Phong
FOREIGN KEY (maPhong)
REFERENCES Phong(maPhong)

ALTER TABLE DatPhong
ADD CONSTRAINT FK_DatPhong_LoaiPhong
FOREIGN KEY (maLoaiPhong)
REFERENCES LoaiPhong(maLoaiPhong)

ALTER TABLE DatPhong
ADD CONSTRAINT FK_DatPhong_KhachHang
FOREIGN KEY (maKH)
REFERENCES KhachHang(maKH)

ALTER TABLE HoaDon
ADD CONSTRAINT FK_HoaDon_DatPhong
FOREIGN KEY (maDP)
REFERENCES DatPhong(maDP)

ALTER TABLE dbo.KhachHang
ADD CONSTRAINT U_TenDangNhap
UNIQUE (tenDangNhap)

go
CREATE TRIGGER T_email ON DATABASE
FOR [insert, update]
AS
BEGIN
	IF (EXISTS (SELECT * FROM KhachHang WHERE email like '%@gmail.com' OR email LIKE '%@yahoo.com' OR email LIKE '%@rocketmail.com' ))
end

SELECT HOST_NAME() AS HostName, SUSER_NAME() LoggedInUser
--kiểm tra host name
SELECT
            SERVERPROPERTY('MachineName') AS [ServerName], 
			SERVERPROPERTY('ServerName') AS [ServerInstanceName], 
            SERVERPROPERTY('InstanceName') AS [Instance], 
            SERVERPROPERTY('Edition') AS [Edition],
            SERVERPROPERTY('ProductVersion') AS [ProductVersion], 
			Left(@@Version, Charindex('-', @@version) - 2) As VersionName
--kiểm tra port
USE master
GO
xp_readerrorlog 0, 1, N'Server is listening on' 
GO


--kiểm tra mật khẩu, tên đăng nhập
GO
CREATE PROCEDURE check_id_pw @id NCHAR(50), @pw NCHAR(50), @status int OUTPUT, @hoten NCHAR(50) OUTPUT
AS
BEGIN
	IF EXISTS (SELECT *	FROM dbo.KhachHang WHERE RTRIM(tenDangNhap) = @id AND RTRIM(matKhau) = @pw)
	begin
		SET @status = 1
		SELECT @hoten = hoTen FROM dbo.KhachHang WHERE RTRIM(tenDangNhap) = @id
		PRINT @hoten
	end
		ELSE
        SET @status = 0
	PRINT @status
END

DROP PROCEDURE dbo.check_id_pw

EXECUTE dbo.check_id_pw @id = N'toanlatrum28', -- nchar(50)
    @pw = N'toandaica', -- nchar(50)
    @status = 0, -- int
	@hoten = N''


--Thêm 1 hàng vào bảng KhachHang
GO
CREATE PROCEDURE insert_Customer @hoten NCHAR(50), @id NCHAR(50), @pw NCHAR(50), @cmnd INT, @address NCHAR(50), @phone INT, @mota NCHAR(200), @email NCHAR(60), @status int OUTPUT
AS	
BEGIN
	IF EXISTS(SELECT * FROM dbo.KhachHang WHERE soCMND = @cmnd or tenDangNhap = @id OR email = @email)
	BEGIN
		SET @status = 0
		PRINT 'duplicate Customer'
		END	
	ELSE 
		BEGIN
			DECLARE @makh NCHAR(15)
			SET @makh = 'KH' + CONVERT(NCHAR(10),@cmnd)
			INSERT INTO dbo.KhachHang
			VALUES  ( @makh , -- maKH - nchar(10)
			          @hoten , -- hoTen - nchar(50)
			          @id , -- tenDangNhap - nchar(50)
			          @pw , -- matKhau - nchar(50)
			          @cmnd , -- soCMND - int
			          @address , -- diaChi - nchar(100)
			          @phone , -- soDienThoai - int
			          @mota , -- moTa - nchar(200)
			          @email  -- email - char(60)
			        )
			SET @status = 1
		END	
END

GO
EXECUTE dbo.insert_Customer @hoten = N'Mòe iu', -- nchar(50)
    @id = N'leluuthuycuc2704', -- nchar(50)
    @pw = N'leanxinhdep', -- nchar(50)
    @cmnd = 23654125, -- int
    @address = N'KTX khu B', -- nchar(50)
    @phone = 1664142969, -- int
    @mota = N'khó tính khủng khiếp', -- nchar(200)
    @email = N'thuycuc2704@gmail.com', -- nchar(60)
    @status = N'' -- nchar(10)



	GO	
DROP PROCEDURE dbo.check_id_pw
-- 4. viết procedure tìm kiếm khách sạn, biến đầu vào là tiêu chí tìm kiếm(số Sao, địa chỉ, giá TB,...)
-- note: có thể 1 trong 3 biến giá trị null trả về danh sách

-- 5. procedure đặt phòng, biến đầu vào: mã khách sạn, mã phòng
--kiểm tra phòng,ks có hợp lệ, trả biến đầu ra giá trị 1 hoặc 0
go
CREATE PROCEDURE spBookRoom @makhachsan nchar(10), @maphong nchar(10)
AS
BEGIN
	-- mã đặt phòng
	DECLARE @madatphong nchar(10)
	-- số lượng mã đặt phòng hiện có
	DECLARE @tongmadatphong int
	-- kiểm tra mã khách sạn hợp lệ (có trong danh sách)
	IF( EXISTS (SELECT * FROM KhachSan WHERE maKS= @makhachsan))
		BEGIN
			-- Kiểm tra ma phòng hợp lệ
			IF( EXISTS (SELECT* FROM Phong WHERE maPhong = @maphong))
				BEGIN
					-- Kiểm tra tình trạng phòng. Điều kiện là còn trống
					IF( EXISTS( SELECT* FROM TrangThaiPhong WHERE maPhong = @maphong AND tinhTrang='Còn trống'))
						BEGIN
							print N'Phòng đang rảnh, có thể đặt'
							-- tìm tổng số mã đặt phòng đã có
							SET @tongmadatphong = (SELECT COUNT(*) FROM DatPhong)
							-- trường hợp trước đó đã có người đặt phòng, mã đặt phòng khác 0
							IF( EXISTS (SELECT* FROM DATPHONG WHERE MADP <> 0))
							-- Gán giá trị cho mã đặt phòng bằng cách lấy giá trị lớn nhất của mã đặt phòng trong bảng ĐẶT PHÒNG cộng thêm 1
								SET @tongmadatphong = @tongmadatphong + 1
							ELSE -- Trường hợp chưa có ai đặt phòng, mã đạt phòng bằng 0
								SET @tongmadatphong = 1 -- Giá trị của mã đặt phòng là 1, tức người đầu tiên đặt phòng
							-- Chuyển mã đặt phòng từ số sang chuỗi
							SET @tongmadatphong = CONVERT(nchar(10), @tongmadatphong)
							-- Đẩy các giá trị vào bảng đặt phòng
							INSERT INTO DATPHONG values (@madatphong, @maphong, NULL, NULL, NULL, NULL, NULL, NULL, 'Đang sử dụng')
							-- Cập nhật tình trạng phòng thành bận
							UPDATE TrangThaiPhong 
							SET tinhTrang = N'Đang sử dụng'
							WHERE MAPHONG=@maphong
							-- giá trị trả về
							RETURN 1
						END
					ELSE -- trường hợp phòng không trống để thuê
						BEGIN
							print N'Phòng này đã được đặt'
							RETURN 0
						END
				END
			ELSE -- mã phòng không hợp lệ
				BEGIN
					print N'Mã phòng không hợp lệ'
					RETURN 0
				END
		END
	ELSE -- mã khách sạn không hợp lệ
		BEGIN
			print N'Mã khách sạn không hợp lệ'
			RETURN 0
		END
END


--6.procedure tạo hóa đơn, biến đầu vào ngayThanhToan, maDP
--tự lập maHD sao cho k trùng maHD cũ(có thể là số hóa đơn cao nhất + 1 đơn vị)
--tự tính thành tiền từ maDP
--biến đầu ra là toàn bộ thông tin hóa đơn vừa lập

CREATE PROCEDURE spMakeBill @madatphong nchar(10), @ngaythanhtoan datetime
AS
BEGIN
	DECLARE @mahoadon nchar(10) -- mã hóa đơn để lập hóa đơn
	DECLARE @sohoadon int -- tổng số hóa đơn đã có
	SET @sohoadon = (SELECT COUNT(*) FROM HoaDon) -- tính số hóa đơn đã có
	If(@sohoadon <> 0) -- Trường hợp đã có hóa đơn được lập
		SET @sohoadon = @sohoadon + 1
	ELSE -- trường hợp chua có hóa đơn được lập
		SET @sohoadon = 1
	DECLARE @songaythue int -- biến tính số ngày thuê
	DECLARE @ngaybatdau datetime -- biến ngày bắt đầu thuê
	SET @ngaybatdau = (SELECT ngayDatDau FROM DatPhong WHERE @madatphong = maDP) -- gán giá trị cho biến ngày bắt đầu thuê
	DECLARE @ngaytraphong datetime -- biến ngày trả phòng
	SET @ngaytraphong = (SELECT ngayTraPhong FROM DatPhong WHERE @madatphong = maDP) -- gán giá trị cho biến ngày trả phòng
	SET @songaythue = datediff(d, @ngaybatdau, @ngaytraphong) -- tính số ngày thuê bằng cách lấy ngày trả trừ ngày thuê
	DECLARE @giathue1ngay float -- biến giá thuê 1 ngày
	SET @giathue1ngay = (SELECT donGia FROM DatPhong WHERE maDP = @madatphong) -- gán giá trị
	DECLARE @tongtien float -- biến tổng tiền 
	SET @tongtien = (1.0)*@giathue1ngay*@songaythue -- tính tổng tiền
	SET @mahoadon = CONVERT(nchar(10), @sohoadon) -- chuyển mã hóa đơn từ số sang chuỗi
	INSERT INTO HoaDOn values (@mahoadon, @ngaythanhtoan, @tongtien, @madatphong) -- nhập thông tin vào bảng hóa đơn
	RETURN (SELECT* FROM HoaDon WHERE maHD = @mahoadon) -- xuất hóa đơn
END

-- 7.procedure tìm kiếm thông tin hóa đơn biến đầu vào makh,ngày lập, thành tiền trả về danh sách

CREATE PROCEDURE spSearchBill @makh nchar(10), @ngaylap datetime, @tongtien float
AS
BEGIN
	DECLARE @madatphong nchar(10)
	DECLARE @mahoadon nchar(10)
	SET @madatphong = (SELECT maDP FROM DatPhong WHERE maKH = @makh)
	SET @mahoadon = (SELECT maHD FROM HoaDon WHERE maDP = @madatphong AND ngayThanhToan = @ngaylap AND tongTien = @tongtien)
	IF( @mahoadon <> NULL)
		RETURN (SELECT* FROM HoaDon WHERE maHD = @mahoadon)
	ELSE
		BEGIN
			print N'Không có hóa đơn nào'
			RETURN 0
		END
END 

SELECT tenKS
FROM dbo.KhachSan
WHERE giaTB <= 500000

EXECUTE dbo.spBookRoom @makhachsan = N'KS1', -- nchar(10)
    @maphong = N'' -- nchar(10)

GO
CREATE PROCEDURE GetPrice @maks NCHAR(10), @tenloaiphong NCHAR(50), @dongia INT OUTPUT, @sltrong INT OUTPUT
AS
BEGIN
	SELECT @dongia = DonGia, @sltrong = slTrong FROM dbo.LoaiPhong WHERE maKS = @maks AND	tenloaiPhong = @tenloaiphong
END

EXECUTE dbo.GetPrice @maks = N'KS1', -- nchar(10)
    @tenloaiphong = N'thường máy lạnh', -- nchar(50)
    @dongia = 0, -- int
    @sltrong = 0 -- int


CREATE PROCEDURE spBookRoom @makhachsan nchar(10), @maloaiphong nchar(10), @tendangnhap nchar(50), @ngaythue NCHAR(10), @songaythue int,  @status int OUTPUT
AS
BEGIN
	-- mã đặt phòng
	DECLARE @madatphong nchar(10)
	-- số lượng mã đặt phòng hiện có
	DECLARE @tongmadatphong int
	-- kiểm tra mã khách sạn hợp lệ (có trong danh sách)
	IF( EXISTS (SELECT * FROM KhachSan WHERE maKS= @makhachsan))
		BEGIN
			-- Kiểm tra ma phòng hợp lệ
			IF( EXISTS (SELECT* FROM LoaiPhong WHERE maLoaiPhong = @maloaiphong AND maKS = @makhachsan))
				BEGIN
					-- Kiểm tra tình trạng phòng. Điều kiện là còn trống
					IF(NOT EXISTS(SELECT* FROM TrangThaiPhong T WHERE ngay=@ngaythue AND maPhong IN (SELECT maPhong FROM Phong P WHERE P.maPhong = T.maPhong AND P.loaiPhong = @maloaiphong)))
						BEGIN
							print N'Phòng đang rảnh, có thể đặt'
							-- tìm tổng số mã đặt phòng đã có
							SET @tongmadatphong = (SELECT COUNT(*) FROM DatPhong)
							-- trường hợp trước đó đã có người đặt phòng, mã đặt phòng khác 0
							IF( @tongmadatphong <>0)
							-- Gán giá trị cho mã đặt phòng bằng cách lấy giá trị lớn nhất của mã đặt phòng trong bảng ĐẶT PHÒNG cộng thêm 1
								SET @tongmadatphong = @tongmadatphong + 1
							ELSE -- Trường hợp chưa có ai đặt phòng, mã đạt phòng bằng 0
								SET @tongmadatphong = 1 -- Giá trị của mã đặt phòng là 1, tức người đầu tiên đặt phòng
							-- Chuyển mã đặt phòng từ số sang chuỗi
							SET @madatphong = CONVERT(nchar(10), @tongmadatphong)
							DECLARE @ngaylap datetime
							SET @ngaylap = GETDATE()
							DECLARE @maKH nchar(10)
							SET @maKH = (SELECT maKH FROM KhachHang WHERE tenDangNhap = @tendangnhap)
							-- Đơn giá
							DECLARE @dongia float
							SET @dongia = (SELECT donGia From LoaiPhong WHERE maKS = @makhachsan AND maLoaiPhong = @maloaiphong)
							-- Đẩy các giá trị vào bảng đặt phòng
							INSERT INTO DATPHONG values (@madatphong, @maloaiphong, @maKH, @ngaythue, DATEADD(day,@songaythue, @ngaythue), @ngaylap, @dongia, NULL, 'Confirmed')
							-- Cập nhật tình trạng phòng thành bận
							DECLARE @maphongduocthue nchar(10)
							 SET @maphongduocthue = (SELECT Top 1 maPhong FROM Phong WHERE loaiPhong = @maloaiphong AND maPhong NOT IN (SELECT maPhong FROM TrangThaiPhong))
							INSERT INTO TrangThaiPhong VALUES (@maphongduocthue, @ngaythue, N'Using')
							DECLARE @flag int
							SET @flag = 1
							WHILE(@flag < @songaythue)
								BEGIN
									INSERT INTO TrangThaiPhong VALUES (@maphongduocthue,DATEADD(day,@flag, @ngaythue), N'Using')
									SET @flag = @flag + 1
								END
							SET @status = 1
						END
					ELSE -- trường hợp phòng không trống để thuê
						BEGIN
							SET @status = 0 --'Phòng này đã được đặt'
						END
				END
			ELSE -- mã phòng không hợp lệ
				SET @status = 2 -- 'Mã phòng không hợp lệ'
		END
	ELSE -- mã khách sạn không hợp lệ
		SET @status = 3 -- 'Mã khách sạn không hợp lệ'
END