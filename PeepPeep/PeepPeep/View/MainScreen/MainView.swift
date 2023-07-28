//
//  MainView.swift
//  PeepPeep
//
//  Created by 이승용 on 2023/07/12.
//
import SwiftUI
import DeviceActivity

extension DeviceActivityReport.Context{
    static let mainActivity = Self("Main Activity")
}

struct MainView: View {
    @State private var context: DeviceActivityReport.Context = .mainActivity
    @State private var showModal = false
    @State private var showModal2 = false
    @State private var filter: DeviceActivityFilter = {
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? now
            let dateInterval = DateInterval(start: startOfDay, end: endOfDay)
        
            return DeviceActivityFilter(
                segment: .daily(during: dateInterval),
                users: .all,
                devices: .init([.iPhone, .iPad])
            )
        }()
    
    var currentUsageTime: CGFloat = 217  // minutes, 사용시간
    var targetUsageTime: CGFloat = 240   // minutes, 목표시간
    
    let lightGray: Color = Color("LightGray")
    
    var body: some View {
        NavigationStack{
            VStack{

                // 도움말 ModalView
                HStack{
                    Button(action: {
                        self.showModal.toggle()
                    }){
                        Text("!")
                            .font(.custom("DOSSaemmul", size: 25))
                            .background(
                                Circle()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(lightGray)
                            )
                            .foregroundColor(.black)
                        
                    }
                    .sheet(isPresented: self.$showModal){
                        HelperView()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                    .padding(EdgeInsets(top: 5, leading: 36, bottom: 5, trailing: 5))
                    Spacer()
                }// 도움말 ModalView
                Spacer()
                                
//                ProgressBarView()
                DeviceActivityReport(context, filter: filter)
                    .frame(width: 300, height: 500, alignment: .center)
                
                
                Spacer()
                
                // 하단 메뉴
                HStack(alignment: .center){
                    Spacer()
                    // 옷장 버튼
                    NavigationLink {
                        CostumesBookView()
                    } label: {
                        VStack{
                            Image("Closet")
                                .resizable()
                                .frame(width: 49, height: 49, alignment: .center)
                            Text("옷장")
                                .foregroundColor(.black)
                                .font(.custom("DOSSaemmul", size: 16))
                        }
                    }

                    Spacer()
                    
                    // 시간설정 버튼
                    NavigationLink {
                        SettingView()
                    } label: {
                        VStack{
                            Image("Setting")
                                .resizable()
                                .frame(width: 49, height: 49, alignment: .center)
                            Text("시간설정")
                                .foregroundColor(.black)
                                .font(.custom("DOSSaemmul", size: 16))
                        }
                    }

                    
                    Spacer()
                    
                    // 성장일지 버튼
                    NavigationLink {
                        DailyFeedBackView(isClick: false, month: Date(), nowDay: Date(), stressLevel: 0)
                    } label: {
                        VStack{
                            Image("Diary")
                                .resizable()
                                .frame(width: 49, height: 49, alignment: .center)
                            Text("성장일지")
                                .foregroundColor(.black)
                                .font(.custom("DOSSaemmul", size: 16))
                        }
                    }
                    Spacer()
                } // 하단 메뉴 HStack
                Spacer()
            }   // VStack
            .onAppear{
                //앱이 처음 다운로드 된 날, 그 날의 목표시간을 유저디폴트에 저장합니다(향후 온보딩 및 초기 설정 페이지로 옮겨야 합니다)
                UserDefaults.shared.set("2023.07.17", forKey: "downloadedDate")
                UserDefaults.shared.set(600, forKey: "2023.07.17")
            }
        }   // NavigationStack
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

