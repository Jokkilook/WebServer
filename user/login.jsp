<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String message = null;
	
	System.out.println(id+pw);
	try
	{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// MySQL 책 추가 실행 	
		String query = "select usernum,name from users where id=? and pw=?"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1, id);
		pstmt.setString(2, pw);
		
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()){
			String name = rs.getString("name");
			String usernum = rs.getString("usernum");
			if ( name!=null )
			{
				session.setAttribute("user", name);
				session.setAttribute("usernum", usernum);
				response.sendRedirect("../main.jsp");
%>
<%			
			}
			else 
			{
%>
			<script>
				alert("로그인 정보가 일치하지 않습니다.");
				window.location.href = "../main.jsp";
			</script>
			
<%
				//System.out.println("로그인 실패요");
				//response.sendRedirect("main.jsp");
			}
		}
%>
		<script>
				alert("로그인 정보가 일치하지 않습니다.");
				window.location.href = "../main.jsp";
		</script>
<%
	
		//response.sendRedirect("main.jsp");
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