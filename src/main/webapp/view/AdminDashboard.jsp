<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | InternConnect</title>
    <link rel="stylesheet" href="../assets/css/admin_dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="dashboard-container">

    <!-- Sidebar -->
    <aside class="sidebar">
        <h2 class="sidebar-title"><i class="fa fa-chart-line"></i> Admin Portal</h2>
    <ul class="sidebar-menu">
    <li><i class="fa fa-home"></i> Overview</li>
    <li class="active"><i class="fa fa-briefcase"></i> Jobs</li>
    <li><i class="fa fa-users"></i> Users</li>
    <li><a href="index.jsp"><i class="fa fa-sign-out-alt"></i> Logout</a></li>
</ul>

    </aside>

    <!-- Main Content -->
    <main class="main-content">

        <!-- Header -->
        <div class="dashboard-header">
            <div>
                <h1>Dashboard</h1>
                <p>Welcome back, Admin</p>
            </div>
            <div class="search-profile-wrapper">
                <div class="search-input-container">
                    <i class="fa fa-search"></i>
                    <input type="text" placeholder="Search...">
                </div>
                <div class="profile-icon">
                    <i class="fa fa-user"></i>
                </div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-cards">
            <div class="card">
                <i class="fa fa-briefcase"></i>
                <h3>248</h3>
                <p>Total Jobs</p>
            </div>
            <div class="card">
                <i class="fa fa-users"></i>
                <h3>1,257</h3>
                <p>Active Users</p>
            </div>
            <div class="card">
                <i class="fa fa-clock"></i>
                <h3>23</h3>
                <p>Pending Approval</p>
            </div>
            <div class="card">
                <i class="fa fa-exclamation-circle"></i>
                <h3>5</h3>
                <p>Reported Issues</p>
            </div>
        </div>

        <!-- Recent Jobs Table -->
        <div class="section">
            <h2>Recent Job Postings</h2>
            <table>
                <thead>
                    <tr>
                        <th>Job Title</th>
                        <th>Company</th>
                        <th>Status</th>
                        <th>Posted Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Senior React Developer</td>
                        <td>TechCorp Inc.</td>
                        <td><span class="badge pending">Pending</span></td>
                        <td>Mar 15, 2024</td>
                        <td><i class="fa fa-check-circle"></i> <i class="fa fa-times-circle"></i></td>
                    </tr>
                    <tr>
                        <td>UX Designer</td>
                        <td>Design Studio</td>
                        <td><span class="badge approved">Approved</span></td>
                        <td>Mar 14, 2024</td>
                        <td><i class="fa fa-check-circle"></i> <i class="fa fa-times-circle"></i></td>
                    </tr>
                    <tr>
                        <td>Product Manager</td>
                        <td>StartUp Labs</td>
                        <td><span class="badge rejected">Rejected</span></td>
                        <td>Mar 13, 2024</td>
                        <td><i class="fa fa-check-circle"></i> <i class="fa fa-times-circle"></i></td>
                    </tr>
                    <tr>
                        <td>Frontend Developer</td>
                        <td>WebTech Solutions</td>
                        <td><span class="badge pending">Pending</span></td>
                        <td>Mar 12, 2024</td>
                        <td><i class="fa fa-check-circle"></i> <i class="fa fa-times-circle"></i></td>
                    </tr>
                    <tr>
                        <td>DevOps Engineer</td>
                        <td>Cloud Systems</td>
                        <td><span class="badge approved">Approved</span></td>
                        <td>Mar 11, 2024</td>
                        <td><i class="fa fa-check-circle"></i> <i class="fa fa-times-circle"></i></td>
                    </tr>
                    <tr>
                        <td>Data Analyst</td>
                        <td>DataSphere Inc.</td>
                        <td><span class="badge pending">Pending</span></td>
                        <td>Mar 10, 2024</td>
                        <td><i class="fa fa-check-circle"></i> <i class="fa fa-times-circle"></i></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Active Users -->
        <div class="section">
            <h2>Active Users</h2>
            <div class="users-list">
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4>John Smith</h4>
                        <p>Full Stack Developer</p>
                        <span class="status-badge status-active">Active</span>
                    </div>
                </div>
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4>Sarah Johnson</h4>
                        <p>UI Designer</p>
                        <span class="status-badge status-active">Active</span>
                    </div>
                </div>
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4>Michael Brown</h4>
                        <p>Product Manager</p>
                        <span class="status-badge status-away">Away</span>
                    </div>
                </div>
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4>Emily Davis</h4>
                        <p>Frontend Developer</p>
                        <span class="status-badge status-active">Active</span>
                    </div>
                </div>
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4>David Wilson</h4>
                        <p>DevOps Engineer</p>
                        <span class="status-badge status-active">Active</span>
                    </div>
                </div>
                <div class="user-card">
                    <i class="fa fa-user-circle"></i>
                    <div>
                        <h4>Lisa Anderson</h4>
                        <p>UX Researcher</p>
                        <span class="status-badge status-away">Away</span>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

</body>
</html>
