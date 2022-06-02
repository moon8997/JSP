<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>

<html lang="ko">

<head>
<meta charset="UTF-8">
<title>로그인창</title>
    
    <link rel="stylesheet" href="../css/wonhyejin/style.css">
</head>
    <body>
        <div class="memberbox">
            <h2>로그인</h2>
            <form action="#">
             
                <fieldset>
                    <legend>로그인 구역</legend>
                    <label for="loginid">아이디</label>
                    <input type="text" id="loginid" placeholder="아이디를 입력해 주세요">
                    <label for="loginpw">비밀번호</label>
                    <input type="password" id="loginpw" placeholder="비밀번호를 입력해 주세요">
	            	 <ul>
                       <li><a href="#">아이디/비밀번호찾기</a></li>
                        <li><a href="#">회원가입</a></li>
                    </ul>
	            	<button type="submit">로그인</button>
                    <ul>
                        <li><a href="#">비회원 주문조회</a></li> 
                    </ul>
                    
                    <div class="member_box_gift" style="line-height:400%">로그인 관련하여 궁금한 사항이 있으신가요?
                    <a href="#">[자주 묻는 질문 바로가기]</a>
			       </div>
                    
		           <div class="loginfail">
					 <p style="color:red;">잠깐! 계속 로그인에 실패하고 계신가요?</p><br>
						동일한 이메일로 2개 이상의 계정을 보유한 경우<br>원활한 서비스 이용이 어렵습니다.<br>
	                    지금 중복 계정 여부를 확인하고 사용하지 않는 계정은<br>탈퇴 신청을 해주세요.<br>  
	                    <button type="submit" style="position: relative; top: 10px;">중복 계정 여부 확인하기</button>
					</div>
					 </fieldset>
            </form>
				</div>
			
               
 
    </body>
</html>
