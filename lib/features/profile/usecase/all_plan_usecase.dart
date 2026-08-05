import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

import '../models/response/plan_model.dart';

class AllPlanUsecase {
  final ProfileDatasource profileDatasource;
  AllPlanUsecase({required this.profileDatasource});
  Future<SubscriptionPlansResponse?> call({required String name}) async {
    return await profileDatasource.allSubscriptionPlans(name: name);
  }
}
