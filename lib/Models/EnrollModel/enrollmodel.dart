class EnrollModel{
  final String name;
  final String id;
  final String fatherName;
  final String trackId;
  final String transaction;
  final String status;
  final String feesStatus;

  EnrollModel({
    required this.name,
    required this.id,
    required this.fatherName,
    required this.trackId,
    required this.transaction,
    this.status = "Pending",
    this.feesStatus = "not Paid"
  });

}