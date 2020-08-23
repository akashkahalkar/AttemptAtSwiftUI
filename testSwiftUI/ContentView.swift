

struct ContentView : View {
        
    var body: some View {
        
        NavigationView {
            ZStack {
                Image("poster").offset(CGSize(width: 00, height: -30))
//                Color(Color.black.opacity(0.5 ))
                NavigationLink(destination: WAView()) {
