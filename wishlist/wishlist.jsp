<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<div id="wishlist">
<%	
	//찜 목록을 출력하는 JSP
	
	//세션에 저장된 유저 닉네임과 유저넘버를 가져옴.
	String user = (String)session.getAttribute("user");
	String usernum = (String)session.getAttribute("usernum");
	
	//로그인 된 상태라 세션에 유저 정보가 존재하면 찜 목록 로딩 후 출력
	if(user!=null){
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// MySQL 책 추가 실행 	
		//찜 목록 테이블에서 유저넘버가 일치하는 모든 항목의 유저넘버와, 게임ID, 게임 테이블과 연동해 게임 이름까지 반환
		String query = "select w.usernum, w.game_id, g.game_name from wishlist w join game g on w.game_id = g.game_id where w.usernum=?;"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		//인젝션 공격 방지를 위한 PreparedStatement
		pstmt.setString(1, usernum);
		System.out.println(pstmt);
		ResultSet rs = pstmt.executeQuery();
		
		//가져온 찜 목록 아이템 들을 while 문으로 뿌림.
		while(rs.next()){
			%>
			<%=rs.getString("game_name") %>
			<!-- 삭제 기능에 사용할 유저넘과 게임아이디를 deleteItem.jsp로 전송 -->
			<form action="./wishlist/deleteItem.jsp">
				<input type="hidden" name="usernum" value=<%=rs.getString("usernum") %>>
				<input type="hidden" name="gameid" value=<%=rs.getString("game_id") %>>
				<input type="submit" value="삭제">
			</form>
			<%
		}
%>
	
<%
	}
	//세션에 유저 정보가 없으면 로그인 후 이용하라는 메시지 출력
	else{
%>
	로그인 후 사용해주세요.
<%		
	}
%>
</div>