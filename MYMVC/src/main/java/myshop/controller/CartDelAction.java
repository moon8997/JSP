package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.*;

public class CartDelAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();
		
		if(!"POST".equalsIgnoreCase(method)) {
			// GET 방식이라면
			
			String message = "비정상적인 경로로 들어왔습니다";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setViewPage("/WEB-INF/msg.jsp");
			return;
		}
		
		else if("POST".equalsIgnoreCase(method) && super.checkLogin(request)) {
	         // POST 방식이고 로그인을 했고 로그인한 사용자 소유의 장바구니에 담은것 이라면 장바구니 비우기를 한다.   
			
			String cartno = request.getParameter("cartno");
			String userid = request.getParameter("userid");
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
			
			if( loginuser.getUserid().equals(userid) ) {
				
				// 장바구니 테이블에서 특정제품을 제거하기
				InterProductDAO pdao = new ProductDAO();
				int n = pdao.delCart(cartno);
				
				JSONObject jsobj = new JSONObject();
				jsobj.put("n", n);
				
				String json = jsobj.toString();
				
				request.setAttribute("json", json);
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/jsonview.jsp");
			}
			else {
				String message = "다른 사용자의 장바구니는 제거할 수 없습니다";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
				super.setViewPage("/WEB-INF/msg.jsp");
				return;
			}
			
		}
		
	}

}
