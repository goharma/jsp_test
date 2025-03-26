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
    <div>
        <pre>
        <%
            String urlString = request.getParameter("urlInput");
            StringBuilder sslInfo = new StringBuilder();
            StringBuilder responseContent = new StringBuilder();
            int responseCode = -1;
            
            try {
                if (urlString != null && !urlString.trim().isEmpty()) {
                    URL url = new URL(urlString);
                    if (url.getProtocol().equalsIgnoreCase("https")) {
                        HttpsURLConnection httpsConn = (HttpsURLConnection) url.openConnection();
                        httpsConn.setRequestMethod("GET");
                        httpsConn.connect();
                        
                        sslInfo.append("<h2>SSL Certificates:</h2>");
                        for (Certificate cert : httpsConn.getServerCertificates()) {
                            sslInfo.append("Type: ").append(cert.getType()).append("<br>");
                            sslInfo.append("Public Key: ").append(cert.getPublicKey().toString()).append("<br>");
                            sslInfo.append("Encoded: ").append(new String(cert.getEncoded())).append("<br><br>");
                        }
                        
                        responseCode = httpsConn.getResponseCode();
                        BufferedReader in = new BufferedReader(new InputStreamReader(httpsConn.getInputStream()));
                        String inputLine;
                        while ((inputLine = in.readLine()) != null) {
                            responseContent.append(inputLine).append("\n");
                        }
                        in.close();
                    } else {
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        conn.setRequestMethod("GET");
                        responseCode = conn.getResponseCode();
                        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                        String inputLine;
                        while ((inputLine = in.readLine()) != null) {
                            responseContent.append(inputLine).append("\n");
                        }
                        in.close();
                    }
                }
            } catch (SSLException sslEx) {
                sslInfo.append("SSL Error: ").append(sslEx.getMessage()).append("<br>Cause: ").append(sslEx.getCause()).append("<br>Trace:<br>");
                for (StackTraceElement elem : sslEx.getStackTrace()) {
                    sslInfo.append(elem.toString()).append("<br>");
                }
            } catch (Exception e) {
                responseContent.append("Error: ").append(e.getMessage());
            }
            
            out.print(sslInfo.toString());
            out.print("<h2>Response Status Code:</h2><pre>" + responseCode + "</pre>");
            out.print("<h2>Response Received:</h2><pre>" + responseContent.toString() + "</pre>");
        %>
        </pre>
    </div>
</body>
</html>
