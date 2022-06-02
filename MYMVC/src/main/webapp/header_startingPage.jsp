<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<%
    String ctxPath = request.getContextPath();
    //    /semi_prj_shoes
%>
<!DOCTYPE html>
<html>
<head>

<title>:::HOMEPAGE:::</title>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.0-dist/css/bootstrap.min.css" > 

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- 직접 만든 CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/leejeongjun/index_startingPage.css" />

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js" ></script> 

<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.css" > 
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.js"></script>

<script type="text/javascript">
	
	$(document).ready(function(){
		$("#myModal").modal('show');	//페이지 열자마자 모달창 띄우기
	});
	
</script>

<!-- 구글 글꼴 임포트 -->
<style>
@import url('https://fonts.googleapis.com/css2?family=Anton&family=Black+Han+Sans&display=swap');
</style>

</head>

<body>

<script>
function openNav() {
  document.getElementById("mySidebar").style.width = "250px";
  document.getElementById("main").style.marginLeft = "250px";
}

function closeNav() {
  document.getElementById("mySidebar").style.width = "0";
  document.getElementById("main").style.marginLeft= "0";
}

function openNav1() {
  document.getElementById("mySidebar1").style.width = "250px";
  document.getElementById("main1").style.marginLeft = "250px";
}

function closeNav1() {
  document.getElementById("mySidebar1").style.width = "0";
  document.getElementById("main1").style.marginLeft= "0";
}

function openNav2() {
  document.getElementById("mySidebar2").style.width = "250px";
  document.getElementById("main2").style.marginLeft = "250px";
}

function closeNav2() {
  document.getElementById("mySidebar2").style.width = "0";
  document.getElementById("main2").style.marginLeft= "0";
}
</script>

<%-- 사이드바 시작 --%>
<div id="mySidebar" class="sidebar">
  <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">×</a>
  <a href="#">상품전체보기</a>
  <a href="#">신상품보기</a>
  <a href="#">베스트셀러</a>
  <a href="#">추천상품</a>
</div>

<div id="mySidebar1" class="sidebar">
  <a href="javascript:void(0)" class="closebtn" onclick="closeNav1()">×</a>
  <a href="#">1대1문의</a>
  <a href="#">자주하는질문</a>
  <a href="#">반품/교환게시판</a>
  <a href="#">고객센터</a>
  <a href="#">매장찾기</a>
</div>

<div id="mySidebar2" class="sidebar">
  <a href="javascript:void(0)" class="closebtn" onclick="closeNav2()">×</a>
  <a href="#">상품관리</a>
  <a href="#">게시판관리</a>
  <a href="#">회원관리</a>
</div>
<%-- 사이드바 끝 --%>

<%-- 모달창 부분 --%>
<div class="modal" id="myModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content bg-dark">
            <div class="modal-header">
                <h5 class="modal-title text-white" style="font-size: 17pt; font-weight: bold;">배송지연 안내!</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body text-white">
                <p style="font-weight: bold; font-size: 14pt">현재 CJ대한통운 택배사의 단체파업으로 인해</p>
                <p>배송이 지연되거나 배송이 불가한 지역이 발생하는 상황입니다.</p>
                <p>아래에 명시된 지역은 배송이 지연되거나 불가한 지역이니</p>
                <p>양해부탁드립니다.</p>
                <p class="bg-danger text-white figure-caption text-center" style="font-weight: bold; font-size: 15pt;">배송 지연 및 불가 지역</p>
                <p></p>
                <p class="figure-caption text-center" style="font-size: 12pt; font-weight: bold;">충청북도: 청주시, 충주시</p>
                <p class="figure-caption text-center" style="font-size: 12pt; font-weight: bold;">부산광역시 전지역</p>
                <p class="figure-caption text-center" style="font-size: 12pt; font-weight: bold;">강원도 전지역</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal" style="font-weight: bold; ">확인</button>
            </div>
        </div>
    </div>
</div>
<%-- 모달창 부분 끝--%>

<%-- 상단 네비게이션 시작 --%>
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top mx-4 py-3">
	<!-- Brand/logo --> <!-- Font Awesome 5 Icons -->
	<a class="navbar-brand" href="<%= ctxPath%>/index.up" ><img src="<%= ctxPath %>/images/leejeongjun/logo1.png" /></a>
	
	<!-- 아코디언 같은 Navigation Bar 만들기 -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
	
	<div class="collapse navbar-collapse" id="collapsibleNavbar">
	  <ul class="navbar-nav mr-auto" style="font-size: 16pt;">
	     <li class="nav-item active">
	        <a id="menulist" class="nav-link menufont_size" href="#">
	        	<span id="main">
				  <button class="openbtn" onclick="openNav()">신발</button>  
				</span>
	        </a>
	     </li>
	     <li class="nav-item active">
	     	<a id="menulist" class="nav-link menufont_size" href="#">
	     		<span id="main1">
				  <button class="openbtn" onclick="openNav1()">게시판</button>  
				</span>
	     	</a>
	     </li>
	     
	     <li class="nav-item active">
	     	<a id="menulist" class="nav-link menufont_size" href="#">
	     		<span id="main2">
				  <button class="openbtn" onclick="openNav2()">관리자</button>  
				</span>
	     	</a>
	     </li>

         </ul>
         
	        <a class="navbar-brand" href="#"><i class="far fa-user"></i></a>
			<a class="navbar-brand" href="#"><i class="fas fa-cart-plus"></i></a>
			<a class="navbar-brand" href="#"><i class="far fa-heart"></i></a>
			<a class="navbar-brand" href="#"><i class="fas fa-info-circle"></i></a>
	     
	
		 
		  <form class="form-inline my-2 my-lg-0"> <!-- .form-inline 이것은 너비가 최소 576px인 뷰포트 내의 양식에만 적용됩니다. 576px보다 작은 화면에서는 세로방향으로 쌓입니다. -->
            <div class="form-group" style="margin-right: 10px">
            	<input class="form-control type="text" placeholder="검색어 입력하세요!">
            </div>
            <button class="btn btn-success" type="submit">검색</button>
          </form>
	
	</div>
</nav>
<%-- 상단 네비게이션 끝 --%>