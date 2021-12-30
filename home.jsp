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
		            String query = "SELECT * FROM Post ORDER BY DataCreazione DESC;"; 
		            ResultSet rs = st.executeQuery(query);
		            out.println("<table><th>Titolo</th><th>Descrizione</th><th>Utente</th>");
		            while(rs.next()) {
		    			out.println("<tr>");
		            	out.println("<td>" + rs.getString(3) + "</td>");
		            	out.println("<td>" + rs.getString(4) + "</td>");		            		
		            	out.println("<td>" + rs.getString(2) + "</td>");
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