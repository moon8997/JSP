package member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import common.controller.AbstractController;
import member.model.MemberVO;

public class LogoutAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
			
		//로그아웃 처리하기
		
		HttpSession session = request.getSession();// 세션불러오기
		
		/////////////////////////////////////////////////////////////////
		// 로그아웃을 하면 시작페이지로 가는 것이 아니라 방금 보았던 그 페이지로 그대로 가기 위한 것
		String goBackURL = (String) session.getAttribute("goBackURL");
		
		if(goBackURL != null ) {
			goBackURL = request.getContextPath()+goBackURL;
		}
		else {
			
		}
		
		
		////////////////////////////////////////////////////////////// 
		
		
		 super.setRedirect(true);
		 
		 if(goBackURL != null && !"admin".equals( ((MemberVO) session.getAttribute("loginuser")).getUserid()  )) {
			 // 관리자가 아닌 일반 사용자로 들어와서 돌아갈 페이지가 있다면
			 session.invalidate(); 
			 super.setViewPage(goBackURL);
		 }
		 else { 
			 // 돌아갈 페이지가 없거나 또는 관리자가 로x그아웃을 하면 무조건 /MyMVC/index.up 페이지로 돌아간다.
			 session.invalidate(); 
			 super.setViewPage(request.getContextPath()+"/index.up");  //ㅂ로그아웃되어지면 시작페이지로감
		 }
		
		// 첫번쨰 방법 : 세션을 그대로 존재하게 끔 해두고 세션에 저장되어진 어떤 값(지금은 로그인 되어진 회원객체)을 삭제하기
			// session.removeAttribute("loginuser");    
			 
			// 두번쨰 방법 : WAS 메모리 상에서 세션을 아예 삭제해버리기 
	//		session.invalidate();  //로그아웃은 이걸더 많이 쓴다.
		 
		
	}

}
