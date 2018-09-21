import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:coletiv_infinite_parking/page/add_session.dart';
import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  @override
  SessionsPageState createState() => SessionsPageState();
}

class SessionsPageState extends State<SessionsPage> {
  @override
  void initState() {
    super.initState();
    _getSessions();
  }

  bool _isLoading = false;
  final List<Session> _sessions = List<Session>();

  void _getSessions() async {
    _updateLoadingState(true);

    List<Session> sessions = await sessionClient.getSessions();

    setState(() {
      _sessions.clear();
      _sessions.addAll(sessions);
    });

    _updateLoadingState(false);
  }

  void _addSession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSessionPage(),
      ),
    ).whenComplete(() {
      _getSessions();
    });
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _getSessions,
          )
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Opacity(
            opacity: _isLoading ? 1.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          Opacity(
            opacity: !_isLoading && _sessions.isEmpty ? 1.0 : 0.0,
            child: Text(
              "You have no active sessions.",
              textAlign: TextAlign.center,
            ),
          ),
          Opacity(
            opacity: !_isLoading && _sessions.isNotEmpty ? 1.0 : 0.0,
            child: ListView.builder(
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _sessions[index].getPlate(),
                  ),
                  subtitle: Text(
                    _sessions[index].getFormattedFinalDate(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addSession,
      ),
    );
  }
}
