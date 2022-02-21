<html>
	<head>
		<title>Dettaglio</title>
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
		<%@ page import="java.sql.*" %>
		<%@ page import="javax.servlet.ServletException" %>
		<%@ page import="javax.servlet.annotation.WebServlet" %>
		<%@ page import="javax.servlet.http.*" %>
		<% if (session.getAttribute("nome") != null){
				int id = Integer.parseInt(request.getParameter("id"));
				String opz = request.getParameter("opz");
				try {
		            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
		        } catch (ClassNotFoundException e) {
		            out.println("<p>Errore: Impossibile caricare il Driver Ucanaccess</p>");
		        }
		        Connection connection = null;
				try{
		            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "user.accdb");
		            Statement st = connection.createStatement();
		            //out.println("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/"));
		            session = request.getSession();
		            if(id!=0){
		            	String query="SELECT Post.Titolo, Post.Descrizione, Post.Distanza, Post.Tempo, Comuni.Nome, Provincie.Provincie, Regioni.Nome FROM Utenti INNER JOIN (((Regioni INNER JOIN Provincie ON Regioni.ID = Provincie.Regione) INNER JOIN Comuni ON Provincie.ID = Comuni.Provincia) INNER JOIN Post ON Comuni.ID = Post.Comune) ON Utenti.Username = Post.Utente WHERE POST.ID=" + id;
		            	ResultSet rs = st.executeQuery(query);
			            while(rs.next()) {
			    			out.println("<h1>"+ rs.getString(1)+"</h1>");
			    			out.println("<p><b>"+ rs.getString(5)+","+rs.getString(6)+","+rs.getString(7)+"</b></p>");
			    			out.println("<p>"+rs.getString(2)+"</p>");
			    			if(rs.getString(3)!=null)
			    				out.println("<p>Distanza:"+rs.getString(3)+" Km</p>");
			    			if(rs.getString(4)!=null)
			    				out.println("<p>Tempo:"+rs.getString(4)+" h</p>");
			            }
			            query = "SELECT Round(AVG(Votazione),1) AS Media, Count(ID) AS Voti FROM Voti WHERE Post=" + id + " GROUP BY Post";
			            rs = st.executeQuery(query);
			            while(rs.next())
			            	out.println("Voto medio: " + rs.getString("Media") + " (" + rs.getString("Voti") + " voti fatti)");
			            if(opz!=null){
			            	if(opz.equals("ok"))
			            		out.println("Voto aggiunto");
			            	else{
			            		if(opz.equals("no"))
			            			out.println("Non puoi votare 2 volte");
			            		else
			            			out.println("Impossibile votare. Riprova");
			            	}
			            }
			            out.println("<form action='aggiungiVoto' method='get'>");
			            out.println("<input type='number' step='any' min='1' max='10' name='voto' placeholder='7.4' required>");
						out.println("<input type='hidden' name='user' value='"+session.getAttribute("user")+"'>");
						out.println("<input type='hidden' name='post' value='"+id+"'>");
						out.println("<input type='submit' value='Vota'>");
						out.println("</form>"); 
		           	}
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
              }else 
               		response.sendRedirect(request.getContextPath() + "/index.jsp");
                %>
	</body>
</html>