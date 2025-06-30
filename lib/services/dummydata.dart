class Dummydata{
  static final List<Map<String,String>> allCustomers=[
    {
      'name': 'Jigar Patel',
      'email': 'pateljigar2505@gmail.com',
      'phone': '+91 95746 92421',
      'address': 'Surat, GujMeet arat 395023',
      'companyname': 'JP Corp',
    },
    {
      'name': 'Dhruv Patel',
      'email': 'pateldhruv2505@gmail.com',
      'phone': '+91 95746 92421',
      'address': 'Surat, Gujarat 395023',
      'companyname': 'Stark Industries'
    },
    {
      'name': 'Meet Solanki',
      'email': 'solankimeet@gmail.com',
      'phone': '+91 95746 92421',
      'address': 'Surat, Gujarat 395023',
      'companyname': 'TATA pvt. ltd.'
    }
  ];
  static final List<Map<String,String>> allUser=[
    {'name':'Jigar Patel'},
    {'name':'Dhruv Patel'},
    {'name':'Meet Solanki'},
    {'name':'Vedant Patil'},
  ];
  static final List<Map<String,String>> allLeads=[
    {
      'companyName': 'JP Corp ',
      'status':'Qualified',
      'assignedTo': 'Dhruv Patel',
      'title':'Website Redesign Proposal',
      'phone':'+91 95756 94523',
      'email':'client@jpcorp.com',
      'description':'lead is interested in redesigning company website',
      'customer':'Jigar Patel',
    },
    {
      'companyName': 'Stark Industries ',
      'status':'Converted',
      'assignedTo': 'Meet Solanki',
      'title':'CRM Integration Query',
      'phone':'+91 95756 94523',
      'email':'client@stark.com',
      'description':'Initial contact made for CRM software requirement',
      'customer':'Tony Stark',
    },
    {
      'companyName': 'TATA pvt. ltd. ',
      'status':'Unqualified',
      'assignedTo': 'Jigar Patel',
      'title':'Mobile App Redesign Proposal',
      'phone':'+91 95756 ,94523',
      'email':'client@tata.com',
      'description':'Proposal for redesigning TATA\'s Mobile App',
      'customer':'Dhruv Patel',
    },
  ];

  static List<Map<String,String>> allDeals=
    [
      {
        'title':'Website Redesign for JP Corp',
        'customer':'Meet Solanki',
        'status':'Won',
        'assignedTo': 'Jigar Patel',
        'amount':'1,20,000',
        'description': 'Redesigning the company website with modern UI/UX and mobile responsive.',
        'companyname':'JP Corp'
      },
      {
        'title':'Mobile App for Stark Industries',
        'customer':'Jigar Patel',
        'status':'Lost',
        'amount':'2,50,000',
        'assignedTo': 'Dhruv Patel',
        'description':'Build a cross-platform app to manage inventory and employee schedules.',
        'companyname':'Stark Industries'
      },
      {
        'title':'CRM Implementation for TATA pvt. ltd.',
        'customer':'Dhruv Patel',
        'status':'Lost',
        'assignedTo': 'Meet Solanki',
        'amount': '2,10,000',
        'description':'Deploy a CRM system to track customer instruction and sales',
        'companyname':'TATA pvt. ltd'
      },
      {
        'title':'Mobile App Redesign for JP Corp',
        'customer':'Vedant Patil',
        'status':'Won',
        'amount':'1,25,000',
        'assignedTo': 'Dhruv Patel',
        'description': 'UI overview and performance improvements of the existing app for better user experience',
        'companyname': 'JP Corp'
      },
    ];

  static const List<String> allDealStatus=[
      'Won',
      'Lost',
  ];
  static const List<String> allLeadStatus=[
      'New',
      'Contacted',
      'Qualified',
      'Unqualified',
      'Converted',
      'Unconverted',
  ];

  static List<Map<String,String>> getAllData(){
    return [
      ...allLeads,
      ...allCustomers,
      ...allDeals,
    ];
  }


}