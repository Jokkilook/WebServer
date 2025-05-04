<%@ page language="java" import="java.sql.*, javax.sql.DataSource, java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../SQLconstants.jsp" %>
<%
	String contextPath = request.getContextPath();
	String search = request.getParameter("search");
	String message = "";
	List<String> schoolList = new ArrayList<>();

	try
	{
		// MySQL 드라이버 연결 
		Class.forName( jdbc_driver ); 
		Connection con = DriverManager.getConnection( mySQL_database, mySQL_id, mySQL_password ); 
	
		// 학교 테이블에 데이터 목록을 반환
		String query = "select * from school where name like ? order by name asc;"; 
		query = new String( query.getBytes("utf-8") );
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setString(1,"%" + search + "%");
		System.out.println(pstmt.toString());
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()){
			String name = rs.getString("name");
			String url = rs.getString("url");
			schoolList.add(name);		
	%>
		<%-- <div id="listItem" onclick="location.href='./main.jsp?url=<%=url %>'"> --%>
		<div id="listItem" onclick="selectItem('<%=url %>')">	
			<%=name %>
		</div>
	<%
		}
		
		if(schoolList.isEmpty()) 
			out.println("검색 결과가 없습니다.");
	
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

<script>
function selectItem(itemId) {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", "main.jsp?url=" + encodeURIComponent(itemId), true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            window.opener.document.getElementById("serverTime").innerHTML = xhr.responseText;
        }
    };
    xhr.send();
}
</script>