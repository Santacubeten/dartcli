import 'package:generatorob/enpoint_maker.dart';
import 'package:generatorob/extension.dart';
import 'package:generatorob/helper.dart';
import 'package:generatorob/model_from_json_gen.dart';
import 'package:generatorob/service.dart';
import 'package:generatorob/repository_maker.dart';

void main(List<String> arguments) async {
  // createEndPoint();
  EndPointMaker.create();
  //  var yn = promptForInput("Do you wish to generate model? : [Y/N]");
  //  if (yn.toLowerCase() == "y") {
  //   var baseUrl = EndPointMaker.getBaseUrlAndEndpoints();
  //   // var (baseUrl, endpoint) = EndPointMaker.getBaseUrlAndEndpoints();
  //    print(baseUrl);
  //  }
  // var jsonRes = await ServiceMaker.fetchJsonFormApi(
  //   'jsonplaceholder.typicode.com',
  //   "users/1",
  //   true,
  // );
  // print(DartClassMaker.generateDartClass("user", jsonRes));
  // print(RepositoryMaker.generateRepository("user"));
}
