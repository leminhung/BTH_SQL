USE master
create database QLBanHang2_3_2021;
GO

USE QLBanHang2_3_2021
GO
create table PXUAT(
	SoPx char(4) PRIMARY KEY,
	NgayXuat Date default getDate(),
	TenKh nvarchar(100) not null,
	)
GO

create table VATTU(
	MaVTu char(4) PRIMARY KEY,
	TenVTu nvarchar(100) not null,
	DvTinh nvarchar(10) not null,
	PhanTram Real,
	)
GO

create table CTPXUAT(
	SoPx char(4),
	CONSTRAINT FK_SoPx FOREIGN KEY(SoPx) REFERENCES PXUAT(SoPx),
	MaVTu char(4),
	CONSTRAINT FK_MaVTu FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu), 
	SlXuat int not null,
	DgXuat Money not null,
	PRIMARY KEY(SoPx, MaVTu),
)
GO

create table TONKHO(
	NamThang char(6),
	MaVTu char(4),
	CONSTRAINT FK_MaVTu_TONKHO FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu),
	SLDau int not null,
	TongSLN int not null,
	TongSLX int not null,
	SLCuoi int not null,
	PRIMARY KEY(NamThang, MaVTu),
	)
GO

Create table NHACC(
		MaNhaCc char(3) PRIMARY KEY,
		TenNhaCc nvarchar(100) not null,
		DiaChi nvarchar(200) not null,
		DienThoai varchar(20) not null
	)
GO

create table DONDH(
	SoDh char(4) primary key,
	NgayDh datetime,
	MaNhaCc char(3),
	CONSTRAINT FK_MaNhaCc_DONDH FOREIGN KEY(MaNhaCc) REFERENCES NHACC(MaNhaCc),
)
GO

Create table CTDONDH(
	SoDh char(4),
	MaVTu char(4),
	SlDat int not null,
	PRIMARY KEY (SoDH,MaVTu),
	CONSTRAINT FK_SoDh_CTDONDH FOREIGN KEY(SoDh) REFERENCES DONDH(SoDh),
	CONSTRAINT FK_MaVTu_CTDONDH FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu),
	)
GO

Create table PNHAP(
	SoPn char(4) primary key,
	NgayNhap datetime,
	SoDh char(4),
	CONSTRAINT FK_SoDh_PNHAP FOREIGN KEY(SoDh) REFERENCES DONDH(SoDh),
)
GO

Create table CTPNHAP(
	SoPn char(4),
	MaVTu char(4),
	SlNhap int not null,
	DgNhap Money not null,
	PRIMARY KEY(SoPN, MaVTu),
	CONSTRAINT FK_SoPn_CTPNHAP FOREIGN KEY(SoPn) REFERENCES PNHAP(SoPn),
	CONSTRAINT FK_MaVTu_CTPNHAP FOREIGN KEY(MaVTu) REFERENCES VATTU(MaVTu),
)
