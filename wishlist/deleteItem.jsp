<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	//찜 목록에 아이템 삭제하는 JSP
	
	String unum = request.getParameter("usernum");
	String gId = request.getParameter("gameid");
	
	try{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// MySQL 책 추가 실행 	
		String query = "delete from wishlist where usernum=? and game_id=?"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1, unum);
		pstmt.setString(2, gId);
		System.out.println(pstmt);
		pstmt.executeUpdate();
		response.sendRedirect("../main.jsp");
		
	}catch(SQLException e){
		%>
		<script>
			alert("삭제 실패");
			window.location.href = "../main.jsp";
		</script>
		<%
	}
%>