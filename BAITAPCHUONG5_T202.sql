
--BÀI TẬP CHƯƠNG 5 QUẢN LÝ BÁN HÀNG 
--QLBanHang2_3_2021


--1.1.a
ALTER PROCEDURE spud_DONDH_TinhSLDat @SoDh CHAR(4), @MaVT CHAR(4), @SLDH INT OUTPUT
AS  
    IF NOT EXISTS(SELECT * FROM CTDONDH WHERE MaVTu = @MaVT AND SoDh = @SoDh)
        BEGIN
            RAISERROR(N'Không tồn tại Mã vật tư và số đặt hàng trong bảng', 16, 1)
            RETURN
        END
    SELECT @SLDH = SlDat
    FROM CTDONDH
    WHERE MaVTu = @MaVT AND SoDh = @SoDh

DECLARE @ans INT
EXECUTE spud_DONDH_TinhSLDat 'D001', 'DD01', @ans OUTPUT
IF(@ans IS NULL) PRINT N'Không có nha'
ELSE PRINT N'Tổng : ' + CONVERT(CHAR(5), @ans)

SELECT * FROM CTDONDH
DROP PROC spud_DONDH_TinhSLDat

SELECT * FROM CTDONDH


DECLARE @kq INT
EXECUTE spud_DONDH_TinhSLDat 


--1.1.b Sửa đề bài
ALTER PROCEDURE spud_PNHAP_TinhTongSLNHang @SoPn CHAR(4), @MaVT CHAR(4), @SLN INT OUTPUT
AS
    IF NOT EXISTS(SELECT * FROM CTPNHAP
     WHERE MaVTu = @MaVT AND SoPn = @SoPn)
        BEGIN
            RAISERROR(N'Không tồn tại Mã vật tư và số đặt hàng trong bảng', 16, 1)
            RETURN
        END
    SELECT @SLN = SlNhap
    FROM CTPNHAP
    WHERE MaVTu = @MaVT AND SoPn = @SoPn 

DECLARE @ans_b INT
EXECUTE spud_DONDH_TinhSLDat 'D001', 'DD01', @ans_b OUTPUT
IF(@ans_b IS NULL) PRINT N'Không có nha'
ELSE PRINT N'Tổng : ' + CONVERT(CHAR(5), @ans_b)





--1.1.c

CREATE PROCEDURE spud_TONKHO_tinhtoncon @NamThang CHAR(6), @MaVT CHAR(4), @SL INT OUTPUT
AS 
    IF NOT EXISTS(SELECT * FROM TONKHO WHERE MaVTu = @MaVT AND NamThang = @NamThang)
        BEGIN
            RAISERROR(N'Năm tháng và mã vật tư không tồn tại', 16, 1)
            RETURN
        END
    SELECT @SL = SLCuoi
    FROM TONKHO
    WHERE MaVTu = @MaVT AND NamThang = @NamThang

DECLARE @ans_c INT
EXECUTE spud_TONKHO_tinhtoncon '200501', 'DD01', @ans_c OUTPUT
IF(@ans_c IS NULL) PRINT N'Không có nha'
ELSE PRINT N'Tổng : ' + CONVERT(CHAR(5), @ans_c)

SELECT * FROM TONKHO

--1.2.a
ALTER PROCEDURE spud_VATTU_Them @MaVT CHAR(4), @TenVT NVARCHAR(100), @DvTinh NVARCHAR(10), @PhanTram REAL
AS
    IF EXISTS(SELECT * FROM VATTU WHERE MaVTu = @MaVT)
        BEGIN
            RAISERROR(N'Vật tư đã tồn tại', 16, 1)
            return
        END
    INSERT INTO VATTU VALUES(@MaVT, @TenVT, @DvTinh, @PhanTram)


EXEC spud_VATTU_Them 'DD06', 'Máy giặt', 'chiec', '23'

SELECT * FROM VATTU


--1.2.b
ALTER PROCEDURE spud_VATTU_Xoa @MaVT CHAR(4) 
AS
    IF EXISTS(SELECT * FROM CTDONDH WHERE MaVTu = @MaVT)
        BEGIN
            RAISERROR(N'Mã vật tư đã tồn tại trong CTDONDH', 16, 1)
            RETURN
        END

    IF EXISTS(SELECT * FROM TONKHO WHERE MaVTu = @MaVT)
        BEGIN
            RAISERROR(N'Mã vật tư đã tồn tại trong TONKHO', 16, 1)
            RETURN
        END
    IF EXISTS(SELECT * FROM CTPNHAP WHERE MaVTu = @MaVT)
        BEGIN
            RAISERROR(N'Mã vật tư đã tồn tại trong CTPNHAP', 16, 1)
            RETURN
        END
    
    DELETE FROM VATTU WHERE MaVTu = @MaVT

EXEC spud_VATTU_Xoa 'DD06'

SELECT * FROM CTPNHAP
SELECT * FROM VATTU

--1.2.c


CREATE PROCEDURE spud_VATTU_Sua @MaVT CHAR(4), @TenVT NVARCHAR(100), @DvTinh NVARCHAR(10), @PhanTram REAL
AS  
    IF NOT EXISTS(SELECT * FROM VATTU WHERE MaVTu = @MaVT)
        BEGIN
            RAISERROR(N'Mã vật tư không tồn tại', 16, 1)
            RETURN
        END
    UPDATE VATTU
    SET TenVTu = @TenVT, DvTinh = @DvTinh, PhanTram = @PhanTram
    WHERE MaVTu = @MaVT

EXECUTE spud_VATTU_Sua 'VD02', 'quan ao', 'chiec', '35' 




--1.3.a
CREATE PROCEDURE spud_VATTU_BcaoDanhSach 
AS 
    SELECT * 
    FROM VATTU
    ORDER BY TenVTu

EXECUTE spud_VATTU_BcaoDanhSach



--1.3.b
CREATE PROCEDURE spud_TONKHO_BcaoTonkho @NamThang CHAR(6)
AS  
    IF NOT EXISTS(SELECT * FROM TONKHO WHERE NamThang = @NamThang)
        BEGIN
            RAISERROR(N'Năm tháng không tồn tại', 16, 1)
            RETURN
        END
    SELECT x.MaVTu, NamThang, SLCuoi, SLDau, TongSLN, TongSLX, TenVTu
    FROM TONKHO x JOIN VATTU y ON x.MaVTu = y.MaVTu
    WHERE NamThang = @NamThang

EXECUTE spud_TONKHO_BcaoTonkho '200501'

SELECT * FROM TONKHO


--1.3.c
ALTER PROCEDURE spud_PcaoPxuat @SoPx CHAR(4) = NULL
AS
    IF(@SoPx IS NULL)
        BEGIN
            SELECT x.SoPx, x.MaVTu, SlXuat, DgXuat, NgayXuat, TenKh, TenVTu 
            FROM CTPXUAT x JOIN VATTU y ON x.MaVTu = y.MaVTu
                                    JOIN PXUAT z ON x.SoPx = z.SoPx
        END
    ELSE
        BEGIN
            IF NOT EXISTS(SELECT * FROM CTPXUAT WHERE SoPx = @SoPx)
                BEGIN
                    RAISERROR(N'Không tồn taị Số phiếu này', 16, 1)
                    RETURN
                END
            ELSE 
                BEGIN
                    SELECT x.SoPx, x.MaVTu, SlXuat, DgXuat, NgayXuat, TenKh, TenVTu 
                    FROM CTPXUAT x JOIN VATTU y ON x.MaVTu = y.MaVTu
                                JOIN PXUAT z ON x.SoPx = z.SoPx
                    WHERE x.SoPx = @SoPx
                END
        END


EXECUTE spud_PcaoPxuat 'X001'
SELECT * FROM CTPXUAT




--1.4.a
ALTER PROCEDURE spud_DONDH_Them @SoDh CHAR(4), @NgayDh DATETIME, @MaNhaCc CHAR(3)
AS
    IF EXISTS(SELECT * FROM DONDH WHERE SoDh = @SoDh)
        BEGIN
            RAISERROR(N'Số đặt hàng đã tồn tại', 16, 1)
            RETURN
        END
    IF NOT EXISTS(SELECT * FROM NHACC WHERE MaNhaCc = @MaNhaCc)
        BEGIN
            RAISERROR(N'Mã nhà cung cấp không tồn tại', 16, 1)
            RETURN
        END
    INSERT INTO DONDH VALUES(@SoDh, @NgayDh, @MaNhaCc)

    IF(@NgayDh IS NULL) 
        INSERT INTO DONDH VALUES(@SoDh, GETDATE(), @MaNhaCc)

EXECUTE spud_DONDH_Them 'D001', '2005-01-17', 'C06'
EXECUTE spud_DONDH_Them 'D009', '2005-01-17', 'C07'
EXECUTE spud_DONDH_Them 'D009', '2005-01-17', 'C06'

SELECT * FROM DONDH


SELECT * FROM NHACC


--1.4.b
CREATE PROCEDURE spud_DONDH_Xoa @SoDh CHAR(4)
AS 
    IF EXISTS(SELECT * FROM PNHAP WHERE SoDh = @SoDh)
        BEGIN
            RAISERROR(N'Số đặt hàng đã tồn tại', 16, 1)
            RETURN
        END
    DELETE FROM DONDH WHERE SoDh = @SoDh
    DELETE FROM CTDONDH WHERE SoDh = @SoDh

EXEC spud_DONDH_Xoa 'D005'
SELECT * FROM CTDONDH



--1.4.c Chưa làm xong đang vướng ý 2
DROP PROCEDURE spud_DONDH_Sua
CREATE PROCEDURE spud_DONDH_Sua @SoDh CHAR(4), @NgayDh DATETIME, @MaNhaCc CHAR(3)
AS
    IF NOT EXISTS(SELECT * FROM NHACC WHERE MaNhaCc = @MaNhaCC)
        BEGIN
            RAISERROR(N'Mã nhà cung cấp không tồn tại', 16, 1)
            RETURN
        END
    
    IF (SELECt * FROM PNHAP WHERE SoDh = @SoDh)
        BEGIN
            IF @NgayDh >= ALL(SELECT NgayNhap FROM PNHAP x JOIN DONDH y ON x.SoDh = y.SoDh
                              WHERE SoDh = @SoDh AND MaNhaCc = @MaNhaCc)
                BEGIN
                    raiserror (N'Ngày đặt hàng không hợp lệ', 16, 1)
			        return
                END
        END
    UPDATE DONDH
    SET MaNhaCc = @MaNhaCc, NgayDh = @NgayDh, SoDh = @SoDh
    WHERE SoDh = @SoDh

EXECUTE spud_DONDH_Sua 'N001', '2005-01-17', 'D001'

SELECT * FROM DONDH
SELECT * FROM PNHAP


--1.4.d
CREATE PROCEDURE spud_CTDONDH_Them @SoDh CHAR(4), @MaVTu CHAR(4), @SlDat INT
AS
    IF NOT EXISTS(SELECT * FROM DONDH WHERE SoDh = @SoDh)
        BEGIN
            RAISERROR(N'Không có số đặt hàng trong DONDH', 16, 1)
            RETURN
        END
    IF NOT EXISTS(SELECT * FROM VATTU WHERE MaVTu = @MaVTu)
        BEGIN
            RAISERROR(N'Không có mã vật tư trong VATTU', 16, 1)
            RETURN
        END

    IF EXISTS(SELECT * FROM CTDONDH WHERE MaVTu = @MaVTu OR SoDh = @SoDh)
        BEGIN
            RAISERROR(N'Mã vật tư hoặc Số đặt hàng đã tồn tại trong CTDONDH', 16, 1)
            RETURN
        END 
    INSERT INTO CTDONDH VALUES(@SoDh , @MaVTu , @SlDat)

EXEC spud_CTDONDH_Them 'D001', 'kkk', 15
EXEC spud_CTDONDH_Them 'kkk', 'DD01', 15
EXEC spud_CTDONDH_Them 'D001', 'DD01', 15
EXEC spud_CTDONDH_Them 'D009', 'DD07', 15


SELECT * FROM VATTU
SELECT * FROM DONDH
SELECT * FROM CTDONDH


--1.4.e đang bị conflict với câu d

CREATE PROCEDURE spud_CTDONDH_Xoa @SoDh CHAR(4), @MaVTu CHAR(4)
AS
    IF EXISTS(SELECT * 
              FROM CTPNHAP x JOIN PNHAP y ON x.SoPn = y.SoPn
                             JOIN VATTU z ON x.MaVTu = z.MaVTu
                             JOIN DONDH t ON y.SoDh = t.SoDh
              WHERE x.MaVTu = @MaVTu OR y.SoDh = @SoDh)
    BEGIN
         RAISERROR(N'Mã vật tư hoặc Số đặt hàng đã tồn tại trong các bảng liên quan CTPNHAP, PNHAP', 16, 1)
         RETURN
    END

    DELETE FROM CTDONDH WHERE MaVTu = @MaVTu OR SoDh = @SoDh

SELECT * FROM CTPNHAP
SELECT * FROM PNHAP
SELECT * FROM VATTU
SELECT * FROM DONDH
SELECT * FROM CTDONDH

EXEC spud_CTDONDH_Xoa 'D009', 'DD07'


--1.4.f
CREATE PROCEDURE spud_CTDONDH_Sua @SoDh CHAR(4), @MaVTu CHAR(4), @SlDat INT
AS
    IF NOT EXISTS(SELECT * FROM CTDONDH WHERE MaVTu = @MaVTu)
    BEGIN
        RAISERROR(N'Mã vật tư không tồn tại trong CTDONDH', 16, 1)
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM CTDONDH WHERE SoDh = @SoDh)
    BEGIN
        RAISERROR(N'Số đặt hàng không tồn tại trong CTDONDH', 16, 1)
        RETURN
    END
    

    
     








