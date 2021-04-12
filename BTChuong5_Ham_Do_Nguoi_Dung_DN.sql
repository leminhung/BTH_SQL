
--2.1a
CREATE FUNCTION Fn_TongNhapThang (@MaVT CHAR(4))
RETURNS INT
AS
BEGIN
    DECLARE @ans INT
    SELECT @ans = SUM(SlNhap)
    FROM CTPNHAP
    WHERE MaVTu = @MaVT
    RETURN @ans
END

SELECT dbo.Fn_TongNhapThang('DD01')



--2.1b
CREATE FUNCTION Fn_TongXuatThang (@MaVT CHAR(4))
RETURNS INT
AS
BEGIN
    DECLARE @ans INT
    SELECT @ans = SUM(SLXuat)
    FROM CTPXUAT
    WHERE MaVTu = @MaVT
    RETURN @ans
END

SELECT dbo.Fn_TongXuatThang('DD01')



--2.1c
ALTER FUNCTION Fn_TongNhap(@sodh char(4), @mavt char(4))
RETURNS INT
AS
BEGIN
    DECLARE @ans INT
    SELECT @ans = SUM(SlNhap)
    FROM CTPNHAP x JOIN PNHAP y ON x.SoPn = y.SoPn
    WHERE SoDh = @sodh AND MaVTu = @mavt
    RETURN @ans
END


SELECT dbo.Fn_TongNhap('D001' ,'DD02')

SELECT * FROM PNHAP
SELECT * FROM CTPNHAP


--2.1d
ALTER FUNCTION Fn_ConNhap(@sodh char(4), @mavt char(4))
RETURNS INT
AS
BEGIN
    DECLARE @ans INT
    SELECT @ans = SUM(SLDat)
    FROM CTDONDH
    WHERE MaVTu = @mavt AND SoDh = @sodh

    DECLARE @ans1 INT
    SET @ans1 = dbo.Fn_TongNhap(@sodh ,@mavt)
    SET @ans = @ans - @ans1

    RETURN @ans
END


SELECT dbo.Fn_ConNhap('D001' ,'DD02')


SELECT * FROM CTDONDH




--1.2e
CREATE FUNCTION Fn_Ton(@MaVT CHAR(4), @NamThang CHAR(6))
RETURNS INT
AS
BEGIN
    DECLARE @ans INT
    SELECT @ans = SUM(TongSLN + SLDau - TongSLX)
    FROM TONKHO
    WHERE MaVTu = @MaVT AND NamThang = @NamThang
    RETURN @ans
END



SELECT dbo.Fn_Ton('DD02' ,'200501')
SELECT * FROM TONKHO





-------------------------------------------------------------------------
--2.2a
CREATE FUNCTION Fn_DS_VatTuConNhap(@sodh CHAR(4))
RETURNS @bang1 TABLE(sodh CHAR(4), MaVTu CHAR(4), SLCon INT)
AS
BEGIN
    INSERT INTO @bang1
    SELECT sodh, MaVTu, dbo.Fn_ConNhap(sodh ,MaVTu) AS 'slc'
    FROM CTDONDH
    WHERE dbo.Fn_ConNhap(sodh ,MaVTu) > 0 AND SoDh = @sodh
    RETURN
END


SELECT * FROM dbo.Fn_DS_VatTuConNhap('D001')

--2.2b
CREATE FUNCTION Fn_DS_VatTuTonKho(@NamThang CHAR(6), @ToiThieu INT)
RETURNS @bang2 TABLE (MaVTu CHAR(4), TenVTu NVARCHAR(100), DvTinh NVARCHAR(10), PhanTram REAL, NamThang CHAR(6))
AS
BEGIN
    INSERT INTO @bang2
    SELECT x.MaVTu , TenVTu, DvTinh, PhanTram, NamThang
    FROM TONKHO x JOIN VATTU y ON x.MaVTu = y.MaVTu
    WHERE NamThang = @NamThang AND SLCuoi >= @ToiThieu
    RETURN
END



