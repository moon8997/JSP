package myshop.model;

public class CartVO { // (오라클로 말하면 자식테이블)    

   private int cartno;      //  장바구니 번호             
   private String userid;   //  사용자ID            
   private int pnum;        //  제품번호                
   private int oqty;        //  주문량                   
      
   private ProductVO prod;  //  제품정보객체 (오라클로 말하면 부모테이블)

   public CartVO() { }
   
   public CartVO(int cartno, String userid, int pnum, int oqty, ProductVO prod) {
      this.cartno = cartno;
      this.userid = userid;
      this.pnum = pnum;
      this.oqty = oqty;
      this.prod = prod;
   }

   public int getCartno() {
      return cartno;
   }

   public void setCartno(int cartno) {
      this.cartno = cartno;
   }

   public String getUserid() {
      return userid;
   }

   public void setUserid(String userid) {
      this.userid = userid;
   }

   public int getPnum() {
      return pnum;
   }

   public void setPnum(int pnum) {
      this.pnum = pnum;
   }

   public int getOqty() {
      return oqty;
   }

   public void setOqty(int oqty) {
      this.oqty = oqty;
   }
   
   public ProductVO getProd() {
      return prod;
   }

   public void setProd(ProductVO prod) {
      this.prod = prod;
   }
   
   
   
}