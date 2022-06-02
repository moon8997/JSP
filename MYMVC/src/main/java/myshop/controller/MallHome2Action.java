package myshop.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.controller.AbstractController;
import myshop.model.InterProductDAO;
import myshop.model.ProductDAO;

public class MallHome2Action extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		super.goBackURL(request);
		
	// 카테고리 목록을 가져오기
		super.getCategoryList(request);
				
	// === Ajax(JSON)를 사용하여 HIT 상품목록을 "더보기" 방식으로 페이징처리해서 보여주겠다. === //
			InterProductDAO pdao = new ProductDAO();
			
			int totalHITCount = pdao.totalPspecCount("1"); // HIT 상품의 전체개수를 알아온다.
			
		//	System.out.println(totalHITCount);
			
			request.setAttribute("totalHITCount", totalHITCount);	
		
	//	super.setRedirect(false);
		super.setViewPage("/WEB-INF/myshop/mallHome2.jsp");
		
	}

}
