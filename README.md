# Student Feedback Portal — Java Web Mini Project (MCA)

A complete, beginner-friendly Java Web Application built with **Servlets, JSP, Sessions, and JDBC CRUD operations** connected to a **MySQL database** via XAMPP.

Designed specifically to demonstrate the four core experiments of the **Java Web Application Laboratory Syllabus**:
- **Experiment 1:** HTML Forms, Servlets, and HTTP `GET` & `POST` Request Processing
- **Experiment 2:** `HttpSession` Tracking, Session Creation & Last-Accessed Timestamps, Invalidation
- **Experiment 3:** JSP Directives, Scripting Elements (Declarations, Expressions, Scriptlets), and Implicit Objects
- **Experiment 4:** JDBC CRUD Operations (`CREATE`, `READ`, `UPDATE`, `DELETE`) with Parameterized `PreparedStatement`

---

## 1. Technology Stack

| Component | Technology | Version / Specification |
|---|---|---|
| **Programming Language** | Java SE | JDK 21+ |
| **IDE** | Apache NetBeans | Version 21+ (Maven Web Project) |
| **Web Server / Servlet Container** | Apache Tomcat | Tomcat 10.1.x or Tomcat 11.0.x |
| **Servlet Specification** | Jakarta Servlet API | `jakarta.servlet` (v6.0+) |
| **View Layer** | JavaServer Pages & JSTL | JSP 3.1+ / JSTL 3.0 (Jakarta EE) |
| **Database** | MySQL / MariaDB | Running via XAMPP (Port 3306) |
| **Database Driver** | MySQL Connector/J | 9.2.0 |
| **Build & Dependency Tool** | Apache Maven | Standard Maven WAR packaging |
| **Frontend Framework** | Bootstrap 5 & Custom CSS | Light navy & blue college portal theme |

> **Important (Jakarta EE Standard):** This project strictly uses `jakarta.*` packages (`jakarta.servlet.*`, `jakarta.servlet.http.*`, `jakarta.servlet.jsp.*`), matching Apache Tomcat 10.1 and Tomcat 11. It does not use legacy `javax.*` packages.

---

## 2. Project Directory Structure

```
Project025/
├── pom.xml                                   # Maven dependencies & build configuration
├── README.md                                 # Complete documentation & viva study guide
└── src/
    ├── main/
    │   ├── java/
    │   │   └── com/
    │   │       └── feedback/
    │   │           ├── model/
    │   │           │   ├── Feedback.java     # Feedback JavaBean model
    │   │           │   └── Admin.java        # Admin user JavaBean model
    │   │           ├── dao/
    │   │           │   ├── FeedbackDAO.java  # Full JDBC CRUD (Insert, Select, Update, Delete)
    │   │           │   └── AdminDAO.java     # Admin authentication query & SHA-256 verification
    │   │           ├── servlet/
    │   │           │   ├── FeedbackServlet.java       # Form display (GET) & submission validation (POST)
    │   │           │   ├── ConfirmationServlet.java   # Safe confirmation page display (PRG pattern)
    │   │           │   ├── AdminDashboardServlet.java # Dashboard metrics, search, and category filtering
    │   │           │   ├── FeedbackEditServlet.java   # Feedback detail modification (JDBC UPDATE)
    │   │           │   ├── FeedbackDeleteServlet.java # Feedback record deletion (JDBC DELETE via POST)
    │   │           │   ├── AdminLoginServlet.java     # Admin session login authentication
    │   │           │   ├── AdminLogoutServlet.java    # Admin session invalidation
    │   │           │   ├── SessionDemoServlet.java    # Experiment 2: HttpSession metadata demo
    │   │           │   ├── RequestDemoServlet.java    # Experiment 1: GET vs POST demo
    │   │           │   └── JspDemoServlet.java        # Experiment 3: JSP implicit objects demo
    │   │           ├── filter/
    │   │           │   └── AuthFilter.java   # Session-based authorization filter for admin paths
    │   │           └── util/
    │   │               ├── DBConnectionUtil.java # Thread-safe JDBC Connection factory
    │   │               └── PasswordUtil.java     # SHA-256 password hashing utility
    │   ├── resources/
    │   │   ├── database.sql                  # MySQL database creation & seed data script
    │   │   └── db.properties                 # JDBC configuration (URL, user, password)
    │   └── webapp/
    │       ├── index.jsp                     # Home landing page with syllabus showcases
    │       ├── css/
    │       │   └── style.css                 # Custom college theme styles & star ratings
    │       ├── js/
    │       │   └── main.js                   # Interactive client-side rating & modal handlers
    │       └── WEB-INF/
    │           ├── web.xml                   # Deployment descriptor & 30-min session timeout
    │           ├── includes/
    │           │   ├── header.jsp            # Common HTML head and Bootstrap CDN
    │           │   ├── navbar.jsp            # Responsive navbar with syllabus links
    │           │   └── footer.jsp            # Common footer and scripts
    │           └── views/
    │               ├── feedback-form.jsp     # Feedback input form
    │               ├── confirmation.jsp      # Submission reference confirmation
    │               ├── admin-login.jsp       # Administrator login screen
    │               ├── admin-dashboard.jsp   # Admin metrics table, search, and filter
    │               ├── feedback-edit.jsp     # Feedback editing form
    │               ├── request-demo.jsp      # Experiment 1 GET vs POST interactive demo
    │               ├── session-demo.jsp      # Experiment 2 HttpSession metadata display
    │               └── jsp-demo.jsp          # Experiment 3 JSP elements & 9 implicit objects
    └── test/
        └── java/
            └── com/
                └── feedback/
                    ├── dao/
                    │   ├── FeedbackDAOTest.java  # Automated JUnit test for all CRUD operations
                    │   └── AdminDAOTest.java     # Automated JUnit test for admin authentication
                    └── util/
                        └── PasswordUtilTest.java # Automated JUnit test for SHA-256 hashing
```

---

## 3. Database Setup (MySQL & XAMPP)

### Step 3.1: Start MySQL in XAMPP
1. Open the **XAMPP Control Panel**.
2. Click **Start** next to **MySQL** (Default Port: `3306`).
3. Click **Start** next to **Apache** (Default Port: `80`).

### Step 3.2: Create the Database in phpMyAdmin
1. Open your web browser and navigate to:
   ```
   http://localhost/phpmyadmin
   ```
2. Click on the **SQL** tab at the top.
3. Open the file `src/main/resources/database.sql` from this project, copy its contents, paste them into the SQL query box, and click **Go**.
4. The database `student_feedback_db` with tables `admins` and `feedback` and initial sample records will be created.

### Step 3.3: Configure Database Credentials
Open `src/main/resources/db.properties` and verify your MySQL credentials:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/student_feedback_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata&characterEncoding=UTF-8
db.user=root
db.password=
```
*Note: In standard XAMPP installations, the `root` user has a blank password (`db.password=`). If you have configured a password in phpMyAdmin, update `db.password` accordingly.*

---

## 4. How to Open and Run in Apache NetBeans

### Step 4.1: Open the Project in NetBeans
1. Launch **Apache NetBeans IDE**.
2. Go to **File** &rarr; **Open Project...**
3. Browse to `e:\Mini projects\AIP\Project025` (or wherever this project folder is saved).
4. NetBeans will detect the Maven icon (`student-feedback-portal`). Select it and click **Open Project**.

### Step 4.2: Add Apache Tomcat in NetBeans (One-Time Setup)
1. In NetBeans, open the **Services** tab (next to the Projects tab on the left).
2. Expand **Servers**, right-click **Servers** &rarr; **Add Server...**
3. Select **Apache Tomcat or TomEE** &rarr; Click **Next**.
4. Set the **Server Location** to your Tomcat installation path:
   ```
   C:\Program Files\Apache Software Foundation\Tomcat 11.0
   ```
5. Enter a Tomcat manager username/password (e.g., `admin` / `admin` or leave default) &rarr; Click **Finish**.

### Step 4.3: Build and Run
1. Right-click the `student-feedback-portal` project in NetBeans &rarr; Select **Clean and Build**.
2. Right-click the project &rarr; Select **Run**.
3. If prompted, select your configured **Apache Tomcat** server.
4. NetBeans will package the WAR, deploy it to Tomcat, and automatically launch your browser at:
   ```
   http://localhost:8080/student-feedback-portal/
   ```

---

## 5. Alternative Manual Deployment (Without NetBeans)

You can build and deploy directly using Maven and Tomcat:

### Step 5.1: Build WAR with Maven
Open PowerShell in the project directory:
```powershell
mvn clean package
```
This produces `target/student-feedback-portal.war`.

### Step 5.2: Deploy to Tomcat
Copy `target/student-feedback-portal.war` to Tomcat's `webapps` folder:
```powershell
Copy-Item "target\student-feedback-portal.war" -Destination "C:\Program Files\Apache Software Foundation\Tomcat 11.0\webapps\"
```
Start or restart Tomcat. Tomcat will automatically extract the WAR file and start the application.

---

## 6. Application Pages & URL Mapping Guide

| Page / Feature | URL Path | Servlet / Handler | Purpose |
|---|---|---|---|
| **Home Page** | `/index.jsp` | JSP Direct | Welcome hero banner, syllabus overview cards, and quick navigation |
| **Submit Feedback** | `/feedback` | `FeedbackServlet` (`doGet`) | Displays the feedback submission form with 1–5 star ratings |
| **Save Feedback** | `/submit-feedback` | `FeedbackServlet` (`doPost`) | Validates input, executes JDBC `INSERT`, redirects to confirmation (PRG) |
| **Confirmation** | `/confirmation` | `ConfirmationServlet` | Displays reference ID and summary; refresh-safe |
| **Admin Login** | `/admin-login` | `AdminLoginServlet` | Authentication screen; default credentials: `admin` / `admin123` |
| **Admin Logout** | `/admin-logout` | `AdminLogoutServlet` | Invalidates admin session and redirects to login |
| **Admin Dashboard** | `/admin/dashboard` | `AdminDashboardServlet` | Protected dashboard showing total count, avg rating, table, search & filter |
| **Edit Feedback** | `/feedback/edit` | `FeedbackEditServlet` | Demonstrates JDBC `UPDATE` on existing records |
| **Delete Feedback** | `/feedback/delete` | `FeedbackDeleteServlet` | Demonstrates JDBC `DELETE` with modal prompt (POST only) |
| **Exp 1: GET vs POST** | `/demo-request` | `RequestDemoServlet` | Live side-by-side inspection of GET vs POST headers and parameters |
| **Exp 2: HttpSession** | `/demo-session` | `SessionDemoServlet` | Displays session ID, creation time, last accessed time, and invalidation |
| **Exp 3: JSP Elements** | `/demo-jsp` | `JspDemoServlet` | Live showcase of directives, scriptlets, expressions, and 9 implicit objects |

---

## 7. Syllabus Experiments Mapping & Viva Voce Preparation

### Experiment 1: HTML Forms, Servlets, GET and POST Requests
- **Where is it in code?**
  - Form handling: [`FeedbackServlet.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/servlet/FeedbackServlet.java)
  - Interactive comparison demo: [`RequestDemoServlet.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/servlet/RequestDemoServlet.java) & [`request-demo.jsp`](file:///e:/Mini%20projects/AIP/Project025/src/main/webapp/WEB-INF/views/request-demo.jsp)
- **Viva Questions & Answers:**
  - **Q: What is the difference between HTTP GET and POST?**
    - *Answer:* `GET` sends data appended to the URL query string (`?key=value`), is bookmarkable, cached by browsers, and limited to ~2048 characters. It must be idempotent. `POST` sends data inside the HTTP request body, is not visible in the URL, is not cached, has no size limitation, and is used for state-changing operations like database insertions.
  - **Q: What is the Post/Redirect/Get (PRG) pattern?**
    - *Answer:* PRG is a web development design pattern where a servlet handles a `POST` request (e.g. form submission), performs database insertion, and instead of forwarding directly to a JSP, sends an HTTP 302 redirect (`response.sendRedirect(...)`) to a `GET` confirmation page. This prevents duplicate form submissions if the user refreshes (F5) the browser.

---

### Experiment 2: HttpSession and Session Creation/Last-Accessed Time
- **Where is it in code?**
  - Demo servlet: [`SessionDemoServlet.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/servlet/SessionDemoServlet.java) & [`session-demo.jsp`](file:///e:/Mini%20projects/AIP/Project025/src/main/webapp/WEB-INF/views/session-demo.jsp)
  - Security filter: [`AuthFilter.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/filter/AuthFilter.java)
- **Viva Questions & Answers:**
  - **Q: Why do we need session tracking in web applications?**
    - *Answer:* HTTP is a stateless protocol; the server forgets the client as soon as a request-response cycle completes. `HttpSession` enables the server to store stateful information (e.g., whether the user is logged in as an administrator) across multiple requests from the same client.
  - **Q: How does the server recognize the client between requests?**
    - *Answer:* When `request.getSession(true)` is called, the server generates a unique session ID and sends it to the browser as a cookie named `JSESSIONID`. In subsequent requests, the browser sends this cookie back, allowing Tomcat to look up the existing session object.
  - **Q: What methods do you use to inspect session timestamps?**
    - *Answer:* `session.getCreationTime()` returns the time when the session was created (in milliseconds since epoch), and `session.getLastAccessedTime()` returns the last time the client sent a request associated with this session. Both are formatted into human-readable date-time strings using Java's `java.time` API.
  - **Q: How do you log out a user and destroy the session?**
    - *Answer:* By calling `session.invalidate()`. This removes all session attributes and unbinds the session from the container.

---

### Experiment 3: JSP Elements and Implicit Objects
- **Where is it in code?**
  - Demonstration: [`JspDemoServlet.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/servlet/JspDemoServlet.java) & [`jsp-demo.jsp`](file:///e:/Mini%20projects/AIP/Project025/src/main/webapp/WEB-INF/views/jsp-demo.jsp)
- **Viva Questions & Answers:**
  - **Q: What are the main types of JSP Scripting Elements?**
    - *Answer:*
      1. **Directive (`<%@ ... %>`):** Gives instructions to the JSP container (e.g., `<%@ page import="..." %>`, `<%@ include file="..." %>`, `<%@ taglib ... %>`).
      2. **Declaration (`<%! ... %>`):** Declares variables and methods placed at class scope in the translated servlet.
      3. **Scriptlet (`<% ... %>`):** Contains Java code executed inside the servlet's `_jspService()` method.
      4. **Expression (`<%= ... %>`):** Evaluates an expression and prints the result into the output stream (equivalent to `out.print(...)`, no semicolon at end).
  - **Q: Name the 9 JSP Implicit Objects and their classes:**
    - *Answer:*
      1. `request` (`HttpServletRequest`)
      2. `response` (`HttpServletResponse`)
      3. `session` (`HttpSession`)
      4. `application` (`ServletContext`)
      5. `out` (`JspWriter`)
      6. `config` (`ServletConfig`)
      7. `pageContext` (`PageContext`)
      8. `page` (`Object`, refers to `this` servlet instance)
      9. `exception` (`Throwable`, available only when `isErrorPage="true"`)

---

### Experiment 4: JDBC CRUD Operations using MySQL
- **Where is it in code?**
  - Data Access Object: [`FeedbackDAO.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/dao/FeedbackDAO.java)
  - Connection Utility: [`DBConnectionUtil.java`](file:///e:/Mini%20projects/AIP/Project025/src/main/java/com/feedback/util/DBConnectionUtil.java)
- **Viva Questions & Answers:**
  - **Q: What are the 5 core steps of JDBC?**
    - *Answer:*
      1. Load and register the JDBC Driver (`Class.forName("com.mysql.cj.jdbc.Driver")`).
      2. Establish Connection (`DriverManager.getConnection(url, user, password)`).
      3. Create a Statement or PreparedStatement (`conn.prepareStatement(sql)`).
      4. Execute the Query (`ps.executeUpdate()` for INSERT/UPDATE/DELETE or `ps.executeQuery()` for SELECT).
      5. Process results (`ResultSet`) and close resources (using try-with-resources).
  - **Q: Why use `PreparedStatement` instead of `Statement`?**
    - *Answer:*
      1. **Security:** It prevents SQL Injection by pre-compiling the SQL query structure and safely parameterizing user inputs (`?` placeholders).
      2. **Performance:** Pre-compiled statements are cached and executed faster when run repeatedly.
      3. **Data Type Handling:** Automatically handles escaping of special characters, quotes, and date formatting.
  - **Q: Why use try-with-resources in JDBC?**
    - *Answer:* Resources that implement `AutoCloseable` (like `Connection`, `PreparedStatement`, and `ResultSet`) placed inside `try (...)` are automatically closed when the block finishes, preventing database connection leaks even if an exception occurs.

---

## 8. Automated Test Execution

The project includes automated tests for all business logic, password hashing, and database operations.
Run all tests via:
```powershell
mvn test
```

Test Results Summary:
- `com.feedback.util.PasswordUtilTest`: 2 / 2 Passed (SHA-256 verification)
- `com.feedback.dao.FeedbackDAOTest`: 2 / 2 Passed (Full CRUD lifecycle tested: Insert, Select, Update, Search, Delete, Statistics)
- `com.feedback.dao.AdminDAOTest`: 1 / 1 Passed (Admin authentication tested)
