<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
   // 컨텍스트 패스명(context path name)을 알아오고자 한다.
   String ctxPath = request.getContextPath();
   
 // System.out.println("ctxPath => " + ctxPath);
 // ctxPath => /JSPServletBegin     <== WAS(톰캣서버) Document Base Path 설정의 기본값임.
 // ctxPath => /aaa		            <== WAS(톰캣서버) Document Base Path 설정을  /aaa 으로 변경한 경우임. 
 // ctxPath => 	 (아무글자도 없는 것임)  <== WAS(톰캣서버) Document Base Path 설정을  / 으로 변경한 경우임.	
%>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개인성향 정보 수정하기</title>

<style type="text/css">
	ul {list-style-type: none;}
	li {line-height: 200%;}
</style>

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.6.0.min.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
		
		// 1. 성명 입력해주기
		$("input#name").val("${requestScope.psdto.name}");
		
		// 2. 학력 입력해주기
		$("select#school").val("${requestScope.psdto.school}");
		
		// 3. 색상 입력해주기
		const color = "${requestScope.psdto.color}";
	 //	console.log("확인용 color => " + color);
		
		$("input:radio[name='color']").each(function(index, item){
			
		//	console.log("확인용 value => " + $(item).attr("value") );
		/*
		        확인용 value => red
				확인용 value => blue
				확인용 value => green
				확인용 value => yellow
		*/
		    
		    if( $(item).attr("value") == color ) {
		    	$(item).prop("checked", true);
		    	return false;  // for 문의 break; 와 같은 뜻이다.
		    }
			
		});
		
		
		// 4. 음식 입력해주기
		const food = "${requestScope.psdto.strFood}";
	//	console.log("확인용 food => " + food);
		// 확인용 food => 짜장면,탕수육,팔보채
		// 확인용 food => 없음
		
		if(food != "없음") {
			const arr_food = food.split(",");
			//    arr_food ==> ["짜장면","탕수육","팔보채"];
			
			arr_food.forEach(function(item, index, array){
				
				$("input:checkbox[name='food']").each(function(idx, elt){
					if(item == $(elt).attr("value") ) {
						$(elt).prop("checked",true);
						return false;  // for 문의 break; 와 같은 뜻이다.
					}
				}); // end of $("input:checkbox[name='food']").each()---------------------- 
				
			}); // end of arr_food.forEach()-----------------------------------------------
		}
		
		
		// === 유효성 검사하기 시작 === //
		$("form[name='myFrm']").submit(function(){

			const name_length = $("input#name").val().trim().length;
			
			if(name_length == 0) {
				alert("성명을 입력하세요!!");
				return false;  // submit 을 하지 않고 종료한다.
			}
			
			
			const school_value = $("select#school").val();
			
			if(school_value == "") {
				alert("학력을 선택하세요!!");
				return false;  // submit 을 하지 않고 종료한다.
			}
			
			
			const color_checked_length = $("input:radio[name='color']:checked").length;
			
			if(color_checked_length == 0) {
				alert("좋아하는 색상을 선택하세요!!");
				return false;  // submit 을 하지 않고 종료한다.
			}
			
		/*	
            const food_checked_length = $("input:checkbox[name='food']:checked").length;
			
			if(food_checked_length == 0) {
				alert("좋아하는 음식을 1개이상 선택하세요!!");
				return false;  // submit 을 하지 않고 종료한다.
			}
		*/	
			
		});
		// === 유효성 검사하기 끝 === //
		
	}); // end of $(document).ready(function(){})---------------------------

</script>

</head>
<body>

      <form name="myFrm" action="<%= ctxPath%>/personUpdateEnd.do" method="post">
	      <fieldset>
			<legend>${requestScope.psdto.name}님 성향 정보 수정하기</legend>
			<ul>
				<li>
					<input type="hidden" name="seq" value="${requestScope.psdto.seq}" readonly />
					<label for="name">성명</label>
					<input type="text" name="name" id="name" placeholder="성명입력"/> 
				</li>
				<li>
					<label for="school">학력</label>
					<select name="school" id="school">
						<option value="">선택하세요</option>
						<option>고졸</option>
						<option>초대졸</option>
						<option>대졸</option>
						<option>대학원졸</option>
					</select>
				</li>
				<li>
					<label for="">좋아하는 색상</label>
					<div>
						<label for="red">빨강</label>
						<input type="radio" name="color" id="red" value="red" />
						
						<label for="blue">파랑</label>
						<input type="radio" name="color" id="blue" value="blue" />
						
						<label for="green">초록</label>
						<input type="radio" name="color" id="green" value="green" />
						
						<label for="yellow">노랑</label>
						<input type="radio" name="color" id="yellow" value="yellow" />
					</div>
				</li>
				<li>
					<label for="">좋아하는 음식(다중선택)</label>
					<div>
					    <label for="food1">짜짱면</label>
						<input type="checkbox" name="food" id="food1" value="짜장면" />
						&nbsp;
						
						<label for="food2">짬뽕</label>
						<input type="checkbox" name="food" id="food2" value="짬뽕" />
						&nbsp;
						
						<label for="food3">탕수육</label>
						<input type="checkbox" name="food" id="food3" value="탕수육" />
						&nbsp;
						
						<label for="food4">양장피</label>
						<input type="checkbox" name="food" id="food4" value="양장피" />
						&nbsp;
						
						<label for="food5">팔보채</label>
						<input type="checkbox" name="food" id="food5" value="팔보채" />
					</div>
				</li>
				<li>
					<input type="submit" value="수정" />
					<input type="reset" value="취소" />
				</li>
			</ul>
		</fieldset>
      </form>

</body>
</html>