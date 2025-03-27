<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    session.removeAttribute("user");
    response.sendRedirect("../main.jsp");
%>