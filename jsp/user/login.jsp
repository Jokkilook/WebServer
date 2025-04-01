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
	
		// 유저 정보를 가져오는 SQL
		String query = "select usernum,name from users where id=? and pw=?"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1, id);
		pstmt.setString(2, pw);
		ResultSet rs = pstmt.executeQuery();

		//아이디 비번이 일치하는 유저가 있으면 세션에 유저 닉네임과 유저넘버 저장
		while(rs.next()){
			String name = rs.getString("name");
			String usernum = rs.getString("usernum");
			if ( name!=null )
			{	
				//세션에 정보 저장
				session.setAttribute("user", name);
				session.setAttribute("usernum", usernum);
				//완료 후 main으로 되돌아가기
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
			}
		}
%>
		<script>
				alert("로그인 정보가 일치하지 않습니다.");
				window.location.href = "../main.jsp";
		</script>
<%
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