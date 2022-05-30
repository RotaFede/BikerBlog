<html>
	<head>
		<title>Home</title>
		<link rel="stylesheet" href="style.css">
	</head>
	<body>
		<!--  inizio nav -->
		<ul>
			<li><a href="home.jsp">BikerBlog</a></li>
			<li><a href="profilo.jsp">Profilo</a></li>
			<li style="align:rigth"><a href="Logout">Esci</a></li>
		</ul>
		<!-- fine nav -->
	
		<%@ page import="java.io.*" %>
		<%@page import="java.io.PrintStream"%>
		<%@ page import="java.sql.*" %>
		<%@ page import="javax.servlet.ServletException" %>
		<%@ page import="javax.servlet.annotation.WebServlet" %>
		<%@ page import="javax.servlet.http.*" %>
		<% if (session.getAttribute("nome") != null){
				out.println("<h1> Benvenuto " + session.getAttribute("nome") + " " + session.getAttribute("cognome") + "</h1>");
				String ricerca = request.getParameter("ricerca");
				String tipo = request.getParameter("tipo");
				try {
		            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
		        } catch (ClassNotFoundException e) {
		            out.println("<p>Errore: Impossibile caricare il Driver Ucanaccess</p>");
		        }
		        Connection connection = null; %>
		        
				<form action="home.jsp" method="get">
					<input type="search" name="ricerca" placeholder="Milano / Lombardia">
					<select name="tipo">
						<option value="Cerca per paese"> Per paese </option>
						<option value="Cerca per provincia"> Per provincia </option>
						<option value="Cerca per regione"> Per regione </option>
					</select>
					<input type="submit" value="Cerca">
				</form>   
				
		     <% try{
		            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "user.accdb");
		            Statement st = connection.createStatement();
		            //out.println("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/"));
		            session = request.getSession();
		            String query="";
		            if(ricerca==null)
		            	query = "SELECT Post.Titolo, SUBSTRING(Post.Descrizione, 1, 60), Post.Distanza, Post.Tempo, Comuni.Nome, Post.Utente, Utenti.Mail, Provincie.Provincie, Regioni.Nome, Post.ID FROM Utenti INNER JOIN (Regioni INNER JOIN (Provincie INNER JOIN (Comuni INNER JOIN Post ON Comuni.ID = Post.Comune) ON Provincie.ID = Comuni.Provincia) ON Regioni.ID = Provincie.Regione) ON Utenti.Username = Post.Utente ORDER BY Post.DataCreazione DESC;";
	            	else if(tipo.equals("Cerca per paese"))
		            	query = "SELECT Post.Titolo, SUBSTRING(Post.Descrizione, 1, 60), Post.Distanza, Post.Tempo, Comuni.Nome, Post.Utente, Utenti.Mail, Provincie.Provincie, Regioni.Nome, Post.ID FROM Utenti INNER JOIN (Regioni INNER JOIN (Provincie INNER JOIN (Comuni INNER JOIN Post ON Comuni.ID = Post.Comune) ON Provincie.ID = Comuni.Provincia) ON Regioni.ID = Provincie.Regione) ON Utenti.Username = Post.Utente WHERE Comuni.Nome like '*"+ricerca+"*'ORDER BY DataCreazione DESC;";
		           	else if(tipo.equals("Cerca per provincia"))
			           	query = "SELECT Post.Titolo, SUBSTRING(Post.Descrizione, 1, 60), Post.Distanza, Post.Tempo, Comuni.Nome, Post.Utente, Utenti.Mail, Provincie.Provincie, Regioni.Nome, Post.ID FROM Utenti INNER JOIN (Regioni INNER JOIN (Provincie INNER JOIN (Comuni INNER JOIN Post ON Comuni.ID = Post.Comune) ON Provincie.ID = Comuni.Provincia) ON Regioni.ID = Provincie.Regione) ON Utenti.Username = Post.Utente WHERE Provincie.Provincie like '*"+ricerca+"*'ORDER BY DataCreazione DESC;";
		           	else if(tipo.equals("Cerca per regione"))
		            	query = "SELECT Post.Titolo, SUBSTRING(Post.Descrizione, 1, 60), Post.Distanza, Post.Tempo, Comuni.Nome, Post.Utente, Utenti.Mail, Provincie.Provincie, Regioni.Nome, Post.ID FROM Utenti INNER JOIN (Regioni INNER JOIN (Provincie INNER JOIN (Comuni INNER JOIN Post ON Comuni.ID = Post.Comune) ON Provincie.ID = Comuni.Provincia) ON Regioni.ID = Provincie.Regione) ON Utenti.Username = Post.Utente WHERE Regioni.Nome like '*"+ricerca+"*'ORDER BY DataCreazione DESC;";
		            ResultSet rs = st.executeQuery(query);
		            out.println("<table><th>Titolo</th><th>Descrizione</th><th>Lunghezza(Km)</th><th>Tempo(h)</th><th>Paese</th><th>Utente</th>");
		            if(session.getAttribute("tipo").equals("admin"))
		            	out.println("<th>Operazione</th>");
		            while(rs.next()) {
		    			out.println("<tr>");
		            	out.println("<td><a href='dettaglio.jsp?id="+rs.getString(10)+"'>" + rs.getString(1) + "</a></td>");
		            	if(rs.getString(2).length()>=60)
		            		out.println("<td>" + rs.getString(2) + "...</td>");
		            	else
		            		out.println("<td>" + rs.getString(2) + "</td>");
		            	if(rs.getString(3)!=null)
		            		out.println("<td>" + rs.getString(3) + "</td>");
		            	else
		            		out.println("<td></td>");
		            	if(rs.getString(4)!=null)
		            		out.println("<td>" + rs.getString(4) + "</td>");
		            	else
		            		out.println("<td></td>");	
		            	out.println("<td title='"+rs.getString(8)+", "+ rs.getString(9)+"'>" + rs.getString(5) + "</td>");
		            	out.println("<td title='"+rs.getString(7)+"'><a href='profilo.jsp?user=" + rs.getString(6) + "'>" + rs.getString(6) +" </a></td>");
		            	
		            	if(session.getAttribute("tipo").equals("admin"))
		            		out.println("<td><a href='Gestione?operazione=elimina&id="+rs.getString(10)+"'>Elimina</a></td>");
		            	out.println("</tr>");
		            }
		            out.println("</table><br><br>");
		        }
		        catch (SQLException ex) {
		            out.println("<p> Errore nella ricerca: " + ex + "</p>");
		            //System.out.print(ex);
		        }
		        finally{
		            if(connection != null){
		                try{
		                    connection.close();
		                }catch(Exception e){out.println(e);}
	                }
                }
              }else 
               		response.sendRedirect(request.getContextPath() + "/index.jsp");
                %>
	</body>
</html>