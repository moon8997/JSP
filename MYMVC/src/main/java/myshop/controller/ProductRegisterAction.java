package myshop.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import common.controller.AbstractController;
import member.model.MemberVO;
import myshop.model.*;

public class ProductRegisterAction extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 또는 로그아웃을 햇을경우 그 페이지 그대로
		super.goBackURL(request);
		
		// == 관리자(admin)로 로그인 했을 때만 조회가 가능하도록 해야 한다. == //
		HttpSession session = request.getSession();
		
		MemberVO loginuser = (MemberVO) session.getAttribute("loginuser");
		
		if( loginuser == null || !"admin".equals(loginuser.getUserid()) ) {
			// 로그인을 안한 경우 또는 일반사용자로 로그인 한 경우
			String message = "관리자만 접근이 가능합니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
		//	super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
		else {
			// 관리자(admin)로 로그인 했을 경우 
			
			String method = request.getMethod();
			
			if(!"POST".equalsIgnoreCase(method)) { // GET 이라면
			
				// 카테고리 목록을 조회해오기
				super.getCategoryList(request);
				
				// spec 목록을 보여주고자 한다.
				InterProductDAO pdao = new ProductDAO();
				List<SpecVO> specList = pdao.selectSpecList(); 
				request.setAttribute("specList", specList);
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/myshop/admin/productRegister.jsp");
			}
			else {
				// POST 이라면
				
				/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			         파일을 첨부해서 보내는 폼태그가 enctype="multipart/form-data" 으로 되어었다라면
				     HttpServletRequest request 을 사용해서는 데이터값을 받아올 수 없다.
				     이때는 cos.jar 라이브러리를 다운받아 사용하도록 한 후  
				     아래의 객체를 사용해서 데이터 값 및 첨부되어진 파일까지 받아올 수 있다.
				  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    
				*/
				
				MultipartRequest mtrequest = null;
				/*
				    MultipartRequest mtrequest 은 
				    HttpServletRequest request 가 하던일을 그대로 승계받아서 일처리를 해주고 
				    동시에 파일을 받아서 업로드, 다운로드까지 해주는 기능이 있다. 	  
				*/
				
				// 1. 첨부되어진 파일을 디스크의 어느경로에 업로드 할 것인지 그 경로를 설정해야 한다. 
				ServletContext svlCtx = session.getServletContext();
				String uploadFileDir = svlCtx.getRealPath("/images");
				
			//	System.out.println("=== 첨부되어지는 이미지 파일이 올라가는 절대경로 uploadFileDir ==> " + uploadFileDir); 
			//	=== 첨부되어지는 이미지 파일이 올라가는 절대경로 uploadFileDir ==> C:\NCS\workspace(jsp)\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\MyMVC\images   
				
			/*
			    MultipartRequest의 객체가 생성됨과 동시에 파일 업로드가 이루어 진다.
						 
			    MultipartRequest(HttpServletRequest request,
				       	         String saveDirectory, -- 파일이 저장될 경로
					             int maxPostSize,      -- 업로드할 파일 1개의 최대 크기(byte)
					             String encoding,
					             FileRenamePolicy policy) -- 중복된 파일명이 올라갈 경우 파일명다음에 자동으로 숫자가 붙어서 올라간다.   
					   
			    파일을 저장할 디렉토리를 지정할 수 있으며, 업로드제한 용량을 설정할 수 있다.(바이트단위). 
			    이때 업로드 제한 용량을 넘어서 업로드를 시도하면 IOException 발생된다. 
			    또한 국제화 지원을 위한 인코딩 방식을 지정할 수 있으며, 중복 파일 처리 인터페이스를사용할 수 있다.
					   		
			    이때 업로드 파일 크기의 최대크기를 초과하는 경우이라면 
			    IOException 이 발생된다.
			    그러므로 Exception 처리를 해주어야 한다.                
			 */	
			 
		     // ==== 파일을 업로드 해준다. 시작 ==== //
			 try {
				mtrequest = new MultipartRequest(request, uploadFileDir, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy() );
			 } catch(IOException e) {
				 e.printStackTrace();
				 
				 request.setAttribute("message", "업로드 되어질 경로가 잘못되었거나 또는 최대용량 10MB를 초과했으므로 파일업로드 실패함!!");
				 request.setAttribute("loc", request.getContextPath()+"/shop/admin/productRegister.up"); 
		   	  
				 super.setViewPage("/WEB-INF/msg.jsp");
				 return; // 종료
			 }
			 // ==== 파일을 업로드 해준다. 끝 ==== //
			 
			 // === 첨부 이미지 파일을 올렸으니 그 다음으로 제품정보를 (제품명, 정가, 제품수량,...) DB의 tbl_product 테이블에 insert 를 해주어야 한다.  === 
			 
			   // 새로운 제품 등록시 form 태그에서 입력한 값들을 얻어오기
			   String fk_cnum = mtrequest.getParameter("fk_cnum");
			   String pname = mtrequest.getParameter("pname");
			   String pcompany = mtrequest.getParameter("pcompany");
			   
			   // 업로드되어진 시스템의 첨부파일 이름(파일서버에 업로드 되어진 실제파일명)을 얻어 올때는 
			   // cos.jar 라이브러리에서 제공하는 MultipartRequest 객체의 getFilesystemName("form에서의 첨부파일 name명") 메소드를 사용 한다. 
			   // 이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
			   String pimage1 = mtrequest.getFilesystemName("pimage1");
			   String pimage2 = mtrequest.getFilesystemName("pimage2");
			 /* 
			   System.out.println("~~~ 확인용 pimage1 => " + pimage1);  ~~~ 확인용 pimage1 => 쉐보레전면.jpg   쉐보레전면1.jpg   쉐보레전면2.jpg
			   System.out.println("~~~ 확인용 pimage2 => " + pimage2);  ~~~ 확인용 pimage2 => 쉐보레후면.jpg   쉐보레후면1.jpg   쉐보레후면2.jpg  
			 */
			 
			/*   
			   String pimage1_originFileName = mtrequest.getOriginalFileName("pimage1"); 
			   String pimage2_originFileName = mtrequest.getOriginalFileName("pimage2"); 
			  
			   System.out.println("### 확인용 pimage1_originFileName => " + pimage1_originFileName);  ### 확인용 pimage1_originFileName => 쉐보레전면.jpg   쉐보레전면.jpg   쉐보레전면.jpg
			   System.out.println("### 확인용 pimage2_originFileName => " + pimage2_originFileName);  ### 확인용 pimage2_originFileName => 쉐보레후면.jpg   쉐보레후면.jpg   쉐보레후면.jpg  
			*/
				
			   String prdmanual_systemFileName = mtrequest.getFilesystemName("prdmanualFile");
			   // 제품설명서 파일명(파일서버에 업로드 되어진 실제파일명)  
			   // 제품설명서 파일명 입력은 선택사항이므로 NULL 이 될 수 있다.
			   // System.out.println("~~~ 확인용 prdmanual_systemFileName => " + prdmanual_systemFileName);
			   
			   String prdmanual_originFileName = mtrequest.getOriginalFileName("prdmanualFile");
			   // 웹클라이언트의 웹브라우저에서 파일을 업로드 할때 올리는 제품설명서 파일명
			   // 제품설명서 파일명 입력은 선택사항이므로 NULL 이 될 수 있다.
			   // 첨부파일들 중 이것만 파일다운로드를 해주기 때문에 getOriginalFileName(String name) 메소드를 사용한다. 
			   
		/*
			   <<참고>> 
			   ※ MultipartRequest 메소드

		        --------------------------------------------------
				  반환타입                         설명
				--------------------------------------------------
				 Enumeration       getFileNames()
				
						                     업로드 된 파일들에 대한 이름을 Enumeration객체에 String형태로 담아 반환한다. 
						                     이때의 파일 이름이란 클라이언트 사용자에 의해서 선택된 파일의 이름이 아니라, 
						                     개발자가 form의 file타입에 name속성으로 설정한 이름을 말한다. 
						                     만약 업로드 된 파일이 없는 경우엔 비어있는 Enumeration객체를 반환한다.
				
				 
				 String            getContentType(String name)
				
						                     업로드 된 파일의 컨텐트 타입을 얻어올 수 있다. 
						                     이 정보는 브라우저로부터 제공받는 정보이다. 
						                     이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
				
				
				 File              getFile(String name)
				
						                     업로드 된 파일의 File객체를 얻는다. 
						                     우리는 이 객체로부터 파일사이즈 등의 정보를 얻어낼 수 있다. 
						                     이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
				
				
				 String            getFilesystemName(String name)
				
						                     시스템에 업로드되어진 파일의 이름을 반환한다.
						                     시스템에 "쉐보레전면.jpg" 가 올라가 있는데 또 사용자가 웹에서 "쉐보레전면.jpg" 파일을 올릴경우 
						                     FileRenamePolicy 에 의해 시스템에 업로드되어지는 파일명은 "쉐보레전면1.jpg" 가 되며
						                     "쉐보레전면1.jpg" 파일명을 리턴시켜주는 것이  getFilesystemName(String name) 이다.                       
						                     만약에, 이때 업로드 된 파일이 없는 경우에는 null을 반환한다.
				
				
				 String            getOriginalFileName(String name)
				
						                     중복 파일 처리 인터페이스에 의해 변환되기 이전의 파일 이름을 반환한다. 
						                     이때업로드 된 파일이 없는 경우에는 null을 반환한다.
				
				
				 String            getParameter(String name)
				
						                     지정한 파라미터의 값을 반환한다. 
						                     이때 전송된 값이 없을 경우에는 null을 반환한다.
				
				
				 Enumeration       getParameternames()
				
						                     폼을 통해 전송된 파라미터들의 이름을 Enumeration객체에 String 형태로 담아 반환한다. 
						                     전송된 파라미터가 없을 경우엔 비어있는 Enumeration객체를 반환한다
				
				
				 String[]          getparameterValues(String name)
				
						                     동일한 파라미터 이름으로 전송된 값들을 String배열로 반환한다. 
						                     이때 전송된파라미터가 없을 경우엔 null을 반환하게 된다. 
						                     동일한 파라미터가 단 하나만 존재하는 경우에는 하나의 요소를 지닌 배열을 반환하게 된다.    
		    */
			
			     String pqty = mtrequest.getParameter("pqty");
			     String price = mtrequest.getParameter("price");
			     String saleprice = mtrequest.getParameter("saleprice");
			     String fk_snum = mtrequest.getParameter("fk_snum");
			     
			     // !!!! 크로스 사이트 스크립트 공격에 대응하는 안전한 코드(시큐어코드) 작성하기 !!!! //
			     String pcontent = mtrequest.getParameter("pcontent");
			     pcontent = pcontent.replaceAll("<", "&lt;");
			     pcontent = pcontent.replaceAll(">", "&gt;");
			     
			     // 입력한 내용에서 엔터는 <br>로 변환시키기
			     pcontent = pcontent.replaceAll("\r\n", "<br>");
			     
			     String point = mtrequest.getParameter("point");
			     
			     InterProductDAO pdao = new ProductDAO();
			     
			     // 제품번호 채번 해오기
			     int pnum = pdao.getPnumOfProduct();
			     
			     ProductVO pvo = new ProductVO();
			     pvo.setPnum(pnum);
			     pvo.setFk_cnum(Integer.parseInt(fk_cnum));
			     pvo.setPname(pname);
				 pvo.setPcompany(pcompany);
				 pvo.setPimage1(pimage1);
				 pvo.setPimage2(pimage2);
				 pvo.setPrdmanual_systemFileName(prdmanual_systemFileName);
				 pvo.setPrdmanual_orginFileName(prdmanual_originFileName);
				 pvo.setPqty(Integer.parseInt(pqty));
				 pvo.setPrice(Integer.parseInt(price));
				 pvo.setSaleprice(Integer.parseInt(saleprice));
				 pvo.setFk_snum(Integer.parseInt(fk_snum));
				 pvo.setPcontent(pcontent);
				 pvo.setPoint(Integer.parseInt(point));
				 
				 
				 String message = "";
				 String loc = "";
				 
				 try {
					 // **** tbl_product 테이블에 제품정보 insert 하기 **** //
					 pdao.productInsert(pvo);
					 
					// === 추가이미지파일이 있다라면 tbl_product_imagefile 테이블에 제품의 추가이미지 파일명 insert 해주기 === // 
					 String str_attachCount = mtrequest.getParameter("attachCount");
				//	 System.out.println("~~~ 확인용 추가이미지 파일개수 str_attachCount => " + str_attachCount);
					 // str_attachCount 이 추가이미지 파일의 개수인데  ""  "0"  ~ "10" 값이 들어온다.
					 
					 int attachCount = 0;
					 
					 if( !"".equals(str_attachCount) ) {
						 attachCount = Integer.parseInt(str_attachCount);
					 }
					 
					 // 첨부파일의 파일명(파일서버에 업로드 되어진 실제파일명) 알아오기
					 for(int i=0; i<attachCount; i++) {
						 String attachFileName = mtrequest.getFilesystemName("attach"+i);
						 
						 // **** 이번에는 tbl_product_imagefile 테이블에 insert 할 것인데 VO 대신에 HashMap을 사용하여 insert 해보겠습니다. **** //  
						 Map<String,String> paraMap = new HashMap<>();
						 paraMap.put("pnum", String.valueOf(pnum));
						 paraMap.put("attachFileName", attachFileName);
						 
						 pdao.product_imagefile_Insert(paraMap);
					 }// end of for-----------------------------------------------------
				 
					 message = "제품등록 성공!!";
					 loc = request.getContextPath()+"/shop/mallHome1.up";
					 
				 } catch(SQLException e) {
					 e.printStackTrace();
					 
					 message = "제품등록 실패!!";
					 loc = request.getContextPath()+"/shop/admin/productRegister.up";
				 }
				 
				 request.setAttribute("message", message);
				 request.setAttribute("loc", loc);
			   
				 super.setViewPage("/WEB-INF/msg.jsp");
			}
			
		}
		
	}

}
