import 'ad_login_request.dart';
import 'model_set_doc_action.dart';

class ModelSetDocActionRequest {
  ModelSetDocAction? modelSetDocAction;
  AdLoginRequest? adLoginRequest;

  ModelSetDocActionRequest({
    this.modelSetDocAction,
    this.adLoginRequest,
  });

  Map<String, dynamic> toJson() => {
        'modelSetDocAction': modelSetDocAction?.toJson(),
        'adLoginRequest': adLoginRequest?.toJson(),
      };

  ModelSetDocActionRequest copyWith({
    ModelSetDocAction? modelSetDocAction,
    AdLoginRequest? adLoginRequest,
  }) =>
      ModelSetDocActionRequest(
        modelSetDocAction: modelSetDocAction ?? this.modelSetDocAction,
        adLoginRequest: adLoginRequest ?? this.adLoginRequest,
      );
}
