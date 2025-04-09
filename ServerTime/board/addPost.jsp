<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	//게시글 추가하는 JSP
	
	String content = request.getParameter("content");
	String userIp = request.getHeader("X-Forwarded-For");
	
	// 프록시를 통하지 않은 경우
	if (userIp == null || userIp.isEmpty() || "unknown".equalsIgnoreCase(userIp)) {
	    userIp = request.getRemoteAddr();
	}
	
	try{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 게시글 테이블에 데이터를 추가하는 SQL 	
		String query = "insert into board (writer_ip, content, time) values(?,?,?)"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1, userIp);
		pstmt.setString(2, content);
        // 현재 시간 설정
        Timestamp currentTime = new Timestamp(System.currentTimeMillis());
        pstmt.setTimestamp(3, currentTime);
        System.out.println(pstmt.toString());
		pstmt.executeUpdate();
		
	}catch(SQLException e){
		System.out.println(e.toString());
		%>
		<script>
			alert("게시글 추가 실패");
		</script>
		<%
	}
%>