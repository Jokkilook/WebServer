<%@ page language="java" import="java.net.*, java.io.*, java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./log.jsp"%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서버 시간 디스플레이 사이트</title>
</head>
<link rel="stylesheet" href="./style.css">
<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	String detectedUrl = request.getParameter("url");
    String normalizedUrl = "";
    
    System.out.println(request.getContextPath());

    if (detectedUrl != null && !detectedUrl.trim().isEmpty()) {
    	detectedUrl = detectedUrl.trim();

        // URL이 http:// 또는 https:// 로 시작하지 않으면 https:// 붙임
        if (!detectedUrl.startsWith("http://") && !detectedUrl.startsWith("https://")) {
            normalizedUrl = "https://" + detectedUrl;
        } else {
            normalizedUrl = detectedUrl;
            writeLog(normalizedUrl+" 을 조회했습니다.", request, session, application);
        }
    }
	
    String targetUrl = !(normalizedUrl.isEmpty()) ? normalizedUrl : "https://www.naver.com";
    long serverTimeMillis = 0;
    
    try {
        URL url = new URL(targetUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("HEAD"); // 내용은 필요 없으므로 HEAD 요청
        conn.connect();

        // 서버에서 보낸 날짜 헤더 가져오기
        serverTimeMillis = conn.getDate(); // === 'Date' 헤더의 Unix timestamp (ms)
        conn.disconnect();
    } catch (Exception e) {
        //out.print("오류: " + e.getMessage());
    }
%>
<script>
        let baseServerTime = <%= serverTimeMillis %>; // 서버 기준 시간 (ms)
        let baseClientPerf = 0; // 클라이언트 기준 시작 시간 (ms, 고정됨)

        // 시간 포맷팅 함수
        function formatTime(ms) {
            const d = new Date(ms);
            const pad = (n, digits = 2) => String(n).padStart(digits, '0');
            return pad(d.getHours()) + '시 ' + pad(d.getMinutes()) + '분 ' + pad(d.getSeconds()) + '초 ' + pad(d.getMilliseconds(), 3);
        }

        // 클라이언트에서 서버시간을 계속 업데이트 10ms 마다
        function startUpdatingClock() {
            setInterval(() => {
                const elapsed = performance.now() - baseClientPerf;
                const currentServerTime = baseServerTime + elapsed;
                document.getElementById("serverTime").innerText = formatTime(currentServerTime);
            }, 10);
        }
        
        //학교 검색창의 값을 가져옴
    	function getSearchKeyword() {
    	    return document.getElementById("searchInput").value;
    	}
        
        //학교 검색 수행
    	function searchSchool() {
    	    var searchKeyword = getSearchKeyword();
    	    loadList(searchKeyword); 
    	}
    	
        //검색어로 데이터 베이스에서 목록 가져오기 새로고침
    	function loadList(search) {
    	    var xhr = new XMLHttpRequest();
    	    xhr.open("GET", "search/searchSection.jsp?search=" + encodeURIComponent(search), true);
    	    xhr.onreadystatechange = function () {
    	        if (xhr.readyState == 4 && xhr.status == 200) {
    	            document.getElementById("list").innerHTML = xhr.responseText;
    	        }
    	    };
    	    xhr.send();
    	}
        
        //게시글 올리기
        function postContent() {
            const content = document.getElementById("content").value;
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "board/addPost.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    // 게시 성공 후 boardSection.jsp 부분만 새로고침
                    loadBoard();
                    document.getElementById("content").value = ""; // 입력창 비우기
                }
            };
            xhr.send("content=" + encodeURIComponent(content));
        }
		
        //게시판 로드
        function loadBoard() {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", "board/boardSection.jsp", true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    document.getElementById("board").innerHTML = xhr.responseText;
                }
            };
            xhr.send();
        }
    	

        startUpdatingClock();
        window.onload = loadBoard;
        window.onload=function() { loadList('') }
   </script>
<body>

<!-- 시간 출력 구역 -->
<div id="time">
	<form name="urlForm" action="<%= contextPath %>/ServerTimeLegacy/main.jsp" method="get">
		조회 사이트 URL
		<input type="text" name="url" value=<%= detectedUrl %> >
		<input type="submit" value="조회">
	</form>
	<%if(!(detectedUrl==null)){%>
	<%= detectedUrl %>의 서버 시간
	<%} %>
	<div id="serverTime"></div>
</div>

<!-- 게시판 구역 -->
<div id="board">
	<form name="addForm" method="post">
		<input type="text" name="content" id="content" >
		<button onclick="postContent()">게시</button>
	</form>
	<jsp:include page="board/boardSection.jsp" />
</div>

<!-- 검색 구역 -->
<div id="search">
	<form name="search" action="" method="post">
		<input type="text" id="searchInput" onkeydown="if(event.key === 'Enter') { event.preventDefault(); searchSchool(); }" >
		<button type="button" onclick="searchSchool()">검색</button>
	</form>
	<div id="list">
	<jsp:include page="search/searchSection.jsp" />
	</div>
</div>

<button id="transButton" type="button" onclick="location.href='../ServerTime/main.jsp'">최신 버전으로 이동</button>
</body>
</html>