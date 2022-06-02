<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 표준액션 중 forward 에 대해서 알아봅니다.</title>
</head>
<body>
	<h2>입력한 두개의 수 사이를 누적한 값 알아오기</h2>

	<form name="myFrm">
		<p>
         첫번째 수 : <input type="text" name="firstNum" size="5" maxlength="5" /><br/>
         두번째 수 : <input type="text" name="secondNum" size="5" maxlength="5" /><br/>
         <button type="button" onclick="goSubmit()">계산하기</button> 
		</p>
	</form>

	<script type="text/javascript">
	
		// Function declaration
		function goSubmit() {
			
			// 정규표현식으로 유효성 검사
			const regExp = /^[0-9]{1,5}$/;
			
			const frm = document.myFrm;
			const num1 = frm.firstNum.value.trim();
			const num2 = frm.secondNum.value.trim();
			
			if( !(regExp.test(num1) && regExp.test(num2)) ){
				alert("숫자로만 입력하세요!!")
				frm.firstNum.value = "";
				frm.secondNum.value = "";
				frm.firstNum.focus();
				return; // 종료
			}
			
			frm.action = "02forwardCalc_02.jsp";
		//	frm.method = "get"; // method 를 명기하지 않으면 기본값은 "get"이다.
			frm.submit();
				
		} // end of fucntion ------------------------------
	
	</script>

</body>
</html>