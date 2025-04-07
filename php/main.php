<!-- 가장 먼저 실행  -->

<?php
    session_start();
?>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>스팀 게임 목록 사이트(PHP 버전)</title>
	<style>
        body
		{
            margin: 0;
            padding: 0;
        }

		/* 우측화면에 고정 */
        #rightSection
		{
            position: fixed;
            right: 0;
            top: 0;
            width: 300px;
            height: 100vh;
            background-color: lightgreen;
            padding: 20px;
            overflow-y: auto;
        }

		h3 
		{
			display: inline; /* 줄바꿈을 없앰 */
			margin-right: 10px; /* 입력창과 간격을 주기 위해 추가 */
    	}
    </style>
</head>
<script>
	//입력된 키워드 반환
    function getSearchKeyword()
	{
        return document.getElementById("searchInput").value;
    }

	//입력된 키워드로, 게임 찾기
    function searchGames()
	{
        var searchKeyword = getSearchKeyword();
        loadList(searchKeyword, "game_id", "ASC");
    }

	//gameList 로드 함수
	//(search로 검색키워드, sort 정렬기준, order 정렬방식인듯)
    function loadList(search, sort, order)
	{
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "gameList/gameList.php?search=" + encodeURIComponent(search) + "&sort=" + sort + "&order=" + order, true);
        xhr.onreadystatechange = function ()
		{
            if (xhr.readyState == 4 && xhr.status == 200)
			{
                document.getElementById("leftSection").innerHTML = xhr.responseText;
            }
        };
        xhr.send();
    }
</script>

<body>
	<div id="rightSection">

		<!-- 1. 로그인 섹션 출력 -->
		<?php
			require("user/loginSection.php");
		?>

		<!-- 2. 장바구니 출력 -->
		<?php
			require("wishlist/wishlist.php");
			//echo "Trying to include: " . __DIR__ . "/wishlist/wishlist.php" . "<br>";
		?>
		<br><br><br><br>
	</div>
	
	<!-- 3. 게임 검색바 출력 -->
	<form name="formm" method="post">              
		<h3>검색<h3>
		<input type="text" id="searchInput" name="search" size="60" onkeydown="if(event.key === 'Enter') { event.preventDefault(); searchGames(); }"> 
			
		<button type="button" onclick="searchGames()">검색</button>
	</form>
	
	<!-- 4. 정렬 기준 버튼들 출력 -->
	<h3>정렬<h3>
	<button onclick="loadList(getSearchKeyword(),'game_name', 'ASC')">이름</button>
	<button onclick="loadList(getSearchKeyword(),'release_date', 'ASC')">출시일</button>
	<button onclick="loadList(getSearchKeyword(),'good', 'DESC')">평가</button>
	<button onclick="loadList(getSearchKeyword(),'price', 'DESC')">가격</button>
	<br><br><br>

	<!-- 5. 게임 목록 출력 -->
	<h1> 게임목록 </h1>
	<div id="leftSection">
		<script>
			//브라우저창이 완전히 로드된 후, loadList 실행
			//(loadList에서는 서버의 데이터를 모두 잘 가지고오면,)
			//(해당 데이터의 HTML그대로 이 자리에서 출력)
			window.onload = function() { loadList('',"game_id","ASC") }
		</script>
	</div>
</body>
</html>