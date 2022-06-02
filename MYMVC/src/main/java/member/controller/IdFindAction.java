package member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import member.model.*;

public class IdFindAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String method = request.getMethod();   
		//"GET" 또는 "POST"
		
		if("POST".equalsIgnoreCase(method)) {
			//아이디 찾기 모달창에서 "찾기"버튼을 클릭했을 경우 
			
			String name = request.getParameter("name");
			String email = request.getParameter("email");    //포스트방식일때만 보여준다
			
			InterMemberDAO mdao = new MemberDAO();
			
			Map<String, String> paraMap = new HashMap<>();//네임과 이메일을 보냄  스프링할땐 다 해쉬맵으로 가서 미리 익숙해지기 
			paraMap.put("name", name);
			paraMap.put("email", email);
			
			String userid = mdao.findUserid(paraMap);
			
			if(userid != null) {
				request.setAttribute("userid", userid);
			}
			else {
				request.setAttribute("userid", "존재하지 않습니다.");
			}
			
			request.setAttribute("name",name ); //넘어온 키값 이수닌
			request.setAttribute("email",email );
			
		}// end of if("POST".equalsIgnoreCase(method))------------
		
			
		request.setAttribute("method", method);	//겟인지 포스트인지 넘겨준다  맨처음에는 겟방식  겟을 넘겨준다.	
		//super.setRedirect(false);
		super.setViewPage("/WEB-INF/login/idFind.jsp");   //폼ㅁ태그만 보여줄뿐//겟방식이든지 포스트이든지 똑같다   //뷰단페이지login/idfind.jsp에간다
		
	}

}
