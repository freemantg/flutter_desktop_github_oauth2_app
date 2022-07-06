import 'package:flutter/material.dart';
import 'package:flutter_desktop_github_app/github_oauth_credentials.dart';
import 'package:flutter_desktop_github_app/src/github_login.dart';
import 'package:flutter_desktop_github_app/src/github_summary.dart';
import 'package:github/github.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Github Client'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
      builder: (context, client) {
        return FutureBuilder<CurrentUser>(
          future: viewerDetails(client.credentials.accessToken),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: GitHubSummary(
                gitHub: _getGithub(client.credentials.accessToken),
              ),
            );
          },
        );
      },
    );
  }
}

Future<CurrentUser> viewerDetails(String accessToken) async {
  final github = GitHub(auth: Authentication.withToken(accessToken));
  return github.users.getCurrentUser();
}

GitHub _getGithub(String accessToken) {
  return GitHub(auth: Authentication.withToken(accessToken));
}
