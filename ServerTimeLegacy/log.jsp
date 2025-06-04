<%@ page language="java" import="java.io.*, java.time.*, jakarta.servlet.*" pageEncoding="utf8"%>
<%!
	public void writeLog(String message, HttpServletRequest request, HttpSession session, ServletContext application) throws IOException {

		String logsDir = application.getRealPath("/WebServer/ServerTimeLegacy/Logs/");
		if (!logsDir.endsWith(File.separator)) logsDir += File.separator;

		final String interlogFileName = logsDir + "log.txt";
		final String daylogFileName = logsDir + LocalDate.now() + "_log.txt";

		BufferedWriter writer = new BufferedWriter(new FileWriter(interlogFileName, true));
		BufferedWriter dayLogWriter = new BufferedWriter(new FileWriter(daylogFileName, true));

		String logMessage = "\n| Time |: " + LocalDate.now() + " " + LocalTime.now()
				+ "\t| IP |: " + request.getRemoteAddr()
				+ "\t| SessionID |: " + session.getId()
				+ "\t| URI |: " + request.getRequestURI()
				+ "\t| Previous |: " + request.getHeader("referer")
				+ "\t| Browser |: " + request.getHeader("User-Agent")
				+ "\t| Message |: " + message;

		writer.append(logMessage);
		dayLogWriter.append(logMessage);

		writer.close();
		dayLogWriter.close();
	}
%>

<%
	String mes = request.getParameter("mes");

	if (mes != null && !mes.equals("")) {
		try {
			writeLog(mes, request, session, application);
		} catch (IOException e) {
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));
			String errorMsg = sw.toString().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
%>
			<script>
				console.error("로그 쓰기 중 예외 발생:\n<%= errorMsg %>");
			</script>
<%
		}
	}
%>
