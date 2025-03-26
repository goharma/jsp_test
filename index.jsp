<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, javax.net.ssl.SSLException, javax.net.ssl.HttpsURLConnection, java.security.cert.Certificate" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Text Request JSP</title>
</head>
<body>
    <form method="post">
        <label>Enter URL:</label>
        <input type="text" name="urlInput" required>
        <input type="submit" value="Send Request">
    </form>
    <hr>
    <h2>SSL Certificates Received:</h2>
    <div>
        <pre>
        <%
            String urlString = request.getParameter("urlInput");
            HttpsURLConnection httpsConn = null;
            try {
                if (urlString != null && !urlString.trim().isEmpty()) {
                    URL url = new URL(urlString);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    int responseCode = conn.getResponseCode();
                    
                    if (conn instanceof HttpsURLConnection) {
                        httpsConn = (HttpsURLConnection) conn;
                        httpsConn.connect();
                    }
                    
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    String inputLine;
                    StringBuilder content = new StringBuilder();
                    while ((inputLine = in.readLine()) != null) {
                        content.append(inputLine).append("\n");
                    }
                    in.close();
                    
                    out.print("<h2>Response Status Code:</h2><pre>" + responseCode + "</pre>");
                    out.print("<h2>Response Received:</h2><pre>" + content.toString() + "</pre>");
                }
            } catch (SSLException sslEx) {
                out.print("SSL Error: " + sslEx.getMessage() + "<br>Cause: " + sslEx.getCause() + "<br>Trace:<br>");
                for (StackTraceElement elem : sslEx.getStackTrace()) {
                    out.print(elem.toString() + "<br>");
                }
            } catch (Exception e) {
                out.print("Error: " + e.getMessage());
            }
            
            // Always attempt to print SSL certificates if available
            if (httpsConn != null) {
                try {
                    out.print("<h2>SSL Certificates:</h2>");
                    for (Certificate cert : httpsConn.getServerCertificates()) {
                        out.print("Type: " + cert.getType() + "<br>");
                        out.print("Public Key: " + cert.getPublicKey().toString() + "<br>");
                        out.print("Encoded: " + new String(cert.getEncoded()) + "<br><br>");
                    }
                } catch (Exception certEx) {
                    out.print("Error retrieving SSL certificates: " + certEx.getMessage());
                }
            }
        %>
        </pre>
    </div>
</body>
</html>
