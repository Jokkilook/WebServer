<%@ page language="java" import="java.io.*, java.time.*" pageEncoding="utf8"%>
<%!
	public void writeLog( String message, HttpServletRequest request, HttpSession session )
	{
		try 
		{
			final String interlogFileName = "/var/lib/tomcat10/webapps/ROOT/WebServer/ServerTime/Logs/log.txt";
			final String daylogFileName = "/var/lib/tomcat10/webapps/ROOT/WebServer/ServerTime/Logs/"+LocalDate.now()+"_log.txt";
			BufferedWriter writer = new BufferedWriter( new FileWriter( interlogFileName, true ) );
			BufferedWriter dayLogWriter = new BufferedWriter( new FileWriter( interlogFileName, true ) );

			// 통합 로그 데이터 출력
			writer.append( "\n| Time |: " + LocalDate.now() + " " + LocalTime.now() 	// 접속 시간
				+ "\t| IP |: "+ request.getRemoteAddr()
				+ "\t| SessionID |: " + session.getId()				// 접속 ID	
				+ "\t| URI |: " + request.getRequestURI()				// 현재 페이지 
				+ "\t| Previous |: " + request.getHeader("referer") 		// 접속 경로(이전페이지)
				+ "\t| Browser |: " + request.getHeader("User-Agent") 		// 접속 브라우저	
				+ "\t| Message |: " + message );
			
			// 로그 데이터 출력
			dayLogWriter.append( "\n| Time |: " + LocalDate.now() + " " + LocalTime.now() 	// 접속 시간
				+ "\t| IP |: "+ request.getRemoteAddr()
				+ "\t| SessionID |: " + session.getId()				// 접속 ID	
				+ "\t| URI |: " + request.getRequestURI()				// 현재 페이지 
				+ "\t| Previous |: " + request.getHeader("referer") 		// 접속 경로(이전페이지)
				+ "\t| Browser |: " + request.getHeader("User-Agent") 		// 접속 브라우저	
				+ "\t| Message |: " + message );

			writer.close();
			dayLogWriter.close();
		} 
		// 예외 처리
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
%>
<%
	String mes = request.getParameter("mes");

	if(mes!=""&&mes!=null){
		writeLog(mes, request, session);	
	}
%>
