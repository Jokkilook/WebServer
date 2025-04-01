<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	//찜 목록에 아이템 추가하는 JSP
	
	//세션에 저장된 유저 닉네임과 유저넘버를 가져옴.
	String unum = request.getParameter("usernum");
	String gId = request.getParameter("gameid");
	
	try{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 찜 목록 테이블에 데이터를 추가하는 SQL 	
		String query = "insert into wishlist values(?,?)"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1, unum);
		pstmt.setString(2, gId);
		pstmt.executeUpdate();

		//작업이 끝나면 main으로 되돌아가기
		response.sendRedirect("../main.jsp");
		
	}catch(SQLException e){
		%>
		<script>
			alert("추가 실패");
			window.location.href = "../main.jsp";
		</script>
		<%
	}
%>