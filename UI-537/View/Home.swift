//
//  Home.swift
//  UI-537
//
//  Created by nyannyan0328 on 2022/04/12.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @State var currentTab : String = "BTC"
    @Namespace var animation
    @StateObject var model = AppViewModel()
    var body: some View {
        VStack{
            
            if let coins = model.coins,let coin = model.currentConin{
                
                HStack(spacing:15){
                    
                    
                    
                    
                    
                    
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                       
                    
                       
                       
                    
                    VStack(alignment: .leading, spacing: 13) {
                        
                        Text(coin.name)
                            .font(.title.weight(.light))
                        
                        Text(coin.symbol.uppercased())
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    
                }
                .lLeading()
                
                
                customController(conins: coins)
                
                
                VStack(alignment: .leading, spacing: 13) {
                    
                    Text(coin.current_price.convertCurrency())
                        .font(.largeTitle.bold())
                    
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%.2f", coin.price_change))")
                        .font(.caption.bold())
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.vertical,10)
                        .padding(.horizontal,13)
                        .background{
                            
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color("LightGreen"))
                        }
                }
                .lLeading()
                
                
                
              GraphView(coin:coin)
                
                controls()
                
                
            }
            else{
                
                ProgressView()
                    .tint(Color("LightGreen"))
            }
                
            
        
        }
        .padding()
        .maxHW()
        
    }
    @ViewBuilder
    func GraphView(coin : CryptonModel)->some View{

        GeometryReader{_ in
            
            LinearGraph(data: coin.last_7days_price.price,profit: coin.price_change > 0)


        }
    }
    @ViewBuilder
    func customController(conins : [CryptonModel])->some View{
         
          
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing:16){
                
                ForEach(conins){coin in
                    
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentTab == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical,10)
                        .padding(.horizontal,15)
                        .contentShape(Rectangle())
                        .background{
                            
                            if currentTab == coin.symbol.uppercased(){
                                
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.gray)
                                    .matchedGeometryEffect(id: "SEGMENTTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            
                            withAnimation{
                                model.currentConin = coin
                                currentTab = coin.symbol.uppercased()
                            }
                        }
                }
                
            }
        }
        .background{
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(.white.opacity(0.1),lineWidth: 2)
            
        }
        .padding(.vertical)
        
        
    }
    
    @ViewBuilder
    func controls()->some View{
        
        
        HStack(spacing:10){
            
            Button {
                
            } label: {
                
                Text("Sell")
                    .foregroundColor(.black)
                    .padding(.vertical,20)
                    .lCenter()
                    .background{
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }
            
            Button {
                
            } label: {
                
                Text("Buy")
                    .foregroundColor(.blue)
                    .padding(.vertical,20)
                    .lCenter()
                    .background{
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("LightGreen"))
                    }
            }

        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View{
    
    func getRect()->CGRect{
        
        
        return UIScreen.main.bounds
    }
    
    func lLeading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    func lTreading()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .trailing)
    }
    func lCenter()->some View{
        
        self
            .frame(maxWidth:.infinity,alignment: .center)
    }
    
    func maxHW()->some View{
        
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity)
        
    
    }

 func maxTop() -> some View{
        
        
        self
            .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
            
    }
    
}

extension Double{
    
    func convertCurrency()->String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
