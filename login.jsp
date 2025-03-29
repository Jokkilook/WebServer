<%@ page language="java" import="java.sql.*, javax.sql.DataSource" pageEncoding="utf8"%>
<%@ include file="./SQLconstants.jsp"%>

<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	// 이전 페이지에서 전달 받은 메시지 확인
	request.setCharacterEncoding("UTF-8");
	String 	lmessage = request.getParameter( "message" ); 
	lmessage = ( ( ( lmessage == null ) || lmessage.equals( "" ) || ( lmessage.indexOf( " * " ) == 0 ) ) ? "_%" : lmessage );

	try
	{
		// MySQL 드라이버 연결
		Class.forName( jdbc_driver ); 
		Connection lcon = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
		Statement lstmt = lcon.createStatement();
	
		String query = "select * from game;";
		ResultSet lresult = lstmt.executeQuery( query );
		while( lresult.next() )
		{		
			out.print( "<div>"
					+ "<BR>ID : " + lresult.getString( "game_id" ) 
					+ "<BR> 책제목 : " + lresult.getString( "game_name" ) 
					+ "<BR> 저자 : "+ lresult.getString( "developer" ) 
					+ "<BR> 출판사 : " + lresult.getString( "publisher" ) 
					+ "<BR> 출판일 : " + lresult.getString( "release_date" )
					+ "</div>" );
		}
	
		// MySQL 드라이버 연결 해제
		lresult.close(); 
		lstmt.close();
		lcon.close();
	}
	// 예외 처리
	catch( SQLException e )
	{
		lmessage = e.getMessage();
	}
	catch( Exception e ) 
	{
		lmessage = e.getMessage();
	}    
%>
	 <div id="login-form" class="login-form">
        <h3>로그인</h3>
        아이디: <input type="text" id="user-id"><br>
        비밀번호: <input type="password" id="password"><br>
        <button onclick="login()">로그인</button>
        <button onclick="register()">회원가입</button>
    </div>
</body>
</html>