import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommunicationService extends StatefulWidget {
  const CommunicationService({Key? key}) : super(key: key);

  static const String id = 'communication_service';

  @override
  State<CommunicationService> createState() => _CommunicationServiceState();
}

class _CommunicationServiceState extends State<CommunicationService> {
  static const platform =
      MethodChannel('com.example.intouch_imagine_cup/communication_services');

  Future<void> _authenticatieClient() async {
    platform.invokeMethod('clientAuthentication');
  }

  Future<void> _createUser() async {
    String userId = await platform.invokeMethod('createIdentity');
    print(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextButton(
          onPressed: _authenticatieClient,
          child: Text('Authenticate Client'),
        ),
        TextButton(
          onPressed: _createUser,
          child: Text('Create User'),
        ),
      ]),
    );
  }
}
