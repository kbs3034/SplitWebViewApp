import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
        
    let url: String
    let name: String
    let webView: WKWebView
        
    init(url: String, name: String) {
        self.url = url
        self.name = name
        let config = WKWebViewConfiguration()
        config.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Mobile/15E148 Safari/604.1"
        let preferences = WKPreferences()
        preferences.minimumFontSize = 10
        config.preferences = preferences
        let pagePreferences = WKWebpagePreferences()
        pagePreferences.preferredContentMode = .mobile
        config.defaultWebpagePreferences = pagePreferences
        config.allowsInlineMediaPlayback = true
        
        self.webView = WKWebView(frame: .zero, configuration: config)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        if let url = URL(string: url) {
            self.webView.load(URLRequest(url: url))
        }
        
        self.webView.navigationDelegate = context.coordinator
        
        return self.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("update : " , url)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // WKNavigationDelegate 메서드 구현
           func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
               
               print(navigationAction.request.url?.scheme)
               // 유튜브 앱 실행 방지
               if navigationAction.request.url?.scheme == "youtube" {
                   print("cancel")
                   decisionHandler(.cancel)
                   return
               }
               
               print("allow")
               decisionHandler(.allow)
           }
    }
}
