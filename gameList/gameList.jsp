<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	String usernum = (String)session.getAttribute("usernum");
	String message = "";
	
	try
	{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 게임 테이블에 데이터 목록을 반환
		String query = "select * from game;"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);	
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()){
			String gameId = rs.getString("game_id");
			String gameName = rs.getString("game_name");
			%>
			<!-- 각 게임마다 찜 목록 추가 버튼을 추가 -->
			<form action="./wishlist/addItem.jsp">
					<input type="hidden" name="usernum" value=<%=usernum %>>
					<input type="hidden" name="gameid" value=<%=gameId %>>
					<input type="submit" value="찜 목록 추가">
			</form>
			<%
		}
	
		// MySQL 드라이버 연결 해제
		pstmt.close();
		con.close();
	} 
		// 예외 처리
	catch(SQLException e)
	{
			message = e.getMessage();
	}
	catch( Exception e ) 
	{
			message = e.getMessage();
	}   
%>