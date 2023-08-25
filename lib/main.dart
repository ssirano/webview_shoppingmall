import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping Mall App',
      home: ShoppingWebView(),
    );
  }
}

class ShoppingWebView extends StatefulWidget {

  @override
  _ShoppingWebViewState createState() => _ShoppingWebViewState();
}

class _ShoppingWebViewState extends State<ShoppingWebView> {
  WebViewController? _webViewController;
  bool isLoading = true;

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", "cancel", true, ScanMode.BARCODE,);
    if (barcode != '-1') {
      _webViewController?.loadUrl("https://www.google.com/search?q=$barcode");
    }
  }

  final List<String> urls = [
    'https://www.amazon.com/',
    'https://www.ebay.com/',
    'https://www.walmart.com/',
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Shopping Mall App'),
        actions: [
          IconButton(icon: Icon(Icons.search),
            onPressed: scanBarcode,
          ),
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                if (await _webViewController!.canGoBack()) {
                  _webViewController!.goBack();
                }
              }
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              if (_webViewController != null) {
                if (await _webViewController!.canGoForward()) {
                  _webViewController!.goForward();
                }
              }
            },
          ),
          IconButton(icon: Icon(Icons.refresh),
            onPressed: () {
              _webViewController?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://www.google.com',
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Amazon'),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: 'eBay'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Walmart'),
          ],
          onTap: (index) {
            print("Attempting to load URL: ${urls[index]}");

            setState(() {
              _currentIndex = index;
              isLoading = true; //로딩 인디케이터를 보이게 설정
              _webViewController?.loadUrl(urls[_currentIndex]);
            });
          }
      ),
    );
  }
}

