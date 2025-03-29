<%@ page language="java" import="java.sql.*, javax.sql.DataSource, java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	String usernum = (String)session.getAttribute("usernum");
	List<String> wishlist = (List<String>) session.getAttribute("wishlist");
	String message = "";
	String search = "";
    String sortColumn = "game_id";
    String sortOrder = "ASC";
    
    // 검색, 정렬 기준이 넘어오면 변경
    if (request.getParameter("search") != null) {
    	search = request.getParameter("search");
    }
    if (request.getParameter("sort") != null) {
        sortColumn = request.getParameter("sort");
    }
    if (request.getParameter("order") != null) {
        sortOrder = request.getParameter("order");
    }
	
/* 	int currentPage = 1;
	int itemPerPage = 20;
	if(request.getParameter("page")!=null){
		currentPage = Integer.parseInt(request.getParameter("page"));
	}
	int offset = (currentPage-1)*itemPerPage; */
		
	try
	{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 게임 테이블에 데이터 목록을 반환
		String query = "select * from game where game_name like ? order by "+sortColumn+" "+sortOrder+";"; 
		//String query = "select * from game limit ? offset ?;"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1,"%" + search + "%");
		System.out.println(pstmt.toString());
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()){
			String gameId = rs.getString("game_id");
			String gameName = rs.getString("game_name");
			String releaseDate = rs.getString("release_date");
			String developer = rs.getString("developer");
			String genre = rs.getString("genre");
			int like = rs.getInt("good");
			int dislike = rs.getInt("bad");
			int playtime = rs.getInt("average_playtime");
			float price = rs.getFloat("price");		
			
			//유저가 로그인 중이고 [ 저장된 찜 목록이 null이 아니고 && 그 배열에 해당 게임이 있다면 ] 버튼 Disable
			String disabled = (usernum!=null)&&!(wishlist!=null&&wishlist.contains(gameId)) ? "" : "disabled";
						
%>
			<!-- 아이템을 누르면 해당 게임의 스팀 상점 페이지로 이동 -->
			<div id="gameItem">
				<div onclick="window.open('https://store.steampowered.com/app/<%=gameId %>','_blank');" >
					<%=gameName %>
					<%=releaseDate %>
					<%=developer %>
					<%=genre %>
					<%=like %>
					<%=dislike %>
					<%=playtime %>
					<%=price %>
				</div>
				<!-- 각 게임마다 찜 목록 추가 버튼을 추가 -->
				<form action="./wishlist/addItem.jsp">
					<input type="hidden" name="usernum" value=<%=usernum %>>
					<input type="hidden" name="gameid" value=<%=gameId %>>
					<input type="submit" value="찜 목록 추가" <%=disabled %>>
				</form>
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