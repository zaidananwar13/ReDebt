//
//  BubbleView.swift
//  TuruDebt
//
//  Created by Zaidan Anwar on 13/04/23.
//

import SpriteKit
import SwiftUI

struct BubbleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: false)], animation: .default)
    private var persons: FetchedResults<Person>

    @Binding var onFirstTimeView: Bool
    @Binding var onSelectedBubble: Bool
    @Binding var selectedName: String
    @State var datas: [DataItem] = []
    @State var currentDatas: [DataItem] = []
    @State var bubbleScene = BubblesScene()
    @State private var onNewTransactionView = false

    var body: some View {
        if persons.count < 1 {
            FirstTimeView(firstTimer: $onFirstTimeView)
                .onAppear {
                    onFirstTimeView = false
                }
                .navigationDestination(
                    isPresented: $onFirstTimeView) {
                        NewTransactionView().navigationBarBackButtonHidden(true)
                        Text("")
                            .hidden()
                }
        } else {
            VStack {
                HStack {
                    Text("Navigate Your Debt Transaction")
                    Text("Easily")
                        .foregroundColor(.pink)
                }
                .padding(3)
                .fontWeight(.medium)

                HStack {
                    Text("Tap")
                        .foregroundColor(.pink)
                    Text("to see the detail")
                }
                .fontWeight(.light)
                .multilineTextAlignment(.center)
            }.padding()

            SpriteView(scene: bubbleScene)
                .onChange(of: selectedName) { _ in
                    onSelectedBubble = true
                }
                .onAppear {
                    onFirstTimeView = true
                    createScene()
                }

            Spacer()

            VStack {
                Text("^")
                    .fontWeight(.black)
                Text("Slide to Add New Transaction")
                    .fontWeight(.medium)
            }
            .navigationDestination(
                isPresented: $onNewTransactionView) {
                    NewTransactionView()
                    Text("")
                        .hidden()
            }
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            if drag.location.y < -60 {
                                onNewTransactionView = true
                            }
                        }
                )
        }
    }

    func map(minRange: Double, maxRange: Double, minDomain: Double, maxDomain: Double, value: Double) -> Double {
        return minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    }

    func normalizeSize(xPosition: Double, min: Double, max: Double) -> Double {
        print(min)
        return map(minRange: abs(min), maxRange: abs(max), minDomain: 50, maxDomain: 150, value: abs(xPosition))
    }
    
    func updateBubble() {
        var maxx = persons.map { $0.totalDebt }.max() ?? 0
        var minx = persons.map { $0.totalDebt }.min() ?? 0
        let status = datas.isEmpty ? true : false

        datas.removeAll()

        for person in persons where person.totalDebt != 0 {
            if minx == maxx {
                minx = 50
                maxx = 150
            }

            let size = normalizeSize(xPosition: person.totalDebt, min: minx, max: maxx)
            datas.append(
                DataItem(title: person.name ?? "no name", size: size, color: person.totalDebt < 0 ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
            )
        }

        var iteration = 0
        for data in datas {
            if !currentDatas.isEmpty {
                print("[updateBubbble][currentDatas]", currentDatas)
                let isDuplicate = currentDatas.contains(where: {
                    print("[updateBubbble][$0.id]", $0.title)
                    print("[updateBubbble][dataId]", data.title)

                    return $0.title == data.title
                })
                print("[updateBubbble][isDuplicate]", isDuplicate)
                if isDuplicate {
                    continue
                }
            }

            bubbleScene.updateChild(BubbleNode.instantiate(data: data), iteration: iteration, status: status)

            currentDatas.append(DataItem(id: data.id, title: data.title, size: data.size, color: data.color, offset: data.offset))
            iteration += 1
        }
    }

    func createScene() {
        datas = []

        bubbleScene.topOffset = CGFloat(-275)
        bubbleScene.onTap = { value in
            selectedName = value
        }

        bubbleScene.size = CGSize(width: 300, height: 550)
        bubbleScene.scaleMode = .aspectFill

        updateBubble()
    }
}
