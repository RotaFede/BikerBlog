<html>
	<head>
		<title>Registrazione</title>	
	</head>
	<body>
		<% if(session.getAttribute("nome") != null)
				response.sendRedirect(request.getContextPath() + "/home.jsp");
			String error = request.getParameter("error");
			if(error!=null){
				if(error.equals("usr"))
					out.println("<h3> Username già in uso da un'altro utente. Usane un'altro oppure <a href='index.jsp'> accedi </a></h3>");
			}
		%>
		<form action="Registrazione" method="post">
			Nome: <input type="text" name="nome" required><br><br>
			Cognome: <input type="text" name="cognome" required><br><br>
			Username: <input type="text" name="username" required><br><br>
			Email: <input type="email" name="mail" required><br><br>
			Password: <input type="password" name="psw" id="psw" required><input type="checkbox" onclick="mostra()">Mostra Password<br><br>
			Moto: <input type="text" name="moto" placeholder="Marca - modello - anno"><br><br>
			<input type="submit" value="Registra">
		</form> 
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