use Bank
go

--tách thành phố
select ltrim(right(Cust_ad,charindex(',',reverse(replace(cust_ad,'-',' ,')))-1)) as 'tinh/tp cua kh'
from customer


--1. Liệt kê danh sách khách hàng ở Đà Nẵng
--bảng nào?
--cột nào?
--điều kiện nào?

select customer.Cust_id, Cust_name, Cust_ad, account.Ac_no
from customer, account
where cust_ad LIKE N'%Đà Nẵng'

--2. Liệt kê những tài khoản loại VIP (type = 1)

SELECT *
FROM account
WHERE ac_type=1

--3. Liệt kê những khách hàng không sử dụng số điện thoại của Mobi phone

SELECT Cust_id, Cust_name, Cust_phone
FROM customer 
WHERE Cust_phone NOT LIKE '012%' 

--4. Liệt kê những khách hàng họ Phạm
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE N'Phạm%'

--5. Liệt kê những khách hàng tên chứa chữ g
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE '%g%'

--6. Liệt kê những khách hàng chữ cái thứ 2 của tên là chữ H, T, A, Ê
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE N'_[htaàạãáăâêếềệễ]%'
 
 --7. Liệt kê những giao dịch diễn ra trong quý IV năm 2016
 SELECT *
 FROM  transactions
 WHERE t_date BETWEEN '2016/10/01' AND '2016/12/31'

 --8. Liệt kê những giao dịch diễn ra trong mùa thu năm 2016
 SELECT *
 FROM  transactions
  WHERE t_date BETWEEN '2016/7/01' AND '2016/9/30'

 --9. Liệt kê những khách hàng không thuộc các chi nhánh miền bắc
 SELECT Cust_id, Cust_name, BR_id
 FROM  customer
 WHERE BR_id NOT LIKE 'VB%'

 --10. Liệt kê những tài khoản nhiều hơn 100 triệu trong tài khoản
 SELECT *
 FROM account
 WHERE ac_balance> 100000000

 --11. Liệt kê những giao dịch gửi tiền diễn ra ngoài giờ hành chính
 SELECT t_id, t_time, t_date, t_type
 FROM transactions
 WHERE ( (DATEPART(hh,t_time)<7 OR DATEPART(hh,t_time)>11) ) AND ( DATEPART(hh,t_time)<13  OR DATEPART(hh,t_time)>17 ) AND t_type=1

--12. Liệt kê những giao dịch rút tiền diễn ra vào khoảng từ 0-3h sáng
SELECT t_id, t_time, t_date
FROM transactions
WHERE (DATEPART(hh,t_time)>=0 AND DATEPART(hh,t_time)<3) AND t_type=0


--13. Tìm những khách hàng có địa chỉ ở Ngũ Hành Sơn – Đà nẵng
SELECT customer.Cust_id, Cust_name, Cust_ad
FROM customer
WHERE cust_ad LIKE N'%Đà Nẵng' AND cust_ad LIKE N'%Ngũ Hành Sơn%'

--14. Liệt kê những chi nhánh chưa có địa chỉ
SELECT BR_id, BR_name
FROM Branch
WHERE BR_ad LIKE N''

--15. Liệt kê những giao dịch rút tiền bất thường (nhỏ hơn 50.000)
SELECT t_id, t_time, t_date, t_amount
FROM transactions
WHERE (t_amount < 50000) AND t_type=0

--16. Liệt kê các giao dịch gửi tiền diễn ra trong năm 2017.
SELECT t_id, t_time, t_date, t_amount
FROM transactions
WHERE YEAR(t_date)=2017 AND t_type=1

--17. Liệt kê những giao dịch bất thường (tiền trong tài khoản âm)
SELECT   t_id, t_time, t_date, t_amount, ac_balance
FROM transactions JOIN account ON transactions.ac_no=account.Ac_no
WHERE ac_balance<0

--18.  Hiển thị tên khách hàng và tên tỉnh/thành phố mà họ sống
SELECT Cust_name, Cust_ad
FROM customer

--19. Hiển thị danh sách khách hàng có họ tên không bắt đầu bằng chữ N, T
SELECT Cust_name
FROM customer
WHERE  LEFT(Cust_name,1) NOT LIKE '[NT]'

--20. Hiển thị danh sách khách hàng có kí tự thứ 3 từ cuối lên là chữ a, u, i
SELECT Cust_name
FROM customer
WHERE  Cust_name LIKE '%[aàảãáạăằẳẵắặâầẩẫấậuùủũúụưừửữứựiìỉĩíị]__'

--21. Hiển thị khách hàng có tên đệm là Thị hoặc Văn
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE N'%Thị_%' OR   Cust_name LIKE N'%Văn_%'

--22. Hiển thị khách hàng có địa chỉ sống ở vùng nông thôn. Với quy ước: nông thôn là vùng mà địa chỉ chứa: thôn, xã, xóm
SELECT customer.Cust_id, Cust_name, Cust_ad
FROM customer
WHERE cust_ad LIKE N'%thôn%' OR cust_ad LIKE N'%xã%' OR cust_ad LIKE N'%xóm%'

--23.  Hiển thị danh sách khách hàng có kí tự thứ hai của TÊN là chữ u hoặc ũ hoặc a. Chú ý: TÊN là từ cuối cùng của cột cust_name
SELECT  Cust_id, Cust_name
FROM customer
WHERE parsename(replace(Cust_name, ' ', '.'), 1) like N'_[u,ũ,a]%'

---------------------------------------05.09.22 DEMO----------------------------------------
select	getdate() CurrentTime,
		day(getdate()) CurrentDay,
		datepart(DD, getdate()) CurrentDay

select Datediff(dd, '2002-02-26',getdate())