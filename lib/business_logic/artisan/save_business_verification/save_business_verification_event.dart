part of 'save_business_verification_bloc.dart';

abstract class SaveBusinessVerificationEvent extends Equatable {
  const SaveBusinessVerificationEvent();
}

class LoadSaveBusinessVerificationEvent extends SaveBusinessVerificationEvent {
  final String filePath;
  final String isBusinessRegistered;
  final String belongToUnion;
  final String hasPhysicalStore;
  final String businessAddress;

  const LoadSaveBusinessVerificationEvent({
    required this.filePath,
    required this.isBusinessRegistered,
    required this.belongToUnion,
    required this.hasPhysicalStore,
    required this.businessAddress,
  });

  @override
  List<Object> get props => [];
}
