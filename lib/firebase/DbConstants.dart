class Const {
  // db-Collections
  static var userCollection                 = 'Users';
  static var customerCollection             = 'Customers';
  static var leadCollection                 = 'Leads';
  static var dealCollection                 = 'Deals';
  static var noteSubCollection              = 'Notes';
  //General Keys
  static var keyId                          = 'id';
  static var keyName                        = 'name';
  static var keyEmail                       = 'email';
  static var keyphoneNo                     = 'phoneNo';
  static var keyCreatedAt                   = 'createdAt';
  static var keyCreatedBy                   = 'createdBy';
  static var keyModifiedDate                = 'modifiedDate';

  //Users
  static var keyUserPassword                = 'password';
  static var keyUserRole                    = 'role';
  //Customer
  static var keyCompanyName                 = 'companyName';
  static var keyBuildingName                = 'buildingName';
  static var keyArea                        = 'area';
  static var keyCity                        = 'city';
  static var keyState                       = 'state';
  static var keyPincode                     = 'pincode';
  //Leads
  static var keyTitle                       = 'title';
  static var keyStatus                      = 'status';
  static var keyCustomerId                  = 'customerId';
  static var keyDescription                 = 'description';
  static var keyAssignTo                    = 'assignedTo';
  //Deals
  static var keyAmount                      = 'amount';
  static var keyClosedDate                  = 'closedDate';
  static var keyLeadId                      = 'leadId';

  //Notes
  static var keyNoteContent                       = 'content';
}

enum UserRole{
  Admin,
  Manager,
  Staff,
}

enum LeadStatus{
  New,
  Contacted,
  Qualified,
  Unqualified,
  Converted,
  UnConverted,
}

enum DealStatus{
  ProposalSent,
  Negotion,
  ContractSent,
  Won,
  Lost,
}