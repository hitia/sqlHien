use bank
go
--25. Thống kê số lượng giao dịch, TỔNG số tiền giao dịch theo loại giao dịch
SELECT T_TYPE, COUNT(T_TYPE) AS SOLUONG, SUM(t_amount) TONG
FROM transactions
GROUP BY T_TYPE
--26. Có bao nhiêu khách hàng địa chỉ ở Huế
SELECT count(cust_ad)
FROM customer
WHERE CUST_AD LIKE N'%Huế%'

--36. SỐ TIỀN TRUNG BÌNH MỖI LÂN THỰC HIỆN GIAO DỊCH RÚT TIÊN TRONG NĂM 2017 LÀ BAO NHIÊU
SELECT AVG(T_AMOUNT) TIENRUTTB
FROM transactions
WHERE YEAR(t_DATE)=2017 AND t_type=0

--1. Có bao nhiêu khách hàng có ở Quảng Nam thuộc chi nhánh ngân hàng Vietcombank Đà Nẵng
SELECT CUST_ID, COUNT(CUST_ID) AS SOLUONG
FROM customer JOIN Branch ON customer.Br_id = Branch.BR_id
WHERE BR_name LIKE N'Vietcombank Đà Nẵng' AND Cust_ad LIKE N'%QUẢNG NAM'
GROUP BY Cust_id

--2. Hiển thị danh sách khách hàng thuộc chi nhánh Vũng Tàu và số dư trong tài khoản của họ.
SELECT Cust_name, account.Ac_no, AC_BALANCE, BR_name
FROM Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
WHERE BR_name LIKE N'Vietcombank Vũng Tàu' 


--3. Trong quý 1 năm 2012, có bao nhiêu khách hàng thực hiện giao dịch rút tiền tại Ngân hàng Vietcombank?
SELECT COUNT(customer.Cust_id) AS 'SO LUONG RUT TIEN' 
FROM Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
			JOIN transactions ON  account.Ac_no=transactions.ac_no 
WHERE BR_name LIKE N'%Vietcombank%' AND t_type=0 AND t_date BETWEEN '2012/01/01' AND '2012/03/31'


--4. Thống kê số lượng giao dịch, tổng tiền giao dịch trong từng tháng của năm 2014 
SELECT MONTH(T_date) as THANG, SUM(t_amount) TONGTIENGD
FROM transactions
WHERE YEAR(t_date)=2014
GROUP BY MONTH(T_date)

--5. Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền
SELECT Br_name,SUM(t_amount) TONGTIEN 
FROM customer,Branch, account, transactions
WHERE customer.Br_id = Branch.BR_id 
	AND customer.Cust_id=account.cust_id 
	AND account.Ac_no=transactions.ac_no AND t_type=1
GROUP BY BR_name
ORDER BY TONGTIEN DESC

--6. Chi nhánh Sài Gòn có bao nhiêu khách hàng không thực hiện bất kỳ giao dịch nào trong vòng 3 năm trở lại đây.   ### KO CO CHU BAO NHIEU
--Nếu có thể, hãy hiển thị tên và số điện thoại của các khách đó để phòng marketing xử lý.

SELECT DISTINCT cust_name, cust_phone
FROM branch join customer on branch.BR_id = customer.Br_id
			join account on customer.Cust_id = account.cust_id
WHERE BR_name = N'Vietcombank Sài Gòn'
and Ac_no not in ( SELECT Ac_no
					FROM transactions
					WHERE t_date >= dateadd(YY,-3, GETDATE()) )


--7. Thống kê thông tin giao dịch theo mùa, nội dung thống kê gồm: số lượng giao dịch,  #######
--lượng tiền giao dịch trung bình, tổng tiền giao dịch, lượng tiền giao dịch nhiều nhất, lượng tiền giao dịch ít nhất.

 
select datepart(qq,t_date) as N'Mùa',	
		count(t_id) as N'số lượng giao dịch' , 
		avg(t_amount) as N'lượng tiền giao dịch trung bình', 
		sum(t_amount) as N'tổng tiền giao dịch',
		max(t_amount) as'lượng tiền giao dịch nhiều nhất',  
		min(t_amount) as N'lượng tiền giao dịch ít nhất'
from    transactions
group by datepart(qq,t_date)

--8. Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhánh Huế. Nếu có thể, hãy đưa ra tên của khách hàng thực hiện giao dịch đó.

select Cust_name , MAX(t_amount) AS N'số tiền giao dịch nhiều nhất 2016 '
from Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
			JOIN transactions ON  account.Ac_no=transactions.ac_no 
WHERE BR_name LIKE N'%Huế' AND YEAR(T_DATE) = 2016
GROUP BY Cust_name

--9. Tìm khách hàng có lượng tiền gửi nhiều nhất vào ngân hàng trong năm 2017 (nhằm mục đích tri ân khách hàng)

select Cust_name ,(t_amount) AS N'số tiền gửi nhiều nhất 2017 '
from Branch JOIN customer ON customer.Br_id = Branch.BR_id
			JOIN  account ON customer.Cust_id=account.cust_id
			JOIN transactions ON  account.Ac_no=transactions.ac_no 
where YEAR(T_DATE) = 2017 AND t_type = 1 
						 AND t_amount >= all (select t_amount
											  from Branch JOIN customer ON customer.Br_id = Branch.BR_id
																		JOIN  account ON customer.Cust_id=account.cust_id
																		JOIN transactions ON  account.Ac_no=transactions.ac_no 
											  where YEAR(T_DATE) = 2017 AND t_type = 1)

--10. Tìm những khách hàng có cùng chi nhánh với ông Phan Nguyên Anh

select Cust_name 
from Branch join customer on customer.Br_id = Branch.BR_id
where Cust_name  not like  N'Phan Nguyên Anh'  
				and  branch.BR_id = (select BR_ID
									 from customer
									 where  Cust_name= N'Phan Nguyên Anh'  )

--11. Liệt kê những giao dịch thực hiện cùng giờ với giao dịch của ông Lê Nguyễn Hoàng Văn ngày 2016-12-02

select distinct Cust_name 
from Branch join customer on customer.Br_id = Branch.BR_id
			join  account on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no 
where Cust_name  not like  N'Lê Nguyễn Hoàng Văn'  
				and  DATEPART(hh, t_time) = (select DATEPART(hh, t_time)
									 from customer join  account	 on customer.Cust_id=account.cust_id
												   join transactions on  account.Ac_no=transactions.ac_no 
									 where  Cust_name= N'Lê Nguyễn Hoàng Văn' and t_date =' 2016/12/02' )

--12. Hiển thị danh sách khách hàng ở cùng thành phố với Trần Văn Thiện Thanh #####

select Cust_name 
from  customer
where Cust_name  not like  N'Trần Văn Thiện Thanh'  
				and  ltrim(right(Cust_ad,charindex(',',reverse(replace(cust_ad,'-',' ,')))-1)) like ( select ltrim(right(Cust_ad,charindex(',',reverse(replace(cust_ad,'-',' ,')))-1))
									from customer
									where Cust_name =N'Trần Văn Thiện Thanh'  )



--13. Tìm những giao dịch diễn ra cùng ngày với giao dịch có mã số 0000000217

select t_id, t_date
from transactions
where t_id <> 0000000217 and DATEPART(dd, t_date) = (select DATEPART(dd, t_date)
							   from transactions
							   where t_id =0000000217 )

--14. Tìm những giao dịch cùng loại với giao dịch có mã số 0000000387

select t_id, t_type
from transactions
where t_id <> 0000000387 and t_type = (select t_type
									 from transactions
									 where t_id = 0000000387 )


--15. Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh Đà Nẵng

select distinct BR_name
from Branch join customer on customer.Br_id = Branch.BR_id
			join  account on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no 
where MONTH(t_date) = 12 and YEAR(t_date) = 2015 and t_type=1
group by BR_name
having COUNT(t_id) > (select COUNT(t_id)
						from Branch join customer on customer.Br_id = Branch.BR_id
									join  account on customer.Cust_id=account.cust_id
									join transactions on  account.Ac_no=transactions.ac_no 
									where MONTH(t_date) = 12 and YEAR(t_date) = 2015 and t_type=1  and BR_name LIKE N'%Đà Nẵng')

--16. Hãy liệt kê những tài khoảng trong vòng 6 tháng trở lại đây không phát sinh giao dịch #####

select account.Ac_no
from account  join transactions on  account.Ac_no=transactions.ac_no 
where datediff(MONTH, t_date, getdate()) <= 6 and
	 account.Ac_no not in (select account.Ac_no
							from   account join transactions on  account.Ac_no=transactions.ac_no 
							where datediff(MONTH, t_date, getdate()) <= 6 )

--17. Ông Phạm Duy Khánh thuộc chi nhánh nào? Từ 01/2017 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch gửi tiền vào ngân hàng với tổng số tiền là bao nhiêu. ###### 

select Branch.BR_name,  count(t_amount) as N'Số lượng giao dịch gửi tiền ' , sum(t_amount) as N'Tổng số tiền '
from  Branch join customer on customer.Br_id = Branch.BR_id
									join  account on customer.Cust_id=account.cust_id
									join transactions on  account.Ac_no=transactions.ac_no 
where Cust_name= N'Phạm Duy Khánh' and t_type =1 
								   and year(t_date) > 2016 
group by Branch.BR_name

--18. Thống kê giao dịch theo từng năm, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình

select year(t_date), count(t_id) N'Số lượng giao dịch' , avg(t_amount) N'Lượng tiền giao dịch trung bình'
from transactions
group by datepart(yy, t_date)

--19. Thống kê số lượng giao dịch theo ngày và đêm trong năm 2017 ở chi nhánh Hà Nội, Sài Gòn ####

select BR_name, count(t_id) SOLUONG
from  Branch join customer on customer.Br_id = Branch.BR_id
									join  account on customer.Cust_id=account.cust_id
									join transactions on  account.Ac_no=transactions.ac_no 
where year(t_date) = 2017  and BR_name like N'%Hà Nội%' or BR_name like N'%Sài Gòn%' 
group by BR_name


--20. Hiển thị danh sách khách hàng chưa thực hiện giao dịch nào trong năm 2017?

select distinct  customer.Cust_id, Cust_name
from customer left outer join  account on customer.Cust_id=account.cust_id
									left outer join transactions on  account.Ac_no=transactions.ac_no 
where Cust_name not in (select distinct Cust_name
from customer left outer join  account on customer.Cust_id=account.cust_id
									left outer join transactions on  account.Ac_no=transactions.ac_no   
									where year(t_date) =2017)

--21. Hiển thị những giao dịch trong mùa xuân của các chi nhánh miền trung.
--Gợi ý: giả sử một năm có 4 mùa, mỗi mùa kéo dài 3 tháng; chi nhánh miền trung có mã chi nhánh bắt đầu bằng VT.

select Branch.BR_id, transactions.t_id, t_type, t_amount, t_date, t_time 
from  Branch join customer     on customer.Br_id = Branch.BR_id
			 join  account     on customer.Cust_id=account.cust_id
			 join transactions on  account.Ac_no=transactions.ac_no 
where Branch.BR_id like 'VT%' and month(t_date) between 1 and 3

--22. Hiển thị họ tên và các giao dịch của khách hàng sử dụng số điện thoại có 3 số đầu là 093 và 2 số cuối là 02.

SELECT  Cust_name, Cust_phone, transactions.t_id,t_amount
FROM customer   join  account     on customer.Cust_id=account.cust_id
			 join transactions on  account.Ac_no=transactions.ac_no 
WHERE Cust_phone  LIKE '093%' and Cust_phone  LIKE '%02'

--23. Hãy liệt kê 2 chi nhánh làm việc kém hiệu quả nhất trong toàn hệ thống (số lượng giao dịch gửi tiền ít nhất) trong quý 3 năm 2017

select top 2 (count(t_amount)) , BR_name
from Branch join customer     on customer.Br_id = Branch.BR_id
			join  account     on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no
where t_type = 1 and datepart(qq, t_date) =3 and year(t_date)=2017 
group by Branch.BR_id, BR_name
order by count(t_amount) 

--24. Hãy liệt kê 2 chi nhánh có bận mải nhất hệ thống (thực hiện nhiều giao dịch gửi tiền nhất) trong năm 2017.

select top 2 (count(t_amount))  , BR_name
from Branch join customer     on customer.Br_id = Branch.BR_id
			join  account     on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no
where t_type = 1 and year(t_date)=2017 
group by Branch.BR_id, BR_name
order by count(t_amount) desc

--25. Tìm giao dịch gửi tiền nhiều nhất trong mùa đông. Nếu có thể, hãy đưa ra tên của người thực hiện giao dịch và chi nhánh. ####

select top 1 (count(t_amount)) , BR_name
from Branch join customer     on customer.Br_id = Branch.BR_id
			join  account     on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no
where t_type = 1 and year(t_date)=2017 
group by Branch.BR_id, BR_name
order by count(t_amount) desc

--26. Để bổ sung nhân sự cho các chi nhánh, cần có kết quả phân tích về cường độ làm việc của họ. 
--Hãy liệt kê những chi nhánh phải làm việc qua trưa và loại giao dịch là gửi tiền.

select distinct BR_name, t_time
from Branch join customer     on customer.Br_id = Branch.BR_id
			join  account     on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no
where DATEPART(hh, t_time) between 11 and 13 and t_type=1

--27. Hãy liệt kê các giao dịch bất thường. Gợi ý: là các giao dịch gửi tiền những được thực hiện ngoài khung giờ làm việc và cho phép overtime (từ sau 16h đến trước 7h) ###

select t_id, t_amount, t_time
from transactions
where DATEPART(hh, t_time) between 11 and 13

--28. Hãy điều tra những giao dịch bất thường trong năm 2017. Giao dịch bất thường là giao dịch diễn ra trong khoảng thời gian từ 12h đêm tới 3 giờ sáng.

select t_id, t_amount, t_date, t_time
from transactions
where  (year( t_date) =2017 and(DATEPART(hh, t_time) = 12) )or( year( t_date) =2017 and(DATEPART(hh, t_time) between 1 and 2 ) )

--29. Có bao nhiêu người ở Đắc Lắc sở hữu nhiều hơn một tài khoản?

select customer.Cust_name, count( account.cust_id) N'Số lượng tài khoản'
from  customer join  account     on customer.Cust_id=account.cust_id
where Cust_ad  like N'%ĐĂK LĂK%' or Cust_ad  like N'%ĐĂKLĂK%'
group by customer.Cust_name,account.cust_id
having count( account.cust_id) >1

--30. Nếu mỗi giao dịch rút tiền ngân hàng thu phí 3.000 đồng, hãy tính xem tổng tiền phí thu được từ thu phí dịch vụ từ năm 2012 đến năm 2017 là bao nhiêu?

select count(t_id) * 3000 as N'Tổng tiền phí thu được'
from transactions
where (DATEPART(yy, t_date) between 2012 and 2017) and t_type= 0

--31. Hiển thị thông tin các khách hàng họ Trần theo các cột sau:Mã KH Họ Tên Số dư tài khoản

select customer.Cust_id N'Mã KH' , Cust_name N'Họ Tên', ac_balance as N'Số dư tài khoản' 
from customer join  account   on customer.Cust_id=account.cust_id
where Cust_name like N'Trần%'
 
-- 32.  Cuối mỗi năm, nhiều khách hàng có xu hướng rút tiền khỏi ngân hàng để chuyển sang ngân hàng khác hoặc chuyển sang hình thức tiết kiệm khác. #####
--Hãy lọc những khách hàng có xu hướng rút tiền khỏi ngân hàng bằng hiển thị những người rút gần hết tiền trong tài khoản
--(tổng tiền rút trong tháng 12/2017 nhiều hơn 100 triệu và số dư trong tài khoản còn lại <= 100.000)

select Cust_name
from customer join  account      on customer.Cust_id=account.cust_id
			  join transactions  on  account.Ac_no=transactions.ac_no
where month(t_date) =2 and year(t_date)=2017 
group by Cust_name


--33. Thời gian vừa qua, hệ thống CSDL của ngân hàng bị hacker tấn công (giả sử tí cho vui J), tổng tiền trong tài khoản bị thay đổi bất thường.
--Hãy liệt kê những tài khoản bất thường đó. Gợi ý: tài khoản bất thường là tài khoản có tổng tiền gửi – tổng tiền rút <> số tiền trong tài khoản

select distinct Cust_name
from   customer join  account      on customer.Cust_id=account.cust_id
			  join transactions    on  account.Ac_no=transactions.ac_no
where	account.ac_balance <>
		(  (select sum(t_amount)
			from transactions
			where t_type=1)
		-
			(select sum(t_amount)
			 from transactions
			 where t_type=0))
	

--34.  Do hệ thống mạng bị nghẽn và hệ thống xử lý chưa tốt phần điều khiển đa người dùng nên một số tài khoản bị invalid.
--Hãy liệt kê những tài khoản đó. Gợi ý: tài khoản bị invalid là những tài khoản có số tiền âm. 
--Nếu có thể hãy liệt kê giao dịch gây ra sự cố tài khoản âm.
--Giao dịch đó được thực hiện ở chi nhánh nào? (mục đích để quy kết trách nhiệm J)

select Cust_name,account.Ac_no,ac_balance, t_id, t_amount, t_date, BR_name
from Branch join customer     on customer.Br_id = Branch.BR_id
			join  account     on customer.Cust_id=account.cust_id
			join transactions on  account.Ac_no=transactions.ac_no
where ac_balance <0

--35. (Giả sử) Gần đây, một số khách hàng ở chi nhánh Đà Nẵng kiện rằng: tổng tiền trong tài khoản không khớp với số tiền họ thực hiện giao dịch.
--Hãy điều tra sự việc này bằng cách hiển thị danh sách khách hàng ở Đà Nẵng bao gồm các thông tin sau: 
--mã khách hàng, họ tên khách hàng, tổng tiền đang có trong tài khoản, tổng tiền đã gửi, tổng tiền đã rút, 
--kết luận (nếu tổng tiền gửi – tổng tiền rút = số tiền trong tài khoản à OK, trường hợp còn lại à có sai)



--36. Ngân hàng cần biết những chi nhánh nào có nhiều giao dịch rút tiền vào buổi chiều để chuẩn bị chuyển tiền tới.
--Hãy liệt kê danh sách các chi nhánh và lượng tiền rút trung bình theo ngày 
--(chỉ xét những giao dịch diễn ra trong buổi chiều), sắp xếp giảm giần theo lượng tiền giao dịch.



