enum Permission {
  // Ticket
  createTicket,
  viewAllTickets,
  updateTicket,
  deleteTicket,

  // User management
  manageUsers,
  viewUsers,
  updateUsers,
  deleteUsers,

  // Apartment management
  manageApartments,
  viewApartments,
  updateApartments,
  deleteApartments,

  // Condo management
  searchCondos,
  createCondo,
  updateCondo,
  deleteCondo,

  // Visitor management
  manageVisitors,
  viewVisitors,
  updateVisitors,
  deleteVisitors,

  // Mail management
  manageMail,
  viewMail,
  updateMail,
  deleteMail,

  // Reports
  viewReports,
  exportReports,

  // Notifications
  manageNotifications,
  viewNotifications,

  // Admin access
  adminAccess,
  systemSettings,

  // Profile
  updateProfile,
  viewProfile,
}
