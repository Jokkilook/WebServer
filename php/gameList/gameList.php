<?php
// 수정 완료
session_start(); // 세션 시작

// 세션에서 값 가져오기
$usernum = isset($_SESSION['usernum']) ? $_SESSION['usernum'] : null;
$wishlist = isset($_SESSION['wishlist']) ? $_SESSION['wishlist'] : array();
$message = "";
$search = "";
$sortColumn = "game_id";
$sortOrder = "ASC";

// 검색, 정렬 기준이 넘어오면 변경
if (isset($_GET['search'])) {
    $search = $_GET['search'];
}
if (isset($_GET['sort'])) {
    $sortColumn = $_GET['sort'];
}
if (isset($_GET['order'])) {
    $sortOrder = $_GET['order'];
}

try {
	//SQLconstants.php 포함
	include("../SQLconstants.php");

    // MySQL 연결
    $conn = new mysqli($mySQL_host, $mySQL_id, $mySQL_password, $mySQL_database);

    // 연결 확인
    if ($conn->connect_error) {
        die("DB 연결 오류: " . $conn->connect_error);
    }

    // 게임 목록 검색 쿼리 준비
    $query = "SELECT * FROM game WHERE game_name LIKE ? ORDER BY $sortColumn $sortOrder;";
    $stmt = $conn->prepare($query);
    $likeSearch = "%" . $search . "%";
    $stmt->bind_param("s", $likeSearch);
    $stmt->execute();
    $result = $stmt->get_result();

    // 결과를 출력하기
    while ($row = $result->fetch_assoc()) {
        $gameId = $row["game_id"];
        $gameName = $row["game_name"];
        $releaseDate = $row["release_date"];
        $developer = $row["developer"];
        $genre = $row["genre"];
        $like = $row["good"];
        $dislike = $row["bad"];
        $playtime = $row["average_playtime"];
        $price = $row["price"];

        // 유저가 로그인 중이고, 찜 목록에 해당 게임이 없으면 버튼 활성화
        $disabled = ($usernum !== null && !in_array($gameId, $wishlist)) ? "" : "disabled";
        ?>

        <!-- 아이템을 누르면 해당 게임의 스팀 상점 페이지로 이동 -->
        <div id="gameItem">
            <div onclick="window.open('https://store.steampowered.com/app/<?= $gameId ?>', '_blank');">
                <?= htmlspecialchars($gameName) ?><br>
                출시일: <?= htmlspecialchars($releaseDate) ?><br>
                개발자: <?= htmlspecialchars($developer) ?><br>
                장르: <?= htmlspecialchars($genre) ?><br>
                좋아요: <?= htmlspecialchars($like) ?><br>
                싫어요: <?= htmlspecialchars($dislike) ?><br>
                평균 플레이 시간: <?= htmlspecialchars($playtime) ?> 시간<br>
                가격: <?= htmlspecialchars($price) ?> USD<br>
            </div>
            
            <!-- 각 게임마다 찜 목록 추가 버튼을 추가 -->
            <form action="./wishlist/addItem.php" method="POST">
                <input type="hidden" name="usernum" value="<?= htmlspecialchars($usernum) ?>">
                <input type="hidden" name="gameid" value="<?= htmlspecialchars($gameId) ?>">
                <input type="submit" value="찜 목록 추가" <?= $disabled ?>>
            </form>
			<br><br><br>
        </div>

        <?php
    }

    // 연결 닫기
    $stmt->close();
    $conn->close();
} catch (Exception $e) {
    $message = $e->getMessage();
    echo "오류 발생: " . htmlspecialchars($message);
}
?>
