import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Interface for checking network connectivity status
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using connectivity_plus package
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

/// Injectable module for registering Connectivity
@module
abstract class ConnectivityModule {
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
