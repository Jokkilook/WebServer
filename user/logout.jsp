<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    //세션에 저장된 유저 정보를 지우고 main으로 되돌아가기
    session.removeAttribute("user");
    session.removeAttribute("usernum");
    response.sendRedirect("../main.jsp");
%>