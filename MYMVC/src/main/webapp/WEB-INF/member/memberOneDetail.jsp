<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../header.jsp" />

<style type="text/css">

	div#mvoInfo {
		width: 60%; 
		text-align: left;
		border: solid 0px red;
		margin-top: 30px; 
		font-size: 13pt;
		line-height: 200%;
	}
	
	span.myli {
		display: inline-block;
		width: 90px;
		border: solid 0px blue;
	}
	
/* ============================================= */
	div#sms {
		margin: 0 auto; 
		/* border: solid 1px red; */ 
		overflow: hidden; 
		width: 50%;
		padding: 10px 0 10px 80px;
	}
	
	span#smsTitle {
		display: block;
		font-size: 13pt;
		font-weight: bold;
		margin-bottom: 10px;
	}
	
	textarea#smsContent {
		float: left;
		height: 100px;
	}
	
	button#btnSend {
		float: left;
		border: none;
		width: 50px;
		height: 100px;
		background-color: navy;
		color: white;
	}
	
	div#smsResult {
		clear: both;
		color: red;
		padding: 20px;
	}	

</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		$("div#smsResult").hide();
		
		$("button#btnSend").click( ()=>{
			
		//	console.log( $("input#reservedate").val() + " " + $("input#reservetime").val() );
		//  2022-04-05 11:20
		
		    let reservedate = $("input#reservedate").val();
		    reservedate = reservedate.split("-").join("");
		    
		    let reservetime = $("input#reservetime").val();
		    reservetime = reservetime.split(":").join("");
		    
		    const datetime = reservedate + reservetime;
		    
		 // console.log(datetime);
		 // 202204051120
		    
		    let dataObj;
		 
		    if( reservedate == "" || reservetime == "" ) {
		    	dataObj = {"mobile":"${requestScope.mvo.mobile}", 
		    			   "smsContent":$("textarea#smsContent").val()};
		    }
		    else {
		    	dataObj = {"mobile":"${requestScope.mvo.mobile}", 
		    			   "smsContent":$("textarea#smsContent").val(),
		    			   "datetime":datetime};
		    }
		    
		    $.ajax({
		    	url:"<%= request.getContextPath()%>/member/smsSend.up",
		    	type:"POST",
		    	data:dataObj,
		    	dataType:"json",
		    	success:function(json) {
		    		// json ??? {"group_id":"R2G1opcrod04ebmS","success_count":1,"error_count":0} ?????? ??????.
		    		
		    		if(json.success_count == 1) {
		    			$("div#smsResult").html("??????????????? ?????????????????????");
		    		}
		    		else if(json.error_count != 0) {
		    			$("div#smsResult").html("??????????????? ?????????????????????");
		    		}
		    		
		    		$("div#smsResult").show();
		    		$("textarea#smsContent").val("");
		    	},
		    	error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
		    });
			
		});
		
		///////////////////////////////////////////////////////
		
		
		
	});// end of $(document).ready(function(){})---------------------

	
	// Function Declaration
	function goMemberList() {
		let goBackURL = "${requestScope.goBackURL}";
	//	alert("????????? : " + goBackURL);
	//	????????? :  /member/memberList.up?currentShowPageNo=5 sizePerPage=10 searchType=name searchWord=???
			
	  // ???????????????????????????  replaceall ??? ?????? replace ?????? ??????.
      // !!! ???????????????????????? replace??? replaceall ?????? ???????????? !!! //
      
      // "korea kena" ==> "korea kena".replace("k","y") ==> "yorea kena"
      // "korea kena".replace(/k/gi, "y") ==> "yorea yena"  ????????? ????????? ?????? /"k"/ ????????? /k/ ??? ?????? "" ??? ????????? ??????.	
			
      // ?????? goBackURL ??? ?????? " "dmf ahen "&"??? ??????????????? ??????.
      	goBackURL = goBackURL.replace(/ /gi, "&");
   //    alert("??????????????? : " + goBackURL);
    //    ??????????????? : /member/memberList.up?currentShowPageNo=6&sizePerPage=10&searchType=name&searchWord=???
		location.href = "/MyMVC"+goBackURL;	
	}
	
</script>

<c:if test="${empty requestScope.mvo}">
	???????????? ?????? ???????????????.<br>
</c:if>

<c:if test="${not empty requestScope.mvo}">
	<c:set var="mobile" value="${requestScope.mvo.mobile}" />
	<c:set var="birthday" value="${requestScope.mvo.birthday}" />
	
	<h3>::: ${requestScope.mvo.name} ?????? ?????? ???????????? :::</h3>
	
	<div id="mvoInfo">
	   <ol>
	   	  <li><span class="myli">????????? : </span>${requestScope.mvo.userid}</li>
		  <li><span class="myli">????????? : </span>${requestScope.mvo.name}</li>
		  <li><span class="myli">????????? : </span>${requestScope.mvo.email}</li>
		  <li><span class="myli">????????? : </span>${fn:substring(mobile, 0, 3)}-${fn:substring(mobile, 3, 7)}-${fn:substring(mobile, 7, 11)}</li>
		  <li><span class="myli">???????????? : </span>${requestScope.mvo.postcode}</li>
		  <li><span class="myli">?????? : </span>${requestScope.mvo.address}&nbsp;${requestScope.mvo.detailaddress}&nbsp;${requestScope.mvo.extraaddress}</li>
		  <li><span class="myli">?????? : </span><c:choose><c:when test="${requestScope.mvo.gender eq '1'}">???</c:when><c:otherwise>???</c:otherwise></c:choose></li>   
		  <li><span class="myli">???????????? : </span>${fn:substring(birthday, 0, 4)}.${fn:substring(birthday, 4, 6)}.${fn:substring(birthday, 6, 8)}</li>
		  <li><span class="myli">?????? : </span>${requestScope.mvo.age}???</li>
		  <li><span class="myli">????????? : </span><fmt:formatNumber value="${requestScope.mvo.coin}" pattern="###,###" /> ???</li>  
		  <li><span class="myli">????????? : </span><fmt:formatNumber value="${requestScope.mvo.point}" pattern="###,###" /> POINT</li> 
		  <li><span class="myli">???????????? : </span>${requestScope.mvo.registerday}</li>
	   </ol>
	</div>
	
	<%-- ==== ????????? SMS(??????) ????????? ==== --%>
	<div id="sms" align="left">
	  	<span id="smsTitle">&gt;&gt;????????? SMS(??????) ????????? ?????? ?????????&lt;&lt;</span>
	  	<div style="margin: 10px 0 20px 0">
	  		???????????????&nbsp;<input type="date" id="reservedate" />&nbsp;<input type="time" id="reservetime" />
	  	</div>
	  	<textarea rows="4" cols="40" id="smsContent"></textarea>
	  	<button id="btnSend">??????</button>
	  	<div id="smsResult"></div>
	</div>
	
</c:if>

<div>
	<button style="margin-top: 50px;" type="button" onclick="javascript:history.back();">????????????[history.back()]</button>
	&nbsp;&nbsp;
	<button style="margin-top: 50px;" type="button" onclick="goMemberList()">????????????[???????????????]</button>
	&nbsp;&nbsp;
	<button style="margin-top: 50px;" type="button" onclick="javascript:location.href='memberList.up'">????????????[????????????]</button> 
</div>

<jsp:include page="../footer.jsp" />
    