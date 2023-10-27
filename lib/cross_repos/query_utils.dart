import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:stripes_sandbox_aws/models/DetailResponse.dart';
import 'package:stripes_sandbox_aws/models/Response.dart';

Future<DetailResponse?> ensureDetailChildren(DetailResponse? res) async {
  if (res == null || res.responses != null) return res;
  final GraphQLRequest<PaginatedResult<Response>> request = ModelQueries.list(
      Response.classType,
      where: Response.DETAILRESPONSE.eq(res.id));
  try {
    final GraphQLResponse<PaginatedResult<Response>> response =
        await Amplify.API.query(request: request).response;
    if (response.data != null) {
      final List<Response> children =
          response.data!.items.whereType<Response>().toList();
      return res.copyWith(responses: children);
    }
    safePrint(response.errors);
    return res;
  } catch (e) {
    safePrint(e);
    return null;
  }
}
