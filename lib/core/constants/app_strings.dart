/// Application-wide string constants.
class AppStrings {
  AppStrings._();

  // ── App ──────────────────────────────────────────────────────────
  static const String appName = 'Leave Manager';

  // ── Auth ─────────────────────────────────────────────────────────
  static const String signIn = 'Sign in';
  static const String signOut = 'Sign out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String emailHint = 'you@school.com';
  static const String passwordHint = 'Enter your password';
  static const String forgotPassword = 'Forgot password?';
  static const String signingIn = 'Signing in…';

  // ── Navigation ───────────────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navApply = 'Apply';
  static const String navCalendar = 'Calendar';
  static const String navHistory = 'History';
  static const String navProfile = 'Profile';
  static const String navApprovals = 'Approvals';
  static const String navTeam = 'Team';
  static const String navReports = 'Reports';
  static const String navSettings = 'Settings';

  // ── Dashboard ────────────────────────────────────────────────────
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';
  static const String leaveBalance = 'Leave balance';
  static const String viewAll = 'View all';
  static const String quickActions = 'Quick actions';
  static const String recentLeaves = 'Recent leaves';
  static const String seeAll = 'See all';
  static const String applyLeave = 'Apply leave';
  static const String checkStatus = 'Check status';
  static const String myHistory = 'My history';
  static const String profile = 'Profile';

  // ── Leave Types ──────────────────────────────────────────────────
  static const String annual = 'Annual';
  static const String annualLeave = 'Annual leave';
  static const String sick = 'Sick';
  static const String sickLeave = 'Sick leave';
  static const String casual = 'Casual';
  static const String casualLeave = 'Casual leave';
  static const String compOff = 'Comp off';
  static const String unpaid = 'Unpaid';
  static const String unpaidLeave = 'Unpaid';

  // ── Balance labels ───────────────────────────────────────────────
  static const String ofDays = 'of {total} days';
  static const String earned = 'earned';
  static const String available = 'available';

  // ── Apply Leave ──────────────────────────────────────────────────
  static const String applyForLeave = 'Apply for leave';
  static const String leaveType = 'Leave type';
  static const String duration = 'Duration';
  static const String startDate = 'Start date';
  static const String endDate = 'End date';
  static const String selectStartDate = 'Select start date';
  static const String selectEndDate = 'Select end date';
  static const String fullDay = 'Full day';
  static const String halfDay = 'Half day';
  static const String reason = 'Reason';
  static const String reasonHint = 'Briefly describe your reason...';
  static const String attachDocument = 'Attach document';
  static const String attachSubtitle = 'Medical cert, etc. (optional)';
  static const String upload = 'Upload';
  static const String submitRequest = 'Submit request';

  // ── History ──────────────────────────────────────────────────────
  static const String myLeaveHistory = 'My leave history';
  static const String historyTitle = '2026 history';
  static const String used = 'Used';
  static const String remaining = 'Remaining';
  static const String pending = 'Pending';

  // ── Status Pills ─────────────────────────────────────────────────
  static const String statusApproved = 'Approved';
  static const String statusPending = 'Pending';
  static const String statusRejected = 'Rejected';

  // ── Calendar ─────────────────────────────────────────────────────
  static const String upcomingEvents = 'Upcoming events';
  static const String publicHoliday = 'Public holiday';
  static const String myLeave = 'My leave';
  static const String holiday = 'Holiday';
  static const String today = 'Today';

  // ── Manager ──────────────────────────────────────────────────────
  static const String pendingApprovals = 'Pending approvals';
  static const String approve = 'Approve';
  static const String reject = 'Reject';
  static const String teamOverview = 'Team overview';
  static const String total = 'Total';
  static const String working = 'Working';
  static const String onLeave = 'On leave';
  static const String leaveReports = 'Leave reports';

  // ── Errors ───────────────────────────────────────────────────────
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String sessionExpired = 'Session expired. Please sign in again.';
  static const String fieldRequired = 'This field is required.';
  static const String invalidEmail = 'Enter a valid email address.';
}
