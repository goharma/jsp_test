# jsp_test

```
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, javax.net.ssl.SSLException" %>
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
    <h2>Response:</h2>
    <div>
        <pre>
        <%
            String urlString = request.getParameter("urlInput");
            if (urlString != null && !urlString.trim().isEmpty()) {
                try {
                    URL url = new URL(urlString);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    String inputLine;
                    StringBuilder content = new StringBuilder();
                    while ((inputLine = in.readLine()) != null) {
                        content.append(inputLine).append("\n");
                    }
                    in.close();
                    out.print(content.toString());
                } catch (SSLException sslEx) {
                    out.print("SSL Error: " + sslEx.getMessage() + "<br>Cause: " + sslEx.getCause() + "<br>Trace:<br>");
                    for (StackTraceElement elem : sslEx.getStackTrace()) {
                        out.print(elem.toString() + "<br>");
                    }
                } catch (Exception e) {
                    out.print("Error: " + e.getMessage());
                }
            }
        %>
        </pre>
    </div>
</body>
</html>
```


To package your JSP page as a **WAR (Web Application Archive) file**, follow these steps:

---

### **1. Set Up the Project Structure**
Ensure your project has the correct structure:

```
/MyWebApp
 ├── /WebContent
 │    ├── index.jsp  (Your JSP file)
 │    ├── /WEB-INF
 │         ├── web.xml (Deployment descriptor)
 ├── /src
 ├── /lib
 ├── pom.xml (For Maven projects)
```

**Move your JSP file (`text_request_jsp.jsp`) into the `WebContent` folder.**

---

### **2. Create `web.xml` (Optional)**
Inside the `/WEB-INF` folder, create `web.xml` if it does not exist.

```xml
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
         version="3.0">
    <display-name>MyWebApp</display-name>
    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
</web-app>
```

---

### **3. Build the WAR File Using Maven (If Using Maven)**
If you're using **Maven**, add the following to `pom.xml`:

```xml
<packaging>war</packaging>
```

Then, run:

```sh
mvn clean package
```

The WAR file will be generated in the `target/` directory.

---

### **4. Build the WAR File Manually**
If you are not using Maven, create the WAR manually using the command line.

#### **Navigate to the Project Root Directory:**
```sh
cd /path/to/MyWebApp
```

#### **Compile Java Files (If Any):**
```sh
javac -d WebContent/WEB-INF/classes src/*.java
```

#### **Create the WAR File:**
Run the following command:
```sh
jar cvf MyWebApp.war -C WebContent .
```

This creates `MyWebApp.war` in your current directory.

---

### **5. Deploy the WAR to Tomcat**
1. Copy the `MyWebApp.war` file to Tomcat’s `webapps/` directory.
2. Start Tomcat:
   ```sh
   catalina.sh run
   ```
3. Open your browser and visit:
   ```
   http://localhost:8080/MyWebApp/
   ```

---

That's it! 🚀 Let me know if you need further clarification.
