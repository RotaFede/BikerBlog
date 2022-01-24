<html>
	<head>
		<title>Profilo</title>
		<link rel="stylesheet" href="style.css">
	</head>
	<body>
	<%@ page import="java.io.*" %>
	<%@ page import="java.sql.*" %>
	<%@ page import="javax.servlet.ServletException" %>
	<%@ page import="javax.servlet.annotation.WebServlet" %>
	<%@ page import="javax.servlet.http.*" %>
	
	
		<% /* ~\Desktop\java\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\BikerBlog 
			POST:
				ID = rs.getString(1)
				User = rs.getString(2)
				Titolo = rs.getString(3)
				Descrizione = rs.getString(4)
				Data creazione = rs.getString(5)
				km = rs.getString(6)
				tempo = rs.getString(7)	
				img = rs.getString(8)*/
		if(session.getAttribute("nome") == null)
				response.sendRedirect(request.getContextPath() + "/index.jsp");
			else{
				String user = request.getParameter("user");
				String opz = request.getParameter("opz");
				
				out.println("<ul>");
				out.println("<li><a href='home.jsp'>BikerBlog</a></li>");
				if(user==null || session.getAttribute("user").equals(user)){
					out.println("<li><a href='Gestione?operazione=crea'>Crea nuovo post</a></li>");
					out.println("<li><a href='Gestione?operazione=user'>Modifica Profilo</a></li>");
				}
				out.println("<li><a href='Logout'>Esci</a></li>");
				out.println("</ul><br><br>");
				if(opz!=null){
					if(opz.equals("crea"))
						out.println("<h3> Post creato correttamente </h3>");
					else if (opz.equals("modifica"))
						out.println("<h3> Post modificato correttamente </h3>");
					else if(opz.equals("elimina"))
						out.println("<h3> Modifica non valida </h3>");
					else if(opz.equals("user"))
						out.println("<h3> Utente modificato correttamente </h3>");
					else if(opz.equals("invalida"))
						out.println("<h3> Modifica non valida </h3>");
					else if(opz.equals("err"))
						out.println("<h3> Impossibile apportare tale modifica </h3>");
				}
				try {
		            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
		        } catch (ClassNotFoundException e) {
		            out.println("<p>Errore: Impossibile caricare il Driver Ucanaccess</p>");
		        }
		        Connection connection = null;
		        try{
		            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "user.accdb");
		            Statement st = connection.createStatement();
		            session = request.getSession();
		            String query ="";
		            if(user==null || session.getAttribute("user").equals(user))
		            	query = "SELECT Post.Titolo, Post.Descrizione, Post.Distanza, Post.Tempo, Comuni.Nome, Post.ID FROM Comuni INNER JOIN Post ON Comuni.ID = Post.Comune WHERE Utente='" + session.getAttribute("user") +"' ORDER BY DataCreazione DESC;";
		            else
		            	query = "SELECT Post.Titolo, Post.Descrizione, Post.Distanza, Post.Tempo, Comuni.Nome, Post.ID FROM Comuni INNER JOIN Post ON Comuni.ID = Post.Comune WHERE Utente='" + user +"' ORDER BY DataCreazione DESC;";
		            ResultSet rs = st.executeQuery(query);
		            out.println("<table><th>Titolo</th><th>Descrizione</th><th>Lunghezza(Km)</th><th>Tempo(h)</th><th>Paese</th>");
		            if(user==null || session.getAttribute("user").equals(user))
		            	out.println("<th>Operazione</th>");
		            while(rs.next()) {
		    			out.println("<tr>");
		            	out.println("<td>" + rs.getString(1) + "</td>");
		            	out.println("<td>" + rs.getString(2) + "</td>");
		            	if(rs.getString(3)!=null)
		            		out.println("<td>" + rs.getString(3) + "</td>");
		            	else
		            		out.println("<td></td>");
		            	if(rs.getString(4)!=null)
		            		out.println("<td>" + rs.getString(4) + "</td>");
		            	else
		            		out.println("<td></td>");
		            	out.println("<td>" + rs.getString(5) + "</td>");
		            	if(user==null || session.getAttribute("user").equals(user)){
		            		out.println("<td> <a href='Gestione?operazione=modifica&id="+rs.getString(6)+"'>Modifica</a>");
		            		out.println("<a href='Gestione?operazione=elimina&id="+rs.getString(6)+"'>Elimina</a></td>");
		            	}
		            	out.println("</tr>");
		            }
		            out.println("</table>");
		        }
		        catch (SQLException ex) {
		            out.println("<p>" + ex +"</p>");
		        }
		        finally{
		            if(connection != null){
		                try{
		                    connection.close();
		                }catch(Exception e){out.println(e);}
		            }
		        }
				
			}
		%>
	</body>
</html>