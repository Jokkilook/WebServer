<?php
session_start(); // 세션 시작

// 세션에 저장된 유저 정보를 지우기
unset($_SESSION['user']);      // 유저 이름 제거
unset($_SESSION['usernum']);    // 유저 넘버 제거
unset($_SESSION['wishlist']);   // 찜 목록 제거

// 또는 세션 전체를 지우고 싶다면
// session_unset();  // 모든 세션 변수를 제거
// session_destroy(); // 세션을 완전히 파괴

// 메인 페이지로 리다이렉트
header("Location: ../main.php");
exit(); // 리다이렉트 후 코드 실행 방지
