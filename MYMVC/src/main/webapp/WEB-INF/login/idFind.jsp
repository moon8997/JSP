<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    String ctxPath = request.getContextPath();
    //    /MyMVC
%>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/style.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 

<script type="text/javascript">  //제이쿼리
	
	$(document).ready(function(){ 
		//넘어온것이 겟이라면 감춰라
		const method = "${requestScope.method}";     //변수는 입력받은 데이타타입에의해 결정된다  //넘겨주는게 포스트아님 겟이기 때문에 ""${requestScope.method}""
		//console.log("method => " + method);
		
		if( method == "GET") {  //찍어본 메소드가 겟이라면 폼태그만 나옴
		     $("div#div_findResult").hide();
		} 
		else if(method == "POST") {
			$("input#name").val("${requestScope.name}");
			$("input#email").val("${requestScope.email}");
		}
		
		$("button#btnFind").click(function(){
				
			goFind();
		});
		
		$("input#email").bind("keydown", function(event){
			
			if(event.keyCode == 13) {
				goFind();
			}
			
		});
		
		
		
	});// end of $(document).ready(function()--------------------
			
	
    // Function Declration 
      function goFind() {
    	//성명 및 email에 대한 유효성 검사(정규표현식)는 생략하겠습니다.
    	
    	  const frm = document.idFindFrm;
			frm.action = "<%= ctxPath%>/login/idFind.up";
			frm.method = "post";
			frm.submit();
	}
</script>

<form name="idFindFrm">
   
   <ul style="list-style-type: none">
         <li style="margin: 25px 0">
            <label for="name" style="display: inline-block; width: 90px">성명</label>
            <input type="text" name="name" id="name" size="25" placeholder="홍길동" autocomplete="off" required />
         </li>
         <li style="margin: 25px 0">
            <label for="email" style="display: inline-block; width: 90px">이메일</label>
            <input type="text" name="email" id="email" size="25" placeholder="abc@def.com" autocomplete="off" required />
         </li>
   </ul>
   
   <div class="my-3">
    <p class="text-center">
       <button type="button" class="btn btn-success" id="btnFind">찾기</button>
    </p>
   </div>
   
   <div class="my-3" id="div_findResult">   <!--  //겟방식이면 얘는 보이지마 -->
        <p class="text-center">     
           ID : <span style="color: red; font-size: 16pt; font-weight: bold;">${requestScope.userid}</span> 
      </p>
   </div>
   
</form>


