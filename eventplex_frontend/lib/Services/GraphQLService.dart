import 'package:graphql/client.dart';

class GraphQLService {
  late GraphQLClient client;

  GraphQLService() {
    HttpLink link = HttpLink(
      // 'https://eventplex.onrender.com/graphql',
      'http://localhost:3001/graphql',
        defaultHeaders: {'Content-Type': 'application/json'});

    client = GraphQLClient(link: link, cache: GraphQLCache());
  }

  Future<QueryResult> performQuery(
      String query, Map<String, dynamic> variables) async {
    var result;
    try {
      QueryOptions options =
          QueryOptions(document: gql(query), variables: variables);
      result = await client.query(options);
      return result;
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<QueryResult> performMutation(
      String query, Map<String, dynamic> variables) async {
    MutationOptions options =
        MutationOptions(document: gql(query), variables: variables);

    final result = await client.mutate(options);

    print(result);

    return result;
  }
}
