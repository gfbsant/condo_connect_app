enum Permission {
  manageUsers('manage_users'),
  manageAparments('manage_apartments'),
  viewAllTickets('view_all_tickets'),
  createTicket('create_ticket'),
  searchCondos('search_condos'),
  manageVisitors('manage_visitors'),
  manageMail('manage_mail'),
  viewReports('view_reports'),
  adminAccess('admin_access'),
  manageNotifications('manage_notifications');

  const Permission(this.value);

  final String value;

  @override
  String toString() => value;
}
