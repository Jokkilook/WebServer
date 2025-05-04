<%@ page language="java" import="java.net.*, java.io.*, java.util.*" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./style.css">
<script src="https://kit.fontawesome.com/0c8a563ee1.js" crossorigin="anonymous"></script>
<meta charset="UTF-8">
<title>서버 시간 디스플레이 사이트</title>
</head>
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
        }
    } else {
    	detectedUrl = "";
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

<body>
<div id="layout">

		<!-- 시간 출력 구역 -->	
		<div id="time">
			조회 사이트 URL	
			<form id="url" name="urlForm" action="./main.jsp" method="get">
				<input type="text" name="url" value="<%= detectedUrl %>" >
				<Button>조회</Button>
			</form>
			<div id="timelabel">
			
				<div id="currenturl">
					<%if(!(detectedUrl=="")){%>
					<%= detectedUrl %>의 서버 시간
					<%} else {%>서버 시간 <%} %>
				</div>
				
				<div id="alarm">
					<div class="toggle-switch" id="toggleSwitch">
	  				<div class="switch-handle"></div>
					</div>
	  				<span>알람</span>
					<select id="minuteSelect">
					  <% for (int i = 0; i < 60; i++) { %>
					    <option value="<%= i %>"><%= i %></option>
					  <% } %>
					</select>
					분에 알림
				</div>
				
			</div>
			<div id="serverTime"></div>
		</div>
		
		<div id="down">
			
			<div class="tableft">
				<ul class="tablist">
					<li>게시판</li>
					<li>반응 속도 테스트</li>
				</ul>
				
				<!-- 게시판 구역 -->
				<div id="board">
			
					<form name="addForm" method="post" onsubmit="return postContent()">
						<input type="text" name="content" id="content" required >
						<button onclick="submit">게시</button>
						<button type="button" onclick="loadBoard()">
						<i id="icon" class="fa-solid fa-rotate-right fa"></i>
						</button>
					</form>
		
					<div id="boardlist" class="boardlist">
					<jsp:include page="board/boardSection.jsp" />
					</div>
				</div>
				
				<!-- 반응 속도 테스트 -->
				<div id="speedtest">
					<div id="testbox">
						여기를 눌러 테스트 시작
					</div>
					<div id="listitle">내 기록</div>
					<ul id="resultlist">

					</ul>
				</div>
			</div>
			
		<div class="tabright">
			<ul class="tablisto">
				<li>학교 검색</li>
			</ul>
			<!-- 검색 구역 -->
			<div id="search">
				<form name="search" action="" method="post">
					<input type="text" id="searchInput" required onkeydown="if(event.key === 'Enter') { event.preventDefault(); searchSchool(); }" >
					<button type="button" onclick="searchSchool()">검색</button>
				</form>
				<div id="list" class="list">
					<jsp:include page="search/searchSection.jsp" />
				</div>
			</div>
		</div>
	</div>
	
</div>

<div id="footer">
2025 웹서버개발 202111085 유상현 / 202111096 조준환 / 202315081 조성윤
</div>

</body>
<script>
        let baseServerTime = <%= serverTimeMillis %>; // 서버 기준 시간 (ms)
        let baseClientPerf = 0; // 클라이언트 기준 시작 시간 (ms, 고정됨)
        let uniTime;

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
                uniTime = currentServerTime;
                document.getElementById("serverTime").innerText = formatTime(currentServerTime);
            }, 1);
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
                    document.getElementById("boardlist").innerHTML = xhr.responseText;
                }
            };
            xhr.send();
        }
		
        startUpdatingClock();
        window.onload = loadBoard;
        window.onload=function() { loadList('') }
        
        //탭 클릭 관련 코드
        window.addEventListener("DOMContentLoaded", function () {
            const tabs = document.querySelectorAll(".tablist li");
            const contents = {
              "게시판": document.getElementById("board"),
              "반응 속도 테스트": document.getElementById("speedtest")
            };
			
            function hideAll() {
              for (let key in contents) {
                contents[key].style.display = "none";
              }
              tabs.forEach(tab => tab.classList.remove("active"));
            }
			
            tabs.forEach(tab => {
              tab.style.cursor = "pointer"; // 클릭 가능하게
              tab.addEventListener("click", function () {
                hideAll();
                contents[tab.textContent].style.display = "block";
                tab.classList.add("active");
              });
            });

            // 기본 탭 활성화 (게시판)
            tabs[0].click();
          });
        
        const box = document.getElementById('testbox');
        const resultList = document.getElementById('resultlist');

        let isWaiting = false;      // 초록색 클릭 대기 중인지 여부
        let isReady = false;        // "기다리세요..." 상태인지 여부
        let startTime = 0;
        let timeoutId = null;
		
        //반응 속도 테스트 박스
        box.addEventListener('click', function () {
          if (isWaiting) {
            // 초록색 상태일 때 클릭 : 반응 시간 측정
            const endTime = Date.now();
            const reactionTime = endTime - startTime;
            box.textContent = "현재 기록 : " + reactionTime + "ms";
            box.style.backgroundColor = 'gray';
            isWaiting = false;
            isReady = false;
            addResult(reactionTime);
          } else if (!isReady) {
            // 테스트 처음 시작
            box.textContent = '준비하세요...';
            box.style.backgroundColor = 'darkgray';
            isReady = true;
			
            // 랜덤 1~5초
            const delay = Math.floor(Math.random() * 4000) + 1000;
            timeoutId = setTimeout(() => {
              startTime = Date.now();
              box.textContent = '누르세요!';
              box.style.backgroundColor = 'green';
              isWaiting = true;
            }, delay);
          } else {
            // 너무 빨리 클릭한 경우
            clearTimeout(timeoutId);
            box.textContent = '너무 빨라요! 다시 시작하려면 클릭하세요.';
            box.style.backgroundColor = 'red';
            isReady = false;
            isWaiting = false;
          }
        });
		
        //테스트 기록 추가
        function addResult(time) {
          const li = document.createElement('li');
          li.textContent = time + "ms";
          resultList.prepend(li);
        } 
        
     	// 쿠키 저장 (이름, 값, 유효기간: 일 단위)
        function setCookie(name, value, days) {
          let expires = "";
          if (days) {
            let date = new Date();
            date.setTime(date.getTime() + (days*24*60*60*1000));
            expires = "; expires=" + date.toUTCString();
          }
          document.cookie = name + "=" + encodeURIComponent(value) + expires + "; path=/";
        }
                
        //쿠키 불러오기
        function getCookie(name) {
        	  const cookies = document.cookie.split(';');
        	  for (let c of cookies) {
        	    const [k, v] = c.trim().split('=');
        	    if (k === name) return decodeURIComponent(v);
        	  }
        	  return null;
        }
        
        //드롭박스 분 초기 설정
        window.addEventListener('DOMContentLoaded', function () {
        	  const savedMinute = getCookie("alarmMinute") || 0;
        	  if (savedMinute !== null) {
        	    const select = document.getElementById("minuteSelect");
        	    select.value = savedMinute;
        	  }
        	});
        
        //드롭박스 값 쿠키 저장
        document.getElementById("minuteSelect").addEventListener("change", function () {
        	  const selectedValue = this.value;
        	  setCookie("alarmMinute", selectedValue, 1);
        });
        
        //토글 스위치 상태 확인
        let toggleSwitch = document.getElementById('toggleSwitch');
        let toggleHandle = toggleSwitch.querySelector('.switch-handle');
        let isOn = getCookie("isOn") === "true" || false;
        toggleSwitch.classList.toggle("on", isOn);
		
        //알람 on/off 토글 버튼
        toggleSwitch.addEventListener("click", () => {
          isOn = !isOn;
          setCookie("isOn",isOn, 1);
          
          toggleSwitch.classList.toggle("on", isOn);
          
          if (isOn) {
              startAlarmTimer();  // 알람 타이머 시작
            } else {
              stopAlarmTimer();   // 알람 타이머 중지
            }
        });
        
        //알람 시간을 설정하고 타이머 시작
        function startAlarmTimer() {
        
        //알람음 불러오기
      	const alarmSound = new Audio('alarm.mp3');

          // 1ms초마다 현재 시간 확인
          alarmTimer = setInterval(() => {
            const currentTime = new Date(uniTime);
            const minutes = currentTime.getMinutes();
            const seconds = currentTime.getSeconds();
            alarmTime = parseInt(document.getElementById('minuteSelect').value); // 분 단위 설정
      		

            // 설정한 시간이 되기 4초 전에 알림
            if (isOn && minutes === alarmTime-1 && seconds === 56) { // 4초 전
       		  alarmSound.currentTime = 0; // 알람 시작 시점 초기화
              alarmSound.play(); // 알람 소리 재생
            }

          }, 1); // 1ms초마다 확인
        }

        // 알람 타이머 종료
        function stopAlarmTimer() {
      		isOn = false;
	      	if (typeof alarmTimer !== 'undefined') {
	      	  clearInterval(alarmTimer);
	      	}
        }
</script>
</html>