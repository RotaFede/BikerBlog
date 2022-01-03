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
		<%@ page import="java.sql.*" %>
		<%@ page import="javax.servlet.ServletException" %>
		<%@ page import="javax.servlet.annotation.WebServlet" %>
		<%@ page import="javax.servlet.http.*" %>
		<% if (session.getAttribute("nome") != null){
				out.println("<h1> Benvenuto " + session.getAttribute("nome") + " " + session.getAttribute("cognome") + "</h1>");
				String ricerca = request.getParameter("ricerca");
				try {
		            Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
		        } catch (ClassNotFoundException e) {
		            out.println("<p>Errore: Impossibile caricare il Driver Ucanaccess</p>");
		        }
		        Connection connection = null; %>
		        
				<form action="home.jsp" method="get">
					<input type="search" name="ricerca">
					<input type="submit" value="Cerca">
				</form>   
				
		     <% try{
		            connection = DriverManager.getConnection("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/") + "user.accdb");
		            Statement st = connection.createStatement();
		            //out.println("jdbc:ucanaccess://" + request.getServletContext().getRealPath("/"));
		            session = request.getSession();
		            String query="";
		            if(ricerca==null)
		            	query = "SELECT Titolo, Descrizione, Distanza, Tempo, Utente, Mail, ID FROM Utenti INNER JOIN Post ON Utenti.Username = Post.Utente ORDER BY DataCreazione DESC;";
	            	else
		            	query = "SELECT Titolo, Descrizione, Distanza, Tempo, Utente, Mail, ID FROM Utenti INNER JOIN Post ON Utenti.Username = Post.Utente WHERE Titolo like '*"+ricerca+"*'ORDER BY DataCreazione DESC;";		
		            ResultSet rs = st.executeQuery(query);
		            out.println("<table><th>Titolo</th><th>Descrizione</th><th>Lunghezza</th><th>Tempo</th><th>Utente</th>");
		            if(session.getAttribute("tipo").equals("admin"))
		            	out.println("<th>Operazione</th>");
		            while(rs.next()) {
		    			out.println("<tr>");
		            	out.println("<td>" + rs.getString(1) + "</td>");
		            	out.println("<td>" + rs.getString(2) + "</td>");
		            	if(rs.getString(3)!=null)
		            		out.println("<td>" + rs.getString(3) + " Km</td>");
		            	else
		            		out.println("<td>nd</td>");
		            	if(rs.getString(4)!=null)
		            		out.println("<td>" + rs.getString(4) + " h</td>");
		            	else
		            		out.println("<td>nd</td>");	
		            	if(rs.getString(6)!=null)
		            		out.println("<td title='"+rs.getString(6)+"'>" + rs.getString(5) + "</td>");
		            	else
		            		out.println("<td>" + rs.getString(5) + "</td>");
		            	if(session.getAttribute("tipo").equals("admin"))
		            		out.println("<td><a href='Gestione?operazione=elimina&id="+rs.getString(7)+"'>Elimina</a></td>");
		            	out.println("</tr>");
		            }
		            out.println("</table><br><br>");
		        }
		        catch (SQLException ex) {
		            out.println("<p>" + ex +"</p>");
		        }
		        finally{
		            if(connection != null){
		                try{
		                    connection.close();
		                }catch(Exception e){System.out.println(e);}
	                }
                }
              }else 
               		response.sendRedirect(request.getContextPath() + "/index.jsp");
                %>
	</body>
</html>