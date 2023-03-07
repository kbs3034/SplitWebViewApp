import SwiftUI

struct ContentView: View {
    
    //webview 관련 상태값
    //    @State private var  topWebViews = [WebView]()
    @State private var  topWebViews = [WebView(url:"https://google.com", name:"google")]
    
    private var  bottomWebViews = [WebView(url:"https://chat.openai.com/chat", name:"ChatGPT"),WebView( url:"https://papago.naver.com/", name:"파파고"),WebView(url:"https://google.com", name:"google")]
    
    @State var selectedBottomWebviewIndex = 0
    
    @State var topWebview = WebView(url:"https://google.com", name:"google")
    @State var bottomWebview: WebView? = nil
    
    //팝업 관련 상태값
    @State private var isShowingWebviewAddModal = false
    @State private var showModal = false
    @State var showAlert = false
    
    //플로팅 버튼 관련 상태값
    @State private var buttonPosition = CGPoint(x: 50, y: 50)
    @State private var isExpanded = false;
    @GestureState private var dragOffset = CGSize.zero
    
    //화면 레이아웃 관련 상태값
    @State var topHeight: CGFloat = UIScreen.main.bounds.height * 0.8
    @State var bottomHeight: CGFloat = UIScreen.main.bounds.height * 0.2
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(){
                    topWebview
                }
                .frame(height: topHeight)
                .background(Color.white)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: UIScreen.main.bounds.height * 0.01)
                    .gesture(DragGesture().onEnded({ (value) in
                        withAnimation {
                            resizeArea(value: value)
                        }
                    }))
                
                VStack(){
                    TabView (selection: $selectedBottomWebviewIndex){
                        bottomWebViews[0].tabItem {
                            Image(systemName: "1.circle")
                        }.tag(0)
                        bottomWebViews[1].tabItem {
                            Image(systemName: "2.circle")
                        }.tag(1)
                        bottomWebViews[2].tabItem {
                            Image(systemName: "3.circle")
                        }.tag(2)
                    }
                    
                }
                .frame(height: bottomHeight)
            }.padding(.top,50)
            
            
            
            HStack {
                Spacer()
                if isExpanded {
                    VStack(){
                        HStack{
                            Button(action: {
                                // bottom modal open
                                // 버튼이 클릭되었을 때 실행될 코드
                                topWebview.webView.reload()
                            }) {
                                Text("Refresh")
                            }
                            Button(action: {
                                // bottom modal open
                                // 버튼이 클릭되었을 때 실행될 코드
                                topWebview.webView.evaluateJavaScript("history.back()")
                            }) {
                                Text("Back")
                            }
                        }
                        HStack{
                            Button(action: {
                                // bottom modal open
                                // 버튼이 클릭되었을 때 실행될 코드
                                bottomWebViews[selectedBottomWebviewIndex].webView.reload()
                            }) {
                                Text("Refresh")
                            }
                            Button(action: {
                                // bottom modal open
                                // 버튼이 클릭되었을 때 실행될 코드
                                print(selectedBottomWebviewIndex)
                                bottomWebViews[selectedBottomWebviewIndex].webView.evaluateJavaScript("history.back()")
                            }) {
                                Text("Back")
                            }
                        }
                        
                    }
                }
                Button(action: {
                    print("button click")
                    self.isExpanded.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
            }
            .animation(.spring())
            .padding()
            .cornerRadius(50)
            //            .frame(width: 50, height: 50)
            .offset(x: buttonPosition.x + dragOffset.width, y: buttonPosition.y + dragOffset.height)
            .gesture(DragGesture()
                .updating($dragOffset, body: { (value, dragOffset, _) in
                    dragOffset = value.translation
                })
                    .onEnded({ (value) in
                        withAnimation {
                            let maxWidth = UIScreen.main.bounds.width - 40 // 20 pt of padding on each side
                            let maxHeight = UIScreen.main.bounds.height - 200 // 200 pt from the top
                            buttonPosition.x = max(-maxWidth/2, min(buttonPosition.x + value.translation.width, maxWidth/2))
                            buttonPosition.y = max(-maxHeight/2, min(buttonPosition.y + value.translation.height, maxHeight/2))
                        }
                    })
            )
            
        }
    }
    
    func resizeArea (value:DragGesture.Value) {
        topHeight = min(UIScreen.main.bounds.height * 0.85, topHeight + value.translation.height)
        bottomHeight = UIScreen.main.bounds.height - topHeight
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
