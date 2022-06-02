<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />
   
<style type="text/css" >
   table#tblCartList {width: 90%;
                      border: solid gray 1px;
                      margin-top: 20px;
                      margin-left: 10px;
                      margin-bottom: 20px;}
                      
   table#tblCartList th {border: solid gray 1px;}
   table#tblCartList td {border: dotted gray 1px;} 
   
   /* CSS 로딩 구현 시작(bootstrap 에서 가져옴) */
   .loader {
	  border: 16px solid #f3f3f3;
	  border-radius: 50%;
	  border-top: 16px solid red;
	  border-bottom: 16px solid blue;
	  width: 120px;
	  height: 120px;
	  -webkit-animation: spin 2s linear infinite; /* Safari */
	  animation: spin 2s linear infinite;
	}
	
	/* Safari */
	@-webkit-keyframes spin {
	  0% { -webkit-transform: rotate(0deg); }
	  100% { -webkit-transform: rotate(360deg); }
	}
	
	@keyframes spin {
	  0% { transform: rotate(0deg); }
	  100% { transform: rotate(360deg); }
	}
    /* CSS 로딩 구현 끝(bootstrap 에서 가져옴) */ 
    
</style>

<script type="text/javascript">

	$(document).ready(function(){
		
		$(".loader").hide(); // CSS 로딩화면 감추기
		
		$(".spinner").spinner({
			spin: function(event, ui) {
				const $target = $(event.target);
				
				if(ui.value > 100) {
					$target.spinner("value", 100);
					return false;
				}
				else if(ui.value < 0) {
					$target.spinner("value", 0);
					return false;
				}
			}
		});// end of $(".spinner").spinner({});-----------------
		
				
		// 제품번호의 모든 체크박스가 체크가 되었다가 그 중 하나만 이라도 체크를 해제하면 전체선택 체크박스에도 체크를 해제하도록 한다.
		$(".chkboxpnum").click( ()=>{
			
			let bFlag = false;
			
			$(".chkboxpnum").each( (index, item)=>{
				const bChecked = $(item).prop("checked");
				if(!bChecked) {
					$("#allCheckOrNone").prop("checked",false);
					bFlag = true;
					return false;
				}
			});
			
			if(!bFlag) {
				$("#allCheckOrNone").prop("checked",true);
			}
			
		});
		
	}); // end of $(document).ready()--------------------------
	
	
	// Function declaration
	
	function allCheckBox() {
	
		const bool = $("#allCheckOrNone").is(":checked");
		/*
		   $("#allCheckOrNone").is(":checked"); 은
		     선택자 $("#allCheckOrNone") 이 체크되어지면 true를 나타내고,
		     선택자 $("#allCheckOrNone") 이 체크가 해제되어지면 false를 나타내어주는 것이다.
		*/
		
		$(".chkboxpnum").prop("checked", bool);
	}// end of function allCheckBox()-------------------------
	
	
	// === 장바구니 현재주문수량 수정하기 === // 
	function goOqtyEdit(obj, userid) {
		
		const index = $("button.updateBtn").index(obj);
	//	alert(index);
		
		const cartno = $("input.cartno").eq(index).val();
    //  alert("장바구니번호 : " + cartno);	
		
		const oqty = $("input.oqty").eq(index).val();
	//	alert("주문량 : " + oqty);
		
		const regExp = /^[0-9]+$/g; // 숫자만 체크하는 정규표현식
		const bool = regExp.test(oqty);
	
		if(!bool) {
			alert("수정하시려는 수량은 0개 이상이어야 합니다.");
			location.href="javascript:history.go(0);";
			return;
		}
				
	//  alert("장바구니번호 : " + cartno + "\n주문량 : " + oqty);
	
		if(oqty == "0") {
			goDel(cartno, userid);
		}
		else {
			$.ajax({
					url:"<%= request.getContextPath()%>/shop/cartEdit.up",
					type:"POST",
					data:{"cartno":cartno,
						  "oqty":oqty,
						  "userid":userid},
					dataType:"JSON",
					success:function(json){
						if(json.n == 1) {
							alert("주문수량이 변경되었습니다.");	
							location.href = "cartList.up"; 
						}
					},
					error: function(request, status, error){
						alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					}
				});
		}
	 
	}// end of function goOqtyEdit(obj)-----------------
	
	
	// === 장바구니에서 특정 제품을 비우기 === //  
	function goDel(cartno, userid) {
		
		const $target = $(event.target);
		const pname = $target.parent().parent().find(".cart_pname").text();
		const bool = confirm(pname+"을 장바구니에서 제거하시는 것이 맞습니까?");
	
		if(bool) {
			$.ajax({
				url:"<%= request.getContextPath()%>/shop/cartDel.up",
				type:"POST",
				data:{"cartno":cartno
					 ,"userid":userid},
				dataType:"JSON",
				success:function(json){
					if(json.n == 1) { 
					   location.href = "cartList.up"; 
					}
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});
			
		}
		else {
			alert("장바구니에서 "+pname+" 제품 삭제를 취소하셨습니다.");
		}
		
	}// end of function goDel(cartno)---------------------------
	
	
	// === 장바구니에서 제품 주문하기 === // 
	function goOrder() {
	    
		///// == 체크박스의 체크된 갯수(checked 속성이용) == /////
	    const checkCnt = $("input:checkbox[name=pnum]:checked").length;
	    
		if(checkCnt < 1) {
	    	alert("주문하실 제품을 선택하세요!!");
	    	return; // 종료 
	    }
	    
	    else { 
	   		//// == 체크박스에서 체크된 value값(checked 속성이용) == ////
	   		///  == 체크가 된 것만 값을 읽어와서 배열에 넣어준다. /// 
		        const allCnt = $("input:checkbox[name=pnum]").length;
	   		
	   			const pnumArr = new Array();
				const oqtyArr = new Array();
				const cartnoArr = new Array();
				const totalPriceArr = new Array();
				const totalPointArr = new Array();
			    
		    	for(let i=0; i<allCnt; i++) {
		    	/*  if( $("input:checkbox[name=pnum]").eq(i).prop("checked") ) 
		    	    또는	 
		    	*/
		    	    if( $("input:checkbox[name=pnum]").eq(i).is(":checked") ) { 	
						pnumArr.push( $("input:checkbox[name=pnum]").eq(i).val() );
						oqtyArr.push( $(".oqty").eq(i).val() );
						cartnoArr.push( $(".cartno").eq(i).val() );
						totalPriceArr.push( $(".totalPrice").eq(i).val() );
						totalPointArr.push( $(".totalPoint").eq(i).val() );
					}
				}// end of for---------------------------
					
				for(let i=0; i<checkCnt; i++) {
					console.log("확인용 제품번호: " + pnumArr[i] + ", 주문량: " + oqtyArr[i] + ", 장바구니번호 : " + cartnoArr[i] + ", 주문금액: " + totalPriceArr[i] + ", 포인트: " + totalPointArr[i]);
				/*
				        확인용 제품번호: 3, 주문량: 3, 장바구니번호 : 14, 주문금액: 30000, 포인트: 15
				        확인용 제품번호: 56, 주문량: 2, 장바구니번호: 13, 주문금액: 2000000, 포인트 : 120 
				        확인용 제품번호: 59, 주문량: 3, 장바구니번호: 11, 주문금액: 30000, 포인트 : 300    
				*/
				}// end of for---------------------------
				
				const pnumjoin = pnumArr.join();             // "3,56,59"
				const oqtyjoin = oqtyArr.join();             // "3,2,3"
				const cartnojoin = cartnoArr.join();         // "14,13,11"
				const totalPricejoin = totalPriceArr.join(); // "30000,2000000,30000"

				let sumtotalPrice = 0;
				for(let i=0; i<totalPriceArr.length; i++) {
					sumtotalPrice += parseInt(totalPriceArr[i]);
				}

				let sumtotalPoint = 0;
				for(let i=0; i<totalPointArr.length; i++) {
					sumtotalPoint += parseInt(totalPointArr[i]);
				}
				
				console.log("확인용 pnumjoin : " + pnumjoin);             // 확인용 pnumjoin : 3,56,59
				console.log("확인용 oqtyjoin : " + oqtyjoin);             // 확인용 oqtyjoin : 3,2,3
				console.log("확인용 cartnojoin : " + cartnojoin);         // 확인용 cartnojoin : 14,13,11
				console.log("확인용 totalPricejoin : " + totalPricejoin); // 확인용 totalPricejoin : 30000,2000000,30000
				console.log("확인용 sumtotalPrice : " + sumtotalPrice);   // 확인용 sumtotalPrice : 2060000
				console.log("확인용 sumtotalPoint : " + sumtotalPoint);   // 확인용 sumtotalPoint : 435
				
                const currentcoin = ${sessionScope.loginuser.coin};
                
                const str_sumtotalPrice = sumtotalPrice.toLocaleString('en'); // 자바스크립트에서 숫자 3자리마다 콤마 찍어주기  
			    const str_currentcoin = currentcoin.toLocaleString('en');     // 자바스크립트에서 숫자 3자리마다 콤마 찍어주기 
			    
				if( sumtotalPrice > currentcoin ) {
				    $("p#order_error_msg").html("코인잔액이 부족하므로 주문이 불가합니다.<br>주문총액 : "+str_sumtotalPrice+"원 / 코인잔액 : "+str_currentcoin+"원"); 
				    return;
				}
				
				else {
					
					const bool = confirm("총주문액 : "+str_sumtotalPrice+"원 결제하시겠습니까?");
					
					if(bool) {  
						$(".loader").show(); // CSS 로딩화면 보여주기
						
						$.ajax({
							url:"<%= request.getContextPath()%>/shop/orderAdd.up",
							type:"POST",
							data:{"pnumjoin":pnumjoin,
								  "oqtyjoin":oqtyjoin, 
								  "cartnojoin":cartnojoin,
								  "totalPricejoin":totalPricejoin,
								  "sumtotalPrice":sumtotalPrice,
								  "sumtotalPoint":sumtotalPoint},
							dataType:"JSON",	  
							success:function(json){
								if(json.isSuccess == 1) {
									location.href="<%= request.getContextPath()%>/shop/orderList.up";
								}
								else {
									location.href="<%= request.getContextPath()%>/shop/orderError.up";
								}
							},
							error: function(request, status, error){
								alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
							}
						});  
					}
				}	
		 
	   }
		
	}// end of function goOrder()----------------------
	
</script>

<div class="container-fluid" style="border: solid 0px red">
	<div class="my-3">
	   <p class="h4 text-center">&raquo;&nbsp;&nbsp;${(sessionScope.loginuser).name} [${(sessionScope.loginuser).userid}]님 장바구니 목록&nbsp;&nbsp;&laquo;</p>
	</div>
	<div>
	    <table id="tblCartList" class="mx-auto" style="width: 90%">
		   <thead>
			   <tr>
				 <th style="border-right-style: none;">
				     <input type="checkbox" id="allCheckOrNone" onClick="allCheckBox();" />
				     <span style="font-size: 10pt;"><label for="allCheckOrNone">전체선택</label></span>
				 </th>
				 <th colspan="5" style="border-left-style: none; font-size: 12pt; text-align: center;">
				     <marquee>주문을 하시려면 먼저 제품번호를 선택하신 후 [주문하기] 를 클릭하세요</marquee>
				 </th>
			   </tr>
		   
			   <tr style="background-color: #cfcfcf;">
				  <th style="width:10%; text-align: center; height: 30px;">제품번호</th>
				  <th style="width:23%; text-align: center;">제품명</th>
			   	  <th style="width:17%; text-align: center;">현재주문수량</th>
			   	  <th style="width:20%; text-align: center;">판매가/포인트(개당)</th>
			   	  <th style="width:20%; text-align: center;">주문총액/총포인트</th>
			   	  <th style="width:10%; text-align: center;">비우기</th>
			   </tr>	
		   </thead>
		 
		   <tbody>
			   <c:if test="${empty requestScope.cartList}">
				   <tr>
				   	  <td colspan="6" align="center">
				   	    <span style="color: red; font-weight: bold;">
				   	    	장바구니에 담긴 상품이 없습니다.
				   	    </span>
				   	  </td>	
				   </tr>
			   </c:if>	
			   
			   <c:if test="${not empty requestScope.cartList}">
			      <c:forEach var="cartvo" items="${requestScope.cartList}" varStatus="status"> 
				       <tr>
			               <td> <%-- 체크박스 및 제품번호 --%>
			                    <%-- c:forEach 에서 선택자 id를 고유하게 사용하는 방법  
			                         varStatus="status" 을 이용하면 된다.
			                         status.index 은 0 부터 시작하고,
			                         status.count 는 1 부터 시작한다. 
			                    --%> 
			               	  <input type="checkbox" name="pnum" class="chkboxpnum" id="pnum${status.index}" value="${cartvo.pnum}" /> &nbsp;<label for="pnum${status.index}">${cartvo.pnum}</label>   
			               </td>
			               <td align="center"> <%-- 제품이미지1 및 제품명 --%> 
			                  <a href="/MyMVC/shop/prodView.up?pnum=${cartvo.pnum}">
			                  	<img src="/MyMVC/images/${cartvo.prod.pimage1}" class="img-thumbnail" width="130px" height="100px" />
			                  </a> 
			                  <br/><span class="cart_pname">${cartvo.prod.pname}</span> 
			               </td>
			               <td align="center"> 
			                   <%-- 현재주문수량 --%>
			               	   <input class="spinner oqty" name="oqty" value="${cartvo.oqty}" style="width: 30px; height: 20px;">개
			               	   <button class="btn btn-outline-secondary btn-sm updateBtn" type="button" onclick="goOqtyEdit(this,'${cartvo.userid}')">수정</button>
			               	   
			               	   <%-- 장바구니 테이블에서 특정제품의 현재주문수량을 변경하여 적용하려면 먼저 장바구니번호(시퀀스)를 알아야 한다 --%>
			               	   <input type="hidden" class="cartno" value="${cartvo.cartno}" /> 
			               </td>
			               <td align="right"> <%-- 판매가/포인트(개당) --%> 
			                   <fmt:formatNumber value="${cartvo.prod.saleprice}" pattern="###,###" /> 원<br>
			                   <fmt:formatNumber value="${cartvo.prod.point}" pattern="###,###" /> POINT
			               </td>
			               <td align="right"> <%-- 주문총액/총포인트 --%> 
			                   <fmt:formatNumber value="${cartvo.prod.totalPrice}" pattern="###,###" /> 원<br>
			                   <fmt:formatNumber value="${cartvo.prod.totalPoint}" pattern="###,###" /> POINT
			                   <input type="hidden" class="totalPrice" value="${cartvo.prod.totalPrice}" />
			                   <input type="hidden" class="totalPoint" value="${cartvo.prod.totalPoint}" />
			               </td>
			               <td align="center"> <%-- 장바구니에서 해당 특정 제품 비우기 --%> 
			                   <button class="btn btn-outline-danger btn-sm" onclick="goDel('${cartvo.cartno}','${cartvo.userid}')">삭제</button>  
			               </td>
			           </tr>
			   	  </c:forEach>
			   </c:if>	
			   
			   <tr>
			   	  <td colspan="3" align="right">
			   	  	 <span style="font-weight: bold;">장바구니 총액 :</span>
			     	 <span style="color: red; font-weight: bold;"><fmt:formatNumber value="${requestScope.resultMap.SUMTOTALPRICE}" pattern="###,###" /></span> 원  
			   	  	 <br>
			   	  	 <span style="font-weight: bold;">총 포인트 :</span> 
			         <span style="color: red; font-weight: bold;"><fmt:formatNumber value="${requestScope.resultMap.SUMTOTALPOINT}" pattern="###,###" /></span> POINT 
			   	  </td>
			   	  <td colspan="3" align="center">
			         <button class="btn btn-outline-dark btn-sm mr-3" onclick="goOrder()">주문하기</button>
			   	     <a class="btn btn-outline-dark btn-sm" href="<%= request.getContextPath() %>/shop/mallHome1.up" role="button">계속쇼핑</a>
			   	  </td>
			   </tr>
			   
			</tbody>
		</table> 
	</div>
	
    <div>
     	<p id="order_error_msg" class="text-center text-danger font-weight-bold h4"></p>
    </div>
    
    <%-- CSS 로딩화면 구현한 것 --%>
    <div style="display: flex">
    	<div class="loader" style="margin: auto"></div>
    </div>
      
 </div>
    
<jsp:include page="../footer2.jsp" />  
  