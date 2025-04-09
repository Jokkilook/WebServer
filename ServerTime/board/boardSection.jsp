<%@ page language="java" import="java.sql.*, javax.sql.DataSource, java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	String contextPath = request.getContextPath();
	String message = "";

	try
	{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 게시글 테이블에 데이터 목록을 반환
		String query = "select * from board order by time desc;"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		System.out.println(pstmt.toString());
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()){
			String writer_ip = rs.getString("writer_ip");
			String content = rs.getString("content");
			Timestamp time = rs.getTimestamp("time");
	%>
		<div id="postItem" >
			<%=writer_ip %>
			<%=content %>
			<%=time %>
		</div>
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