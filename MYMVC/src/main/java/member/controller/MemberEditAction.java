package member.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.controller.AbstractController;
import member.model.MemberVO;

public class MemberEditAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		super.goBackURL(request);
		// 내정보(회원정보)를 수정하귀 위한 전제조건은 먼저 로그인을 해야하는 것이다.
		if( super.checkLogin(request) ) {
			// 로그인은 했으면 
			
			String userid = request.getParameter("userid");
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			if( loginuser.getUserid().equals(userid) ) {
				// 로그인한 사용자가 자신의 코인을 충전하는 경우
			 // super.setRedirect(false);
				super.setViewPage("/WEB-INF/member/memberEdit.jsp");
			}
			else {
				// 로그인한 사용자가 다른 사용자의 코인을 충전하려고 시도하는 경우 
				String message = "다른 사용자의 정보변경은 불가합니다.!!";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
			 // super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		}
		else {
			// 로그인을 안 했으면 
			String message = "회원정보를 수정하기 위해서는 먼저 로그인을 하세요!!";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		 // super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
		
	}

}
