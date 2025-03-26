<%@ page import="java.io.*, java.net.*" %>
<%
    String targetUrl = request.getParameter("url");
    String resultMessage = "";
    
    if (targetUrl != null && !targetUrl.isEmpty()) {
        try {
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);  // Set timeout for connection
            connection.setReadTimeout(5000);     // Set timeout for reading response

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                resultMessage = "Successfully connected to " + targetUrl;
            } else {
                resultMessage = "Failed to connect to " + targetUrl + ". Response Code: " + responseCode;
            }
        } catch (IOException e) {
            resultMessage = "Error: Unable to connect to " + targetUrl + ". " + e.getMessage();
        }
    } else {
        resultMessage = "Please enter a URL.";
    }
%>

<form method="GET">
    <label>Enter URL: <input type="text" name="url" value="<%= targetUrl != null ? targetUrl : "" %>"></label>
    <input type="submit" value="Check Connection">
</form>

<%
    out.println("<p>" + resultMessage + "</p>");
%>
