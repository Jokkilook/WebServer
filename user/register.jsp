<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	//이전 화면에서 받은 정보를 저장. (id, pw, name)
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String message = null;
	
	try
	{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 유저 정보를 유저 테이블에 추가	
		String query = "insert into users(id, pw, name) values (?,?,?);"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1, id);
		pstmt.setString(2, pw);
		pstmt.setString(3, name);

		if ( pstmt.executeUpdate() > 0 )
		{
%>
			<script>
				alert("회원가입에 성공했습니다!");
			</script>
<%			response.sendRedirect("../main.jsp");
		}
		else 
		{
%>
			<script>
				alert("회원가입에 실패했습니다!");
			</script>
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