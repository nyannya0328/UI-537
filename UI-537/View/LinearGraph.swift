//
//  LinearGraph.swift
//  UI-312 (iOS)
//
//  Created by nyannyan0328 on 2021/09/21.
//

import SwiftUI

struct LinearGraph: View {
    var data : [Double]
    @State var currentPlot = ""
    @State var offset : CGSize = .zero
    @State var showPlot = false
    
    @State var translation : CGFloat = 0
    
    @GestureState var isDragging : Bool = false
    
    @State var profit : Bool = false
    
    @State var graphProgress : CGFloat = 0
    var body: some View {
        GeometryReader{proxy in
            let height = proxy.size.height
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            
            let minPoint = (data.min() ?? 0)
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
                
                
                
                let pathHight = progress * (height - 50)
                let pathWidth = width * CGFloat(item.offset)
                
                
                
                return CGPoint(x: pathWidth, y: -pathHight + height)
                
                
                
                
                
            }
            
            ZStack{
                
                
                AnimatedGraph(progress: graphProgress, points: points)
              
                .fill(
                
                
                LinearGradient(colors: [
                
                    profit ? Color("Profit") : Color("Loss"),
                    profit ? Color("Profit") : Color("Loss"),
                    
                    
                
                ], startPoint: .leading, endPoint: .trailing)
                
                
                )
                
                
                FILBG()
                
                    .clipShape(
                    
                    
                        Path{path in
                            
                            
                            path.move(to: CGPoint(x: 0, y: 0))
                            
                            path.addLines(points)
                            
                            path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                            path.addLine(to: CGPoint(x: 0, y: height))
                        }
                    
                    )
                    .opacity(graphProgress)
                
                
                
                
            }
         
            
            
            .overlay(
            
                VStack(spacing:0){
                    
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .background(Color("Gradient1"),in:Capsule())
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                       
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top,5)
                    
                    
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 25, height: 25)
                        .overlay(
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 10, height: 10)
                        
                        
                        
                        )
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 50)
                
                    
                    
                    
                    
                }
                    .frame(width: 80, height: 170)
                    .offset(y: 70)
                    .offset(offset)
                   .opacity(showPlot ? 1 : 0)
                 
                
                ,alignment: .bottomLeading
            
            )
            .contentShape(Rectangle())
            .gesture(
            
                DragGesture().onChanged({ value in
                    
                    withAnimation{showPlot = true}
                    
                    
                    let translation = value.location.x - 20
                    
                    let index = max( min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                    
                    currentPlot = "$\(data[index])"
                    
                    self.translation = translation
                    
                    offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
                    
                    
                })
                    .onEnded({ value in
                        
                        withAnimation{showPlot = false}
                        
                    })
                    .updating($isDragging, body: { value, out, _ in
                        out = true
                    })
                
            )
            
            
            
            
        }
        
        .background(
        
            VStack(alignment:.leading){
                
                
                
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                
                Text(max.convertCurrency())
                    .font(.caption.bold())
                    .offset(y: -5)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(min.convertCurrency())
                        .font(.caption.bold())
                   
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
           
                
                
            
            }
            
             
                .frame(maxWidth: .infinity,alignment: .leading)
        
        )
        .padding(.horizontal,10)
        .onChange(of: isDragging) { newValue in
            
            if !isDragging{showPlot = false}
        }
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                
                withAnimation(.easeInOut(duration: 1.2)){
                    
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { newValue in
            
            graphProgress = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                
                withAnimation(.easeInOut(duration: 1.2)){
                    
                    graphProgress = 1
                }
            }
            
        }
        
      
    }
    @ViewBuilder
    func FILBG()->some View{
        let color =  profit ? Color("Profit") : Color("Loss")
        
        LinearGradient(colors: [
            
         
        
                color.opacity(0.3),
                color.opacity(0.2),
                color.opacity(0.1),
                color.opacity(0.3),
    
        
        ] + Array(repeating: Color("Gradient1").opacity(0.1), count: 4) + Array(repeating: Color.clear.opacity(0.1), count: 2), startPoint: .top, endPoint: .bottom)
        
        
    }
}

struct LinearGraph_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct AnimatedGraph : Shape{
    var progress : CGFloat
    let points : [CGPoint]
    
    var animatableData: CGFloat{
    get{return progress}
    set{progress = newValue}
        
    }
    
    func path(in rect: CGRect) -> Path {
        
        Path{Path in
            
            
            Path.move(to: CGPoint(x: 0, y: 0))
            Path.addLines(points)
            
            
            
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.3, lineCap: .round, lineJoin: .round))
    }
}
