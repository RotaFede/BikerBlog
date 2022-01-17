<html>
	<head>
		<title>Login</title>
	</head>
	<body>
		<% if(session.getAttribute("nome") != null)
				response.sendRedirect(request.getContextPath() + "/home.jsp");
		String registrazione = request.getParameter("registrazione");
		String err = request.getParameter("err");
		if(registrazione!=null)
			if(registrazione.equals("true"))
				out.println("<h3>Registrazione avvenuta con successo</h3>");
		if(err!=null)
			if(err.equals("true"))
				out.println("<h3>Credenziali errate</h3>");
		%>
		<form action="Login" method="post">
			Username: <input type="text" name="username"><br><br>
			Password: <input type="password" name="psw" id = "psw">
			<input type="checkbox" onclick="mostra()">Mostra Password <br><br>
			<input type="submit" value="Login">
		</form>
		<a href="registra.jsp"> Sei un nuovo utente? Registrati qui </a>
		<script type="text/javascript">
			function mostra(){
				var x = document.getElementById("psw");
				  if (x.type === "password")
					  x.type = "text";
				  else
					  x.type = "password";
			}
		</script>
	</body>
</html>