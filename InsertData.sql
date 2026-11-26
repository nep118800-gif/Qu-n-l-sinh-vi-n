USE QuanLySinhVien;
GO
INSERT INTO KHOA (MaKhoa, TenKhoa) VALUES
('CNTT', N'Công nghệ thông tin'),
('KT',   N'Kinh tế'),
('NN',   N'Ngoại ngữ');

INSERT INTO LOP (MaLop, TenLop, MaKhoa) VALUES
('CNTT01', N'Công nghệ thông tin 1', 'CNTT'),
('CNTT02', N'Công nghệ thông tin 2', 'CNTT'),
('KT01',   N'Kinh tế 1',             'KT'),
('NN01',   N'Ngôn ngữ Anh 1',        'NN');

INSERT INTO SINHVIEN (MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, MaLop) VALUES
('SV001', N'Nguyễn Văn An',   '2004-03-15', N'Nam', N'Tây Ninh',   'CNTT01'),
('SV002', N'Trần Thị Bình',   '2004-07-22', N'Nữ',  N'TP.HCM',     'CNTT01'),
('SV003', N'Lê Hoàng Cường',  '2003-11-05', N'Nam', N'Long An',    'CNTT02'),
('SV004', N'Phạm Thị Dung',   '2004-01-30', N'Nữ',  N'Bình Dương', 'KT01'),
('SV005', N'Võ Minh Em',      '2004-09-10', N'Nam', N'Tây Ninh',   'KT01'),
('SV006', N'Đặng Thu Hà',     '2003-05-18', N'Nữ',  N'Đồng Nai',   'NN01');

-- Cập nhật lớp trưởng sau khi đã có sinh viên
UPDATE LOP SET MaLopTruong = 'SV001' WHERE MaLop = 'CNTT01';
UPDATE LOP SET MaLopTruong = 'SV003' WHERE MaLop = 'CNTT02';
UPDATE LOP SET MaLopTruong = 'SV004' WHERE MaLop = 'KT01';
UPDATE LOP SET MaLopTruong = 'SV006' WHERE MaLop = 'NN01';

INSERT INTO MONHOC (MaMH, TenMH, SoTinChi) VALUES
('MH01', N'Cơ sở dữ liệu',                  3),
('MH02', N'Cấu trúc dữ liệu và giải thuật', 4),
('MH03', N'Kinh tế vi mô',                   3),
('MH04', N'Tiếng Anh chuyên ngành',          2);

INSERT INTO KETQUA (MaSV, MaMH, Diem) VALUES
('SV001', 'MH01', 8.5),
('SV001', 'MH02', 7.0),
('SV002', 'MH01', 9.0),
('SV002', 'MH02', 6.5),
('SV003', 'MH01', 5.5),
('SV003', 'MH02', 4.0),
('SV004', 'MH03', 7.5),
('SV004', 'MH04', 8.0),
('SV005', 'MH03', 6.0),
('SV006', 'MH04', 9.5);