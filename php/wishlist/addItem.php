<?php
session_start(); // 세션 시작

//DIR은 현재 php파일의 절대경로를 반환
//main에서 include/require 될 때. 상대경로시 경로가 꼬일 위험존재.
require(__DIR__ . "/../SQLconstants.php"); // DB 정보 포함 파일

// 유저 넘버와 게임 아이디를 POST 방식으로 받아오기
$unum = isset($_POST['usernum']) ? $_POST['usernum'] : null;
$gId = isset($_POST['gameid']) ? $_POST['gameid'] : null;

try {
    // MySQL 연결하기
    $conn = new mysqli($mySQL_host, $mySQL_id, $mySQL_password, $mySQL_database);

    // 연결 오류 확인
    if ($conn->connect_error) {
        die("DB 연결 오류: " . $conn->connect_error);
    }

    // 찜 목록 테이블에 데이터를 추가하는 SQL
    $query = "INSERT INTO wishlist (usernum, game_id) VALUES (?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ss", $unum, $gId); // 두 개의 문자열 파라미터 바인딩

    // SQL 실행 및 결과 확인
    if ($stmt->execute()) {
        // 성공 시 메인 페이지로 리다이렉트
        header("Location: ../main.php");
        exit();
    } else {
        // 실패 시 에러 메시지 출력
        echo "<script>alert('추가 실패'); window.location.href = '../main.php';</script>";
    }

    // 연결 해제
    $stmt->close();
    $conn->close();

} catch (Exception $e) {
    echo "<script>alert('오류 발생: " . htmlspecialchars($e->getMessage()) . "'); window.location.href = '../main.php';</script>";
}
