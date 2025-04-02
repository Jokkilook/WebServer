<?php
	//세션 시작되었는지 확인. 시작 안되었을 경우만 세션시작
	if (session_status() === PHP_SESSION_NONE)
	{
		session_start();
	}

	//DIR은 현재 php파일의 절대경로를 반환
	//main에서 include/require 될 때. 상대경로시 경로가 꼬일 수 있음
	require(__DIR__ . "/../SQLconstants.php"); // DB 정보 포함 파일
?>

<div id="wishlist">
	<?php
		// 세션에서 유저 정보와 유저넘버를 가져옴
		$user = isset($_SESSION['user']) ? $_SESSION['user'] : null;
		$usernum = isset($_SESSION['usernum']) ? $_SESSION['usernum'] : null;

		if ($user != null) { // 로그인된 상태라면
			try {
				// MySQL 연결하기
				$conn = new mysqli($mySQL_host, $mySQL_id, $mySQL_password, $mySQL_database);

				// 연결 오류 확인
				if ($conn->connect_error) {
					die("DB 연결 오류: " . $conn->connect_error);
				}

				// 찜 목록 조회 SQL
				$query = "SELECT w.usernum, w.game_id, g.game_name FROM wishlist w 
						JOIN game g ON w.game_id = g.game_id 
						WHERE w.usernum = ?";
				$stmt = $conn->prepare($query);
				$stmt->bind_param("s", $usernum);
				$stmt->execute();
				$result = $stmt->get_result();

				// 불러온 찜 목록 게임의 게임 ID를 저장할 배열
				$wishlist = [];

				// 가져온 찜 목록 아이템 들을 출력
				if ($result->num_rows > 0) {
					while ($row = $result->fetch_assoc()) {
						$wishlist[] = $row['game_id'];
						?>
						<div id="wishItem">
							<!-- 아이템을 누르면 해당 게임의 스팀 상점 페이지로 이동 -->
							<div onclick="window.open('https://store.steampowered.com/app/<?= htmlspecialchars($row['game_id']) ?>', '_blank');">
								<?= htmlspecialchars($row['game_name']) ?>
							</div>
							<!-- 삭제 기능을 수행할 폼 (deleteItem.php로 POST 요청) -->
							<!-- 상대경로로 지정할 경우, 경로이탈. 그래서 절대경로로 지정함 -->
							<form action="<?= '/GameWish/wishlist/deleteItem.php' ?>" method="POST">
								<input type="hidden" name="usernum" value="<?= htmlspecialchars($row['usernum']) ?>">
								<input type="hidden" name="gameid" value="<?= htmlspecialchars($row['game_id']) ?>">
								<input type="submit" value="삭제">
							</form>
						</div>
						<?php
					}
				} else {
					// 찜 목록이 비어있으면 메시지 출력
					echo "찜 목록에 게임을 추가해보세요!";
				}

				// 세션에 찜 목록 저장
				$_SESSION['wishlist'] = $wishlist;

				// 연결 해제
				$stmt->close();
				$conn->close();

			} catch (Exception $e) {
				echo "오류 발생: " . htmlspecialchars($e->getMessage());
			}
		} else {
			// 로그인하지 않은 경우
			echo "로그인 후 사용해주세요.";
		}
	?>
</div>
