USE QLSinhVien;

DECLARE @MaSV     VARCHAR(10)  = 'SV01';
DECLARE @HoTen    NVARCHAR(100) = N'An';
DECLARE @GioiTinh NVARCHAR(3)  = N'Nữ';
DECLARE @NgaySinh DATE         = '2004-03-12';
DECLARE @Nam      INT          = 2004;
DECLARE @MaKhoa   VARCHAR(10)  = 'CNTT';
DECLARE @MaMH     VARCHAR(10)  = 'MH01';

-- 1. TRUY VẤN THÔNG TIN SINH VIÊN

-- Danh sách tất cả sinh viên
SELECT * FROM SINHVIEN;

-- Tổng số sinh viên trong trường
SELECT COUNT(*) AS TongSV FROM SINHVIEN;

-- Tìm sinh viên theo mã sinh viên
SELECT * FROM SINHVIEN WHERE MaSV = @MaSV;

-- Tìm sinh viên theo họ tên (gần đúng)
SELECT * FROM SINHVIEN WHERE HoTen LIKE N'%' + @HoTen + N'%';

-- Danh sách sinh viên theo giới tính
SELECT * FROM SINHVIEN WHERE GioiTinh = @GioiTinh;

-- Danh sách sinh viên theo ngày sinh hoặc năm sinh
SELECT * FROM SINHVIEN WHERE NgaySinh = @NgaySinh;      
SELECT * FROM SINHVIEN WHERE YEAR(NgaySinh) = @Nam;    

-- Danh sách lớp trưởng của từng lớp 
SELECT * FROM SINHVIEN;
SELECT l.TenLop, sv.HoTen AS LopTruong
FROM LOP l LEFT JOIN SINHVIEN sv ON l.MaLopTruong = sv.MaSV;

-- Sinh viên chưa đăng ký môn học nào
SELECT * FROM SINHVIEN sv
WHERE NOT EXISTS (SELECT 1 FROM KETQUA kq WHERE kq.MaSV = sv.MaSV);

-- 2. TRUY VẤN LỚP HỌC VÀ KHOA

-- Danh sách sinh viên thuộc từng lớp
SELECT l.MaLop, l.TenLop, sv.MaSV, sv.HoTen
FROM LOP l
LEFT JOIN SINHVIEN sv ON l.MaLop = sv.MaLop
ORDER BY l.MaLop, sv.MaSV;

-- Danh sách sinh viên thuộc một khoa
SELECT k.TenKhoa, l.TenLop, sv.MaSV, sv.HoTen
FROM KHOA k
JOIN LOP l       ON k.MaKhoa = l.MaKhoa
JOIN SINHVIEN sv ON l.MaLop = sv.MaLop
WHERE k.MaKhoa = @MaKhoa;

-- Số lượng sinh viên của từng lớp
SELECT l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoSV
FROM LOP l
LEFT JOIN SINHVIEN sv ON l.MaLop = sv.MaLop
GROUP BY l.MaLop, l.TenLop;

-- Số lượng sinh viên của từng khoa
SELECT k.MaKhoa, k.TenKhoa, COUNT(sv.MaSV) AS SoSV
FROM KHOA k
LEFT JOIN LOP l       ON k.MaKhoa = l.MaKhoa
LEFT JOIN SINHVIEN sv ON l.MaLop = sv.MaLop
GROUP BY k.MaKhoa, k.TenKhoa;

-- Lớp có số lượng sinh viên đông nhất
SELECT TOP 1 WITH TIES l.MaLop, l.TenLop, COUNT(sv.MaSV) AS SoSV
FROM LOP l
LEFT JOIN SINHVIEN sv ON l.MaLop = sv.MaLop
GROUP BY l.MaLop, l.TenLop
ORDER BY COUNT(sv.MaSV) DESC;

-- Điểm trung bình của từng lớp
SELECT l.MaLop, l.TenLop, ROUND(AVG(kq.Diem), 2) AS DiemTB
FROM LOP l
LEFT JOIN SINHVIEN sv ON l.MaLop = sv.MaLop
LEFT JOIN KETQUA kq   ON sv.MaSV = kq.MaSV
GROUP BY l.MaLop, l.TenLop;

-- 3. TRUY VẤN MÔN HỌC VÀ KẾT QUẢ HỌC TẬP

-- Danh sách môn học mà một sinh viên đã đăng ký
SELECT sv.MaSV, sv.HoTen, mh.MaMH, mh.TenMH, mh.SoTinChi
FROM KETQUA kq
JOIN SINHVIEN sv ON kq.MaSV = sv.MaSV
JOIN MONHOC mh   ON kq.MaMH = mh.MaMH
WHERE sv.MaSV = @MaSV;

-- Điểm của sinh viên theo từng môn học
SELECT sv.MaSV, sv.HoTen, mh.TenMH, kq.Diem
FROM KETQUA kq
JOIN SINHVIEN sv ON kq.MaSV = sv.MaSV
JOIN MONHOC mh   ON kq.MaMH = mh.MaMH
ORDER BY sv.MaSV, mh.MaMH;

-- Sinh viên có điểm cao nhất của một môn học
SELECT sv.MaSV, sv.HoTen, mh.TenMH, kq.Diem
FROM KETQUA kq
JOIN SINHVIEN sv ON kq.MaSV = sv.MaSV
JOIN MONHOC mh   ON kq.MaMH = mh.MaMH
WHERE kq.MaMH = @MaMH
  AND kq.Diem = (SELECT MAX(Diem) FROM KETQUA WHERE MaMH = @MaMH);

-- Sinh viên có điểm dưới 5
SELECT sv.MaSV, sv.HoTen, mh.TenMH, kq.Diem
FROM KETQUA kq
JOIN SINHVIEN sv ON kq.MaSV = sv.MaSV
JOIN MONHOC mh   ON kq.MaMH = mh.MaMH
WHERE kq.Diem < 5;

-- Điểm trung bình của từng sinh viên
SELECT sv.MaSV, sv.HoTen, ROUND(AVG(kq.Diem), 2) AS DiemTB
FROM SINHVIEN sv
JOIN KETQUA kq ON sv.MaSV = kq.MaSV
GROUP BY sv.MaSV, sv.HoTen;

-- Xếp loại học lực dựa trên điểm trung bình
-- Xuất sắc >= 9 | Giỏi >= 8 | Khá >= 7 | Trung bình >= 5 | Yếu < 5
SELECT sv.MaSV, sv.HoTen, ROUND(AVG(kq.Diem), 2) AS DiemTB,
       CASE
           WHEN AVG(kq.Diem) >= 9 THEN N'Xuất sắc'
           WHEN AVG(kq.Diem) >= 8 THEN N'Giỏi'
           WHEN AVG(kq.Diem) >= 7 THEN N'Khá'
           WHEN AVG(kq.Diem) >= 5 THEN N'Trung bình'
           ELSE N'Yếu'
       END AS XepLoai
FROM SINHVIEN sv
JOIN KETQUA kq ON sv.MaSV = kq.MaSV
GROUP BY sv.MaSV, sv.HoTen;

-- Sinh viên đạt học lực Giỏi hoặc Xuất sắc
WITH XL AS (
    SELECT sv.MaSV, sv.HoTen, ROUND(AVG(kq.Diem), 2) AS DiemTB,
           CASE
               WHEN AVG(kq.Diem) >= 9 THEN N'Xuất sắc'
               WHEN AVG(kq.Diem) >= 8 THEN N'Giỏi'
               WHEN AVG(kq.Diem) >= 7 THEN N'Khá'
               WHEN AVG(kq.Diem) >= 5 THEN N'Trung bình'
               ELSE N'Yếu'
           END AS XepLoai
    FROM SINHVIEN sv
    JOIN KETQUA kq ON sv.MaSV = kq.MaSV
    GROUP BY sv.MaSV, sv.HoTen
)
SELECT * FROM XL WHERE XepLoai IN (N'Giỏi', N'Xuất sắc');

-- Số sinh viên đậu và rớt theo từng môn (đậu: điểm >= 5)
SELECT mh.MaMH, mh.TenMH,
       SUM(CASE WHEN kq.Diem >= 5 THEN 1 ELSE 0 END) AS SoDau,
       SUM(CASE WHEN kq.Diem <  5 THEN 1 ELSE 0 END) AS SoRot
FROM MONHOC mh
LEFT JOIN KETQUA kq ON mh.MaMH = kq.MaMH
GROUP BY mh.MaMH, mh.TenMH;

-- Sinh viên có điểm trung bình cao nhất
SELECT TOP 1 WITH TIES sv.MaSV, sv.HoTen, ROUND(AVG(kq.Diem), 2) AS DiemTB
FROM SINHVIEN sv
JOIN KETQUA kq ON sv.MaSV = kq.MaSV
GROUP BY sv.MaSV, sv.HoTen
ORDER BY AVG(kq.Diem) DESC;

-- Môn học có nhiều sinh viên đăng ký nhất
SELECT TOP 1 WITH TIES mh.MaMH, mh.TenMH, COUNT(kq.MaSV) AS SoSVDangKy
FROM MONHOC mh
LEFT JOIN KETQUA kq ON mh.MaMH = kq.MaMH
GROUP BY mh.MaMH, mh.TenMH
ORDER BY COUNT(kq.MaSV) DESC;
