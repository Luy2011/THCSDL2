USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name ='QLGH_NHOM1')
BEGIN   
    ALTER DATABASE QLGH_NHOM1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QLGH_NHOM1
END;
create database QLGH_NHOM1
go
	USE QLGH_NHOM1
go
create table KHACHHANG
(
MAKHACHHANG char(10) not null primary key,
TENCONGTY nvarchar(20) null,
TENGIAODICH nvarchar(20) not null,
DIACHI nvarchar(50) not null,
EMAIL varchar(30) unique,
DIENTHOAI varchar(11)  unique,
FAX varchar(20) null
)
Create table NHANVIEN 
( 
MANHANVIEN varchar(20) primary key, 
HO varchar(50) not null, 
TEN varchar (50) not null,
NGAYSINH date not null, 
NGAYLAMVIEC date not null,
DIACHI nvarchar(50) not null,
DIENTHOAI varchar (11) unique, 
LUONGCOBAN money, 
PHUCAP money
)
Create table DONDATHANG
(
SOHOADON char(10) primary key,
MAKHACHHANG char(10)  foreign key references KHACHHANG(MAKHACHHANG),
MANHANVIEN varchar(20) foreign key references NHANVIEN(MANHANVIEN),
NGAYDATHANG date not null,
NGAYGIAOHANG date not null,
NGAYCHUYENHANG date  not null,
NOIGIAOHANG nvarchar(50) not null
)
create table NHACUNGCAP 
( 
MACONGTY char(10) primary key, 
TENCONGTY nvarchar(50), 
TENGIAODICH nvarchar(50) not null, 
DIACHI nvarchar(50) not null, 
DIENTHOAI char(11) unique, 
FAX varchar(15) , 
EMAIL varchar(50) unique 
) 

create table  LOAIHANG
 ( 
MALOAIHANG char (15) primary key, 
TENLOAIHANG varchar (30) not null, 
)
create table MATHANG 
( 
MAHANG char(10) primary key, 
TENHANG nvarchar(50) not null, 
MACONGTY char(10), 
MALOAIHANG char(15) not null, 
SOLUONG int check(SOLUONG>0), 
DONVITINH nvarchar(10), 
GIAHANG money check (GIAHANG > 0), 
foreign key (MACONGTY) references NHACUNGCAP (MACONGTY), 
foreign key (MALOAIHANG) references LOAIHANG (MALOAIHANG) 
) 

create table CHITIETDATHANG 
( 
GIABAN money check(GIABAN>0), 
SOLUONG int check(SOLUONG>0), 
MUCGIAMGIA money,
SOHOADON char(10) foreign key references DONDATHANG(SOHOADON), 
MAHANG char(10) foreign key references MATHANG (MAHANG), 
)

-- Thiết lập mối quan hệ giữa DONDATHANG và KHACHHANG  

ALTER TABLE DONDATHANG  
ADD CONSTRAINT FK_DONDATHANG_KHACHHANG  
FOREIGN KEY (MAKHACHHANG) REFERENCES KHACHHANG(MAKHACHHANG);  


-- Thiết lập mối quan hệ giữa DONDATHANG và NHANVIEN 
 
ALTER TABLE DONDATHANG  
ADD CONSTRAINT FK_DONDATHANG_NHANVIEN  
FOREIGN KEY (MANHANVIEN) REFERENCES NHANVIEN(MANHANVIEN);  


-- Thiết lập mối quan hệ giữa CHITIETDATHANG và DONDATHANG  

ALTER TABLE CHITIETDATHANG  
ADD CONSTRAINT FK_CHITIETDATHANG_DONDATHANG  
FOREIGN KEY (SOHOADON) REFERENCES DONDATHANG(SOHOADON);  


-- Thiết lập mối quan hệ giữa CHITIETDATHANG và MATHANG  

ALTER TABLE CHITIETDATHANG  
ADD CONSTRAINT FK_CHITIETDATHANG_MATHANG  
FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG);  


-- Thiết lập mối quan hệ giữa MATHANG và NHACUNGCAP  

ALTER TABLE MATHANG  
ADD CONSTRAINT FK_MATHANG_NHACUNGCAP  
FOREIGN KEY (MACONGTY) REFERENCES NHACUNGCAP(MACONGTY);  


-- Thiết lập mối quan hệ giữa MATHANG và LOAIHANG  

ALTER TABLE MATHANG  
ADD CONSTRAINT FK_MATHANG_LOAIHANG  
FOREIGN KEY (MALOAIHANG) REFERENCES LOAIHANG(MALOAIHANG);

--
ALTER TABLE KHACHHANG
ADD CONSTRAINT CK_DT CHECK(DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
			or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
ALTER TABLE MATHANG 
ADD CONSTRAINT CK_giahang CHECK (GIAHANG>0),
	CONSTRAINT CK_SL CHECK (SOLUONG >=0);

ALTER TABLE CHITIETDATHANG
ADD CONSTRAINT DF_soluong DEFAULT 0 FOR SOLUONG,
    CONSTRAINT DF_mucgiamgia DEFAULT 0 FOR MUCGIAMGIA;

ALTER TABLE DONDATHANG
ADD CONSTRAINT CK_Ngay CHECK (NGAYDATHANG <=NGAYGIAOHANG AND NGAYDATHANG <=  NGAYCHUYENHANG );

ALTER TABLE NHACUNGCAP
ADD CONSTRAINT CK_DT_NCC CHECK(DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
			or DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE NHANVIEN
ADD CONSTRAINT CK_Tuoi CHECK (DATEDIFF(YEAR, NGAYSINH, NGAYLAMVIEC) >= 18 and DATEDIFF(YEAR, NGAYSINH, NGAYLAMVIEC) <= 60),
	CONSTRAINT CK_LUONG CHECK (LUONGCOBAN >0);
--
INSERT INTO KHACHHANG (MAKHACHHANG,TENCONGTY,TENGIAODICH,DIACHI,EMAIL,DIENTHOAI,FAX)
VALUES
	('KH001', 'Công ty TNHH ABC', 'Nguyễn Văn An', '123 Lê Lợi, Hà Nội', 'a@gmail.com', '0123456789', '0241234567'),
	('KH002', 'Công ty TNHH XYZ', 'Trần Thị Loan', '456 Trần Hưng Đạo, Đà Nẵng', 'b@gmail.com', '0987654321', '0511234567'),
	('KH003', 'Công ty CP DEF', 'Lê Văn Cung', '789 Hai Bà Trưng, TP.HCM', 'c@gmail.com', '0112233445', '0831234567'),
	('KH004', 'Công ty CP GHI', 'Phạm Thị Duyên', '101 Nguyễn Trãi, Hà Nội', 'd@gmail.com', '0987543616', '0247654321'),
	('KH005', 'Công ty TNHH JKL', 'Vũ Văn Phong', '202 Bạch Đằng, Quảng Ninh', 'e@gmail.com', '0123487902', '0331234567'),
	('KH006', 'Công ty CP MNO', 'Hoàng Thị Phương', '303 Cao Thắng, Hải Phòng', 'f@gmail.com', '0927654901', '0311234567'),
	('KH007', 'Công ty TNHH PQR', 'Đỗ Văn Giang', '404 Lý Thường Kiệt, Huế', 'g@gmail.com', '0923456709', '0541234567'),
	('KH008', 'Công ty CP STU', 'Bùi Thị Hường', '505 Nguyễn Du, Quảng Trị', 'h@gmail.com', '0987654068', '0531234567'),
	('KH009', 'Công ty TNHH VWX', 'Nguyễn Văn Thoại', '606 Phan Chu Trinh, Cà Mau', 'i@gmail.com', '0113456897', '0781234567'),
	('KH010', 'Công ty CP YZA', 'Phạm Thị Khuyên', '707 Tôn Đức Thắng, Điện Biên', 'k@gmail.com', '0987643215', '0231234567');
	SELECT * FROM KHACHHANG;
-- 
Set dateformat dmy
INSERT INTO NHANVIEN (MANHANVIEN, HO, TEN, NGAYSINH, NGAYLAMVIEC, DIACHI, DIENTHOAI, LUONGCOBAN, PHUCAP) 
VALUES
	('NV001', 'Phan', 'Đồng Hạ', '2000-01-25', '2023-01-20', '145 Phan Thanh', '0356987410', '5000000', '5000'),
    ('NV002', 'Nguyễn', 'Thị Hà', '1999-10-25', '2023-12-20', '15 Thanh Châu', '0356987910', '6500000', '10000'),
    ('NV003', 'Trần', 'Văn Phúc', '2005-05-20', '2023-01-20', '101 Phan Thanh', '0396987419', '5000000', '5000'),
    ('NV004', 'Phan', 'Văn An', '2004-01-05', '2023-01-20', '145 Phan Thanh', '0356127410', '7000000', '5000'),
    ('NV005', 'Trần', 'Thị Mai', '2001-01-25', '2023-01-20', '145 Phan Thanh', '0310987417', '6000000', '5000'),
    ('NV006', 'Lê', 'Minh Tâm', '2003-01-25', '2023-01-10', '145 Phan Thanh', '0355987410', '5000000', '5000'),
    ('NV007', 'Phan', 'Quốc Duy', '2000-05-25', '2023-09-21', '145 Phan Thanh', '0356217410', '5000000', '5000'),
    ('NV008', 'Đỗ', 'Thị Hương', '1997-02-28', '2023-01-20', '145 Phan Thanh', '0356985213', '7500000', '15000'),
    ('NV009', 'Bùi', 'Văn Kiên', '2003-03-23', '2023-10-20', '145 Phan Thanh', '0356987411', '5500000', '5000'),
    ('NV010', 'Vũ', 'Thị Lan', '2001-09-27', '2023-12-20', '145 Phan Thanh', '0356987415', '5500000', '10000');
--
set dateformat dmy
INSERT INTO DONDATHANG (SOHOADON,MAKHACHHANG,MANHANVIEN,NGAYDATHANG,NGAYGIAOHANG, NGAYCHUYENHANG,NOIGIAOHANG)
VALUES
	('HD001', 'KH001', 'NV001', '2024-01-01', '2024-03-05', '2024-02-17', '123 Lê Lợi'),
	('HD002', 'KH002', 'NV002', '2024-01-02', '2024-03-06', '2024-02-18', '34 Trần Hưng Đạo'),
	('HD003', 'KH003', 'NV003', '2024-01-03', '2024-03-07', '2024-02-19', '79 Lý Thánh Tông'),
	('HD004', 'KH004', 'NV004', '2024-01-04', '2024-03-08', '2024-02-10', '10 Nguyễn Du'),
	('HD005', 'KH005', 'NV005', '2024-01-05', '2024-03-09', '2024-02-21', '22 Bạch Đằng'),
	('HD006', 'KH006', 'NV006', '2024-01-06', '2024-03-10', '2024-02-22', '48 Lý Thái Tổ'),
	('HD007', 'KH007', 'NV007', '2024-01-07', '2024-03-11', '2024-02-23', '56 Nguyễn Thị Minh Khai'),
	('HD008', 'KH008', 'NV008', '2024-01-08', '2024-03-12', '2024-02-24', '56 Nguyễn Thị Minh Khai'),
	('HD009', 'KH009', 'NV009', '2024-01-09', '2024-03-13', '2024-02-25', '66 Phan Chu Trinh'),
	('HD010', 'KH010', 'NV010', '2024-01-10', '2024-03-14', '2024-02-26', '70 Lê Lợi');
--
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL) 
VALUES 
	('CT001', 'Công ty K', 'K Company', 'Số 11, Đường K, Quận 11', '0123456781', '0212345679', 'contact@companyK.com'),
	('CT002', 'Công ty L', 'L Company', 'Số 12, Đường L, Quận 12', '0987654322', '0223456790', 'contact@companyL.com'),
	('CT003', 'Công ty M', 'M Company', 'Số 13, Đường M, Quận 13', '0112233446', '0234567891', 'contact@companyM.com'),
	('CT004', 'Công ty N', 'N Company', 'Số 14, Đường N, Quận 14', '0123456782', '0245678902', 'contact@companyN.com'),
	('CT005', 'Công ty O', 'O Company', 'Số 15, Đường O, Quận 15', '0134567891', '0256789013', 'contact@companyO.com'),
	('CT006', 'Công ty P', 'P Company', 'Số 16, Đường P, Quận 16', '0145678902', '0267890124', 'contact@companyP.com'),
	('CT007', 'Công ty Q', 'Q Company', 'Số 17, Đường Q, Quận 17', '0156789013', '0278901235', 'contact@companyQ.com'),
	('CT008', 'Công ty R', 'R Company', 'Số 18, Đường R, Quận 18', '0167890124', '0289012346', 'contact@companyR.com'),
	('CT009', 'Công ty S', 'S Company', 'Số 19, Đường S, Quận 19', '0178901235', '0290123457', 'contact@companyS.com'),
	('CT010', 'Công ty T', 'T Company', 'Số 20, Đường T, Quận 20', '0189012346', '0201234568', 'contact@companyT.com');
--
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG) 
VALUES	
	('LH001', 'Thuốc'),
	('LH002', 'Thuốc tây'),
	('LH003', 'Thuốc nam'),
	('LH004', 'Thuốc bổ'),
	('LH005', 'Thuốc hạ sốt'),
	('LH006', 'Thuốc kháng sinh'),
	('LH007', 'Thuốc chống viêm'),
	('LH008', 'Thuốc an thần'),
	('LH009', 'Thuốc tiêu hóa'),
	('LH010', 'Thuốc bổ mắt');
--
INSERT INTO MATHANG (MAHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG) 
VALUES  
	('MH001', 'Thuốc giảm đau', 'CT001', 'LH001', 100, 'Viên', 50000.00),
	('MH002', 'Thuốc kháng sinh A', 'CT002', 'LH002', 200, 'Viên', 120000.00),
	('MH003', 'Thuốc bổ huyết', 'CT003', 'LH003', 150, 'Chai', 75000.00),
	('MH004', 'Thuốc hạ sốt A', 'CT004', 'LH004', 80, 'Viên', 60000.00),
	('MH005', 'Thuốc hạ sốt B', 'CT005', 'LH005', 60, 'Chai', 65000.00),
	('MH006', 'Thuốc kháng viêm A', 'CT006', 'LH006', 120, 'Viên', 110000.00),
	('MH007', 'Thuốc an thần A', 'CT007', 'LH007', 90, 'Viên', 90000.00),
	('MH008', 'Thuốc tiêu hóa A', 'CT008', 'LH008', 130, 'Gói', 30000.00),
	('MH009', 'Thuốc bổ mắt A', 'CT009', 'LH009', 50, 'Chai', 80000.00),
	('MH010', 'Thuốc kháng sinh B', 'CT010', 'LH010', 75, 'Viên', 140000.00);
--
INSERT INTO CHITIETDATHANG (SOHOADON, MAHANG, GIABAN, SOLUONG, MUCGIAMGIA) 
VALUES  
	('HD001', 'MH001', 45000.00, 5, 4000.00),
	('HD002', 'MH002', 95000.00, 2, 8000.00),
	('HD003', 'MH003', 50000.00, 10, 5000.00),
	('HD004', 'MH004', 130000.00, 1, 10000.00),
	('HD005', 'MH005', 70000.00, 3, 7000.00),
	('HD006', 'MH006', 65000.00, 4, 6000.00),
	('HD007', 'MH007', 80000.00, 6, 8000.00),
	('HD008', 'MH008', 120000.00, 2, 12000.00),
	('HD009', 'MH009', 60000.00, 7, 5000.00),
	('HD010', 'MH010', 30000.00, 8, 2000.00);


--Tăng phụ cấp lên 50% lương cho những nhân viên bán được hàng nhiều nhất:
UPDATE NHANVIEN
SET PhuCap = LuongCoBan * 0.5
WHERE MaNhanVien = (
    SELECT TOP 1 MaNhanVien 
    FROM DONDATHANG
    GROUP BY MANHANVIEN
    ORDER BY COUNT(SOHOADON) DESC);

--Giảm 25% lương của những nhân viên trong năm 2023 không lập được bất kỳ đơn đặt hàng nào:

UPDATE NHANVIEN
SET LUONGCOBAN=LUONGCOBAN * 0.75
WHERE MANHANVIEN NOT IN (
    SELECT MANHANVIEN 
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2023);

--	xóa nhân viên tuổi việc 40 năm
DELETE FROM NHANVIEN
WHERE NGAYLAMVIEC < DATEADD(YEAR, -40, GETDATE());

--Xóa những đơn đặt hàng trước năm 2010 ra khỏi cơ sở dữ liệu:
DELETE FROM DONDATHANG
WHERE YEAR(NGAYDATHANG) < 2010;

--Xóa khỏi bảng MatHang những mặt hàng có số lượng bằng 0 và không được đặt mua trong bất kỳ đơn đặt hàng nào:

DELETE FROM MATHANG
WHERE SOLUONG = 0
AND MAHANG NOT IN (
    SELECT MAHANG 
    FROM CHITIETDATHANG);